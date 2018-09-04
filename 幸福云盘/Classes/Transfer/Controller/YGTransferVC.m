//
//  YGTransferVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTransferVC.h"
#import "YGMenuView.h"
#import "YGSubFileVC.h"
#import "YGFileModel.h"
#import "YGUploadCell.h"
#import "YGDownloadCell.h"
#import "YGMainNavVC.h"
#import "YGSubFileVC.h"

@interface YGTransferVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) YGMenuView *menuView;
@property (nonatomic, strong) YGFileModel *uploadFileModel;
@property (nonatomic, strong) YGFileModel *downloadFileModel;
@property (nonatomic, weak) UITableView *transferTableView;
@property (nonatomic, strong) NSMutableArray *downloadFiles;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@property (nonatomic, assign, getter=isShowingDownload) BOOL showDownload;
@end

@implementation YGTransferVC

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTransferTableView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupMenuView];
    
    [self setupTransferTableView];
    
    [self setupNavBar];
    
    [self setupNotification];
    
    YGLog(@"--transfer--viewDidLoad--");
}

- (void)setupNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideoProgress:) name:YGUploadVideoProgressNotification object:nil];
}

- (void)uploadVideoProgress:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    double progress = [[userInfo objectForKey:@"uploadVideoProgress"] doubleValue];
    self.uploadFileModel.uploadProgress = progress;
    YGLog(@"---------%f", progress);
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

- (void)setupNavBar
{
    UIBarButtonItem *mutiSelectItem = [UIBarButtonItem itemWithImage:@"navbar_duoxuan" highImage:@"navbar_duoxuan_press" target:self action:@selector(mutiSelect)];
    self.navigationItem.rightBarButtonItems = @[mutiSelectItem];
}

- (void)mutiSelect
{
    YGLog(@"--mutiSelect--");
}

- (void)selectDownloadTableView
{
//    self.contenType = YGTransferShowContenTypeDownload;
//    YGFileModel *downloadFileModel = [YGFileTransferTool downloadFile];
//    [self.uploadFiles addObject:downloadFileModel];
//    self.downloadFileModel = downloadFileModel;

//    [self.transferTableView reloadData];
    YGLog(@"-selectedDownloadTableView-");
}

- (void)selectedUploadTableView
{
    self.contenType = YGTransferShowContenTypeUpload;

    [self refreshTransferTableView];
    YGLog(@"-selectedUploadTableView-");
}

- (void)refreshTransferTableView
{
//    self.uploadFiles = [YGFileTransferTool uploadFiles];
    self.uploadFileModel = [self.uploadFiles firstObject];
    [self.transferTableView reloadData];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.contenType == YGTransferShowContenTypeDownload) {
        return self.downloadFiles.count;
    } else {
        return self.uploadFiles.count;
    }
    YGLog(@"download%lu-upload%lu", self.downloadFiles.count, self.uploadFiles.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contenType == YGTransferShowContenTypeDownload) {
        static NSString *ID = @"download";
        YGDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [YGDownloadCell downloadCell];
        }
        cell.downloadFileModel = self.downloadFiles[indexPath.row];
        return cell;
    } else {
        static NSString *ID = @"upload";
        YGUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [YGUploadCell uploadCell];
        }
        cell.uploadFileModel = self.uploadFiles[indexPath.row];
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
