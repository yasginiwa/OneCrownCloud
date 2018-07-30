//
//  YGFileVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileVC.h"
#import "YGHttpTool.h"
#import "YGApiTokenTool.h"
#import "YGFileModel.h"
#import "YGFileCell.h"
#import "YGLoadingView.h"
#import "YGFileEmptyView.h"

@interface YGFileVC () <YGFileCellDelegate>

@end

@implementation YGFileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self judgeFirstLogin];
}

/** 第一次登陆 判断沙盒中是否存在token的归档文件 然后请求所有的repo */
- (void)judgeFirstLogin
{
    if ([YGApiTokenTool apiToken]) {
        [self requestLibraries];
    } else {
        [self addObserver];
    }
}

/** 添加KVO */
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLibraries) name:YGTokenSavedNotification object:nil];
}

/** 请求repo */
- (void)requestLibraries
{
    NSDictionary *params = @{@"type" : @"mine"};
    [YGHttpTool listLibrariesParams:params success:^(id  _Nonnull responseObject) {
        NSArray *libs = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:libs];
        [self.loadingView removeFromSuperview];
        if (self.libraries.count < 2) {
            YGFileEmptyView *fileEmptyView = [[YGFileEmptyView alloc] init];
            [self.view addSubview:fileEmptyView];
            self.fileEmptyView = fileEmptyView;
        } else {
            [self.fileEmptyView removeFromSuperview];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        YGLog(@"%@", error);
    }];
}

//- (void)orderFolder
//{
//    YGLog(@"--orderFolder--");
//}
//
//- (void)fileUpload
//{
//    YGLog(@"--fileUpload--");
//}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    NSLog(@"--fileCellDidSelectCheckBtn--");
}

/** 刷新网盘根repo */
- (void)refreshLibrary
{
    // 添加一个实例化的fileModel作为第一行的占位
    YGFileModel *firstModel = self.libraries[0];
    [self.libraries removeAllObjects];
    [self.libraries addObject:firstModel];
    
    NSDictionary *params = @{@"type" : @"mine"};
    [YGHttpTool listLibrariesParams:params success:^(id  _Nonnull responseObject) {
        NSArray *newFileModels = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:newFileModels];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        YGLog(@"%@", error);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
