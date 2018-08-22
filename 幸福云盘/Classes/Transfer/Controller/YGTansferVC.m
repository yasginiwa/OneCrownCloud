//
//  YGTansferVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTansferVC.h"
#import "YGMenuView.h"
#import "YGSubFileVC.h"
#import "YGFileModel.h"
#import "YGMainTabBarVC.h"
#import "YGUploadCell.h"
#import "YGDownloadCell.h"

@interface YGTansferVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) YGMenuView *menuView;
@property (nonatomic, strong) YGFileModel *uploadFileModel;
@property (nonatomic, strong) YGFileModel *downlaodFileModel;
@property (nonatomic, weak) UITableView *transferTableView;
@property (nonatomic, strong) NSMutableArray *downloadFiles;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@property (nonatomic, assign, getter=isShowingDownload) BOOL showDownload;
@end

@implementation YGTansferVC
#pragma mark - 懒加载
- (NSMutableArray *)downloadFiles
{
    if (_downloadFiles == nil) {
        _downloadFiles = [NSMutableArray array];
    }
    return _downloadFiles;
}

- (NSMutableArray *)uploadFiles
{
    if (_uploadFiles == nil) {
        _uploadFiles = [NSMutableArray array];
    }
    return _uploadFiles;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupMenuView];
    
    [self setupTransferTableView];
    
    [self setupNavBar];
    
    [self addObsvr];
}

- (void)setupMenuView
{
    self.view.backgroundColor = [UIColor whiteColor];
    YGMenuView *menuView = [[YGMenuView alloc] init];
    [self.view addSubview:menuView];
    [menuView uploadAddTarget:self action:@selector(selectedUploadTableView)];
    [menuView downloadAddTarget:self action:@selector(selectDownloadTableView)];
    self.menuView = menuView;
    
    [self selectDownloadTableView];
}

- (void)setupTransferTableView
{
    UITableView *transferTableView = [[UITableView alloc] init];
    transferTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:transferTableView];
    transferTableView.delegate = self;
    transferTableView.dataSource = self;
    self.transferTableView = transferTableView;
}

- (void)selectDownloadTableView
{
    self.showDownload = YES;
    [self.transferTableView reloadData];
    YGLog(@"-selectedDownloadTableView-");
}

- (void)selectedUploadTableView
{
    self.showDownload = NO;
    [self.transferTableView reloadData];
    YGLog(@"-selectedUploadTableView-");
}

- (void)setupNavBar
{
    UIBarButtonItem *mutiSelectItem = [UIBarButtonItem itemWithImage:@"navbar_duoxuan" highImage:@"navbar_duoxuan_press" target:self action:@selector(mutiSelect)];
    self.navigationItem.rightBarButtonItems = @[mutiSelectItem];
}

- (void)addObsvr
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUploadFile:) name:YGAddUploadFileNotification object:nil];
}

- (void)addUploadFile:(NSNotification *)note
{
    YGFileModel *uploadFileModel = note.userInfo[@"uploadFileModel"];
    
    //  因进度不停更改 通知也是不停的接收到 故判断模型的名字 名字不一样才加入uploadFiles数组
    if (![uploadFileModel.name isEqualToString:self.uploadFileModel.name]) {
        [self.uploadFiles addObject:uploadFileModel];
    }
    
    self.uploadFileModel = uploadFileModel;
    [self.uploadFileModel addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YGMainTabBarVC *tabBarVC = (YGMainTabBarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [[[tabBarVC.tabBar items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%lu", self.uploadFiles.count]];
    });
}

- (void)mutiSelect
{
    YGLog(@"--mutiSelect--");
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isShowingDownload) {
        return self.downloadFiles.count;
    } else {
        return self.uploadFiles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowingDownload) {
        static NSString *ID = @"download";
        YGUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [YGUploadCell uploadCell];
        }
        cell.uploadFileModel = self.uploadFiles[indexPath.row];
        return cell;
    } else {
        static NSString *ID = @"upload";
        YGDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [YGDownloadCell downloadCell];
        }
        cell.downloadFileModel = self.downloadFiles[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64.0);
        make.height.equalTo(@40);
    }];
    
    [self.transferTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (void)dealloc
{
    [self removeObserver:self.uploadFileModel forKeyPath:@"uploadProgress"];
}
@end
