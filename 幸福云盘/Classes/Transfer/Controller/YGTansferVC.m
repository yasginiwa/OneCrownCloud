//
//  YGTansferVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTansferVC.h"
#import "YGMenuView.h"

@interface YGTansferVC () <YGMenuViewDelegate>
@property (nonatomic, weak) YGMenuView *menuView;
@property (nonatomic, strong) UITableView *downloadTableView;
@property (nonatomic, strong) UITableView *uploadTableView;
@property (nonatomic, assign) BOOL showingView;
@end

@implementation YGTansferVC

#pragma mark - 懒加载
- (UITableView *)downloadTableView
{
    if (_downloadTableView == nil) {
        _downloadTableView = [[UITableView alloc] init];
        [self.view insertSubview:_downloadTableView belowSubview:self.menuView];
    }
    return _downloadTableView;
}

- (UITableView *)uploadTableView
{
    if (_uploadTableView == nil) {
        _uploadTableView = [[UITableView alloc] init];
        [self.view insertSubview:_uploadTableView belowSubview:self.menuView];
    }
    return _uploadTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMenuView];
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

- (void)menuViewDidClickDownloadListBtn:(YGMenuView *)menuView
{
//    [self.view bringSubviewToFront:self.downloadTableView];
}

- (void)menuViewDidClickUploadListBtn:(YGMenuView *)menuView
{
//    [self.view bringSubviewToFront:self.uploadTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.downloadTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
    }];
    
    [self.uploadTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
    }];
}
@end
