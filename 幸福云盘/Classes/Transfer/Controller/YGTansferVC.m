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

@interface YGTansferVC () <YGMenuViewDelegate>
@property (nonatomic, weak) YGMenuView *menuView;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) YGDownloadListVC *downloadListVC;
@property (nonatomic, strong) YGUploadListVC *uploadListVC;
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
    
    [self setupChildVC];
    
    [self setupMenuView];
    
    [self setupNavBar];
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

- (void)setupChildVC
{
    //  设置downloadVC
    __block typeof(self) weakSelf = self;
    self.downloadFile = ^(YGFileModel *downloadFileModel) {
        [weakSelf.downloadListVC.downloadFiles addObject:downloadFileModel];
    };
    
    //  设置uploadVC
    self.uploadFile = ^(YGFileModel *uploadFileModel) {
        [weakSelf.uploadListVC.uploadFiles addObject:uploadFileModel];
    };
}

- (void)setupNavBar
{
    UIBarButtonItem *mutiSelectItem = [UIBarButtonItem itemWithImage:@"navbar_duoxuan" highImage:@"navbar_duoxuan_press" target:self action:@selector(mutiSelect)];
    self.navigationItem.rightBarButtonItems = @[mutiSelectItem];
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
@end
