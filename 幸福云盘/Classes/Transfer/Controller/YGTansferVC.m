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
@property (nonatomic, weak) YGDownloadListVC *downloadListVC;
@property (nonatomic, weak) YGUploadListVC *uploadListVC;
@end

@implementation YGTansferVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
    
    [self setupMenuView];
    
    [self setupNavBar];
    
    YGLog(@"-YGTansferVC-viewDidLoad-");
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
    YGDownloadListVC *downloadListVC = [[YGDownloadListVC alloc] init];
    [self addChildViewController:downloadListVC];
    [self.view addSubview:downloadListVC.view];
    downloadListVC.view.frame = self.view.bounds;
    downloadListVC.view.y = 104;
    self.downloadListVC = downloadListVC;
    
    //  设置uploadVC
    YGUploadListVC *uploadListVC = [[YGUploadListVC alloc] init];
    [self addChildViewController:uploadListVC];
    [self.view addSubview:uploadListVC.view];
    uploadListVC.view.frame = self.view.bounds;
    uploadListVC.view.y = 104;
    self.uploadListVC = uploadListVC;
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
