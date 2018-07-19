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
#import "YGTestVC.h"

@interface YGFileVC () <YGFileCellDelegate>

@end

@implementation YGFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    
    [self judgeFirstLogin];
}

/** 判断是否第一次登陆 然后请求所有的repo */
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
    NSString *librariesURL = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:LIST_LIBARIES_URL]];
    
    YGApiToken *token = [YGApiTokenTool apiToken];
    [YGHttpTool GET:librariesURL apiToken:token params:nil success:^(id responseObject) {
        NSArray *libs = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:libs];
        [self.loadingView removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
        YGLog(@"reloadData---");
    } failure:^(NSError *error) {
        YGLog(@"%@", error);
    }];
}



- (void)newFolder
{
    YGLog(@"--newFolder--");
}

- (void)orderFolder
{
    YGLog(@"--orderFolder--");
}

- (void)fileUpload
{
    YGLog(@"--fileUpload--");
}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    NSLog(@"--fileCellDidSelectCheckBtn--");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
