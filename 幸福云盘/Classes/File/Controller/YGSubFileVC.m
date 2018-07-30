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
#import "YGDirTool.h"

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
    
    NSDictionary *params;
    
    //  如果当前点击的是repo 则请求列出目录时param为空
    if ([YGFileTypeTool isRepo:self.currentFileModel]) {
        
        params = nil;
    }
    //  如果当前点击的是dir 则请求列出目录时param的参数是目录的名字
    if ([YGFileTypeTool isDir:self.currentFileModel]) {
        
        params = @{
                   @"p" : [YGDirTool dir]
                   };
    }
    
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

- (void)refreshLibrary
{
    [self requestDir];
}

- (void)dealloc
{
    [YGDirTool backToParentDir];
}
@end
