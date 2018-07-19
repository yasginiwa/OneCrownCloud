//
//  YGFileBaseVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileBaseVC.h"
#import "YGFileCell.h"
#import "YGLoadingView.h"
#import "YGApiTokenTool.h"
#import "YGFileModel.h"
#import "YGHttpTool.h"
#import "YGFileFirstCell.h"
#import "YGTestVC.h"

@interface YGFileBaseVC () <YGFileCellDelegate, YGFileFirstCellDelegate>

@end

@implementation YGFileBaseVC

/** 懒加载 */
- (NSMutableArray *)libraries
{
    if (_libraries == nil) {
        _libraries = [NSMutableArray array];
    }
    return _libraries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoadingView];
    
    [self setupNavBar];

}

/** 初始化loadingView */
- (void)setupLoadingView
{
    YGLoadingView *loadingView = [[YGLoadingView alloc] init];
    loadingView.frame = self.view.bounds;
    [self.view addSubview:loadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loadingView = loadingView;
}

/** 初始化navBar */
- (void)setupNavBar
{
    UIBarButtonItem *uploadItem = [UIBarButtonItem itemWithImage:@"file_upload" highImage:@"file_upload_pressed" target:self action:@selector(fileUpload)];
    self.navigationItem.rightBarButtonItem = uploadItem;
}

- (void)newFolder
{
    YGLog(@"--newFolder--base");
}

- (void)orderFolder
{
    YGLog(@"--orderFolder--base");
}

- (void)fileUpload
{
    YGLog(@"--fileUpload--base");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.libraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YGFileFirstCell *cell = [[YGFileFirstCell alloc] init];
        cell.delegate = self;
        return cell;
    }
    YGFileCell *cell = [YGFileCell fileCell];
    cell.delegate = self;
    cell.fileModel = self.libraries[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50.f;
    }
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.tableView.allowsSelection = NO;
        return;
    }
    //    YGFileModel *fileModel = self.libraries[indexPath.row];
    //    [self requestSubRepoWithFileModel:fileModel];
    YGTestVC *testVC = [[YGTestVC alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)requestSubRepoWithFileModel:(YGFileModel *)fileModel
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    if ([fileModel.type isEqualToString:@"repo"]) {
        NSString *repoId = [NSString stringWithFormat:@"%@/dir/?p=/", fileModel.ID];
        NSString *checkRepoURL = [[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:repoId];
        [YGHttpTool GET:checkRepoURL apiToken:token params:nil success:^(id responseObject) {
            YGLog(@"%@", responseObject);
        } failure:^(NSError *error) {
            YGLog(@"%@", error);
        }];
    }
}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    YGLog(@"--fileCellDidSelectCheckBtn--");
}

@end
