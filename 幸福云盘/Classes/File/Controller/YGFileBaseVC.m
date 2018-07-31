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
#import "YGFileTypeTool.h"
#import "YGRepoTool.h"
#import "YGDirTool.h"
#import "YGAddFolderView.h"

@interface YGFileBaseVC () <UIScrollViewDelegate, QLPreviewControllerDataSource>
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
    self.currentFileModel = currentFileModel;
    
    //  选中的是repo
    if ([YGFileTypeTool isRepo:currentFileModel]) {
        
        //  第0列为文件操作菜单 不允许点击
        if (indexPath.row == 0) return;
        //  保存当前repo到沙盒
        [YGRepoTool saveRepo:currentFileModel];
        YGSubFileVC *repoVC = [[YGSubFileVC alloc] init];
        
        //  删除保存到沙盒中的dir路径
        [YGDirTool removeDir];
        
        repoVC.currentFileModel = currentFileModel;
        [self.navigationController pushViewController:repoVC animated:YES];
    }
    
    //  选中的是dir
    if ([YGFileTypeTool isDir:currentFileModel]) {
        if (indexPath.row == 0) return;
        
        //  保存dir路径到沙盒
        [YGDirTool saveDir:currentFileModel];
        

        YGSubFileVC *dirVC = [[YGSubFileVC alloc] init];
        dirVC.currentFileModel = currentFileModel;
        [self.navigationController pushViewController:dirVC animated:YES];
    }
    
    //  选中的是file
    if ([YGFileTypeTool isFile:currentFileModel]) {
        
        YGFilePreviewVC *previewVC = [[YGFilePreviewVC alloc] init];
        previewVC.hidesBottomBarWhenPushed = YES;
        previewVC.dataSource = self;
        previewVC.currentFileModel = currentFileModel;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - QLPreviewControllerDataSource
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.currentFileModel.name];
    return [NSURL fileURLWithPath:filePath];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}


@end
