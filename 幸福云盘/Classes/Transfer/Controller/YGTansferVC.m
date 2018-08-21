//
//  YGTansferVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTansferVC.h"
#import "YGMenuView.h"
#import "YGDownloadListVC.h"
#import "YGUploadListVC.h"
#import "YGSubFileVC.h"
#import "YGFileModel.h"
#import "YGMainTabBarVC.h"

@interface YGTansferVC () <YGMenuViewDelegate>
@property (nonatomic, weak) YGMenuView *menuView;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) YGDownloadListVC *downloadListVC;
@property (nonatomic, strong) YGUploadListVC *uploadListVC;
@property (nonatomic, strong) YGFileModel *uploadFileModel;
@property (nonatomic, strong) YGFileModel *downlaodFileModel;
@end

@implementation YGTansferVC
#pragma mark - 懒加载
- (YGDownloadListVC *)downloadListVC
{
    if (_downloadListVC == nil) {
        _downloadListVC = [[YGDownloadListVC alloc] init];
        [self addChildViewController:_downloadListVC];
        [self.view addSubview:_downloadListVC.view];
        _downloadListVC.view.frame = self.view.bounds;
        _downloadListVC.view.y = 104;
    }
    return _downloadListVC;
}

- (YGUploadListVC *)uploadListVC
{
    if (_uploadListVC == nil) {
        _uploadListVC = [[YGUploadListVC alloc] init];
        [self addChildViewController:_uploadListVC];
        [self.view addSubview:_uploadListVC.view];
        _uploadListVC.view.frame = self.view.bounds;
        _uploadListVC.view.y = 104;
    }
    return _uploadListVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMenuView];
    
    [self setupNavBar];
    
    [self addObsvr];
}



- (void)setupMenuView
{
    self.view.backgroundColor = [UIColor whiteColor];
    YGMenuView *menuView = [[YGMenuView alloc] init];
    menuView.delegate = self;
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64.0);
        make.height.equalTo(@40);
    }];
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
        [self.uploadListVC.uploadFiles addObject:uploadFileModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uploadListVC.tableView reloadData];
        });
    }
    
    self.uploadFileModel = uploadFileModel;
    [self.uploadFileModel addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YGMainTabBarVC *tabBarVC = (YGMainTabBarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [[[tabBarVC.tabBar items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%lu", self.uploadListVC.uploadFiles.count]];
    });
}

#pragma mark - YGMenuViewDelegate
- (void)menuViewDidClickDownloadListBtn:(YGMenuView *)menuView
{
    [self.uploadListVC.view removeFromSuperview];
    [self.view addSubview:self.downloadListVC.view];
}

- (void)menuViewDidClickUploadListBtn:(YGMenuView *)menuView
{
    [self.downloadListVC.view removeFromSuperview];
    [self.view addSubview:self.uploadListVC.view];
}

- (void)mutiSelect
{
    YGLog(@"--mutiSelect--");
}

- (void)dealloc
{
    [self removeObserver:self.uploadFileModel forKeyPath:@"uploadProgress"];
}
@end
