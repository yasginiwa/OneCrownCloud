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
    if ([self.currentFileModel.type isEqualToString:@"repo"] || [self.currentFileModel.type isEqualToString:@"Dir"]) {
        NSString *repoId = [NSString stringWithFormat:@"%@/dir/?p=/", self.currentFileModel.ID];
        
        NSString *urlStr = [[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:repoId];
        
        // 添加一个实例化的fileModel作为第一行的占位
        YGFileModel *firstModel = self.libraries[0];
        [self.libraries removeAllObjects];
        [self.libraries addObject:firstModel];
        
        [YGHttpTool GET:urlStr params:nil success:^(id reponseObj) {
            NSArray *dirs = [YGFileModel mj_objectArrayWithKeyValuesArray:reponseObj];
            [self.libraries addObjectsFromArray:dirs];
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
        } failure:^(NSError *error) {
            YGLog(@"%@", error);
        }];
    }
}

- (void)refreshLibrary
{
    [self requestDir];
}
@end
