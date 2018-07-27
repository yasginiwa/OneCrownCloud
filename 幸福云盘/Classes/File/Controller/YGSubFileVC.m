//
//  YGSubFileVC.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/20.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGSubFileVC.h"
#import "YGFileModel.h"
#import "YGHttpTool.h"
#import "YGFileEmptyView.h"
#import "YGFileTypeTool.h"
#import "YGRepoTool.h"

@interface YGSubFileVC () <UIGestureRecognizerDelegate>

@end

@implementation YGSubFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.currentFileModel.name;
    
    [self requestDir];
}

- (void)requestDir
{
    // 添加一个实例化的fileModel作为第一行的占位
    YGFileModel *firstModel = self.libraries[0];
    [self.libraries removeAllObjects];
    [self.libraries addObject:firstModel];
    
    // 从沙盒中取出当前repo
    YGFileModel *repo = [YGRepoTool repo];
    NSString *repoID = repo.ID;
    NSString *dirName = [self.currentFileModel.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"p" : [NSString stringWithFormat:@"/%@", dirName]};
    
    [YGHttpTool listDirectoryWithRepoID:repoID params:params success:^(id  _Nonnull responseObject) {
        
        NSArray *repos = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:repos];
        [self.loadingView removeFromSuperview];
        if (self.libraries.count < 2) {
            YGFileEmptyView *fileEmptyView = [[YGFileEmptyView alloc] init];
            [self.view addSubview:fileEmptyView];
            self.fileEmptyView = fileEmptyView;
        } else {
            [self.fileEmptyView removeFromSuperview];
        }
        
        // 刷新tableView 停止下拉刷新加载菊花
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
        YGLog(@"%@", error);
        
    }];
}

//- (void)requestDir
//{
//    // 添加一个实例化的fileModel作为第一行的占位
//    YGFileModel *firstModel = self.libraries[0];
//    [self.libraries removeAllObjects];
//    [self.libraries addObject:firstModel];
//
//    if ([YGFileTypeTool isRepo:self.currentFileModel]) {
//
//        NSDictionary *params = @{@"type" : @"mine"};
//
//        [YGHttpTool listLibrariesParams:params success:^(id  _Nonnull responseObject) {
//            NSArray *repos = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
//            [self.libraries addObjectsFromArray:repos];
//            [self.loadingView removeFromSuperview];
//            if (self.libraries.count < 2) {
//                YGFileEmptyView *fileEmptyView = [[YGFileEmptyView alloc] init];
//                [self.view addSubview:fileEmptyView];
//                self.fileEmptyView = fileEmptyView;
//            } else {
//                [self.fileEmptyView removeFromSuperview];
//            }
//
//            // 刷新tableView 停止下拉刷新加载菊花
//            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//
//        } failure:^(NSError * _Nonnull error) {
//
//            YGLog(@"%@", error);
//
//        }]
//    }
//
//    if ([YGFileTypeTool isDir:self.currentFileModel]) {
//        NSString *repoId = [yg]
//        NSString *urlStr = [[[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:repoId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        // https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/dir/?p=/foo
//        [YGHttpTool GET:urlStr params:nil success:^(id reponseObj) {
//            NSArray *dirs = [YGFileModel mj_objectArrayWithKeyValuesArray:reponseObj];
//            [self.libraries addObjectsFromArray:dirs];
//            [self.loadingView removeFromSuperview];
//            if (self.libraries.count < 2) {
//                YGFileEmptyView *fileEmptyView = [[YGFileEmptyView alloc] init];
//                [self.view addSubview:fileEmptyView];
//                self.fileEmptyView = fileEmptyView;
//            } else {
//                [self.fileEmptyView removeFromSuperview];
//            }
//
//            // 刷新tableView 停止下拉刷新加载菊花
//            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//        } failure:^(NSError *error) {
//            YGLog(@"%@", error);
//        }];
//    }
//
////    } else {    //  是dir时发请求
////        NSString *repoId = [NSString stringWithFormat:@"%@/dir/?p=/%@", self.repoModel.ID, self.dirModel.name];
////        NSString *urlStr = [[[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:repoId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        // https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/dir/?p=/foo
////        [YGHttpTool GET:urlStr params:nil success:^(id reponseObj) {
////            NSArray *dirs = [YGFileModel mj_objectArrayWithKeyValuesArray:reponseObj];
////            [self.libraries addObjectsFromArray:dirs];
////            [self.loadingView removeFromSuperview];
////            if (self.libraries.count < 2) {
////                YGFileEmptyView *fileEmptyView = [[YGFileEmptyView alloc] init];
////                [self.view addSubview:fileEmptyView];
////                self.fileEmptyView = fileEmptyView;
////            } else {
////                [self.fileEmptyView removeFromSuperview];
////            }
////
////            // 刷新tableView 停止下拉刷新加载菊花
////            [self.tableView reloadData];
////            [self.tableView.mj_header endRefreshing];
////        } failure:^(NSError *error) {
////            YGLog(@"%@", error);
////        }];
////    }
//}

- (void)refreshLibrary
{
    [self requestDir];
}
@end
