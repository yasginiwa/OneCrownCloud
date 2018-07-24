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
#import "YGSubFileVC.h"
#import "YGFileEmptyView.h"
#import "YGFilePreviewVC.h"

@interface YGFileBaseVC () <YGFileCellDelegate, YGFileFirstCellDelegate, UIScrollViewDelegate>

@end

@implementation YGFileBaseVC

/** 懒加载 */
- (NSMutableArray *)libraries
{
    if (_libraries == nil) {
        _libraries = [NSMutableArray array];
        YGFileModel *firstFileModel = [[YGFileModel alloc] init];
        [_libraries addObject:firstFileModel];
    }
    return _libraries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupLoadingView];
    
    [self setupNavBar];
}

/** 初始化tableView */
- (void)setupTableView
{
    // 无数据的空白cell不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // cell分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshLibrary)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"blueArrow"];
    self.tableView.mj_header = header;
    
}

/** 初始化loadingView */
- (void)setupLoadingView
{
    YGLoadingView *loadingView = [[YGLoadingView alloc] init];
    loadingView.frame = self.view.bounds;
    [self.view addSubview:loadingView];
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
        self.tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    } else {
        YGFileCell *cell = [YGFileCell fileCell];
        self.tableView.allowsSelection = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
        cell.fileModel = self.libraries[indexPath.row];
        return cell;
    }
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
    YGFileModel *currentFileModel = self.libraries[indexPath.row];


    if ([currentFileModel.type isEqualToString:@"repo"]) {
        
        if (indexPath.row == 0) return;
        YGSubFileVC *subFileVC = [[YGSubFileVC alloc] init];
        subFileVC.currentFileModel = currentFileModel;
        [self.navigationController pushViewController:subFileVC animated:YES];
        
    } else {
        
        YGFilePreviewVC *previewVC = [[YGFilePreviewVC alloc] init];
        previewVC.repoModel = self.currentFileModel;
        previewVC.fileModel = currentFileModel;
        [self.navigationController pushViewController:previewVC animated:YES];
        
    }
}



#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    YGLog(@"--fileCellDidSelectCheckBtn--");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
