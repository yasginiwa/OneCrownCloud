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
//#import "YGFileFirstCell.h"
#import "YGHeaderView.h"
#import "YGSubFileVC.h"
#import "YGFileEmptyView.h"
#import "YGFilePreviewVC.h"
#import "YGFileTypeTool.h"
#import "YGRepoTool.h"
#import "YGDirTool.h"
#import "YGAddFolderView.h"
#import "YGFileOperationView.h"
#import "YGFileVC.h"
#import "YGSubFileVC.h"
#import "YGMainNavVC.h"
#import "YGTransferVC.h"

@interface YGFileBaseVC () <UIScrollViewDelegate, QLPreviewControllerDataSource, YGFileOperationViewDelegate>

@property (nonatomic, copy) NSString *showTitle;
@property (nonatomic, strong) UIBarButtonItem *uploadItem;
@end

@implementation YGFileBaseVC

#pragma mark - 懒加载
- (YGFileOperationView *)fileOperationView
{
    if (_fileOperationView == nil) {
        _fileOperationView = [self isRootViewController] ? [YGFileOperationView fileOperationViewWithStyle:YGFileOperationViewStyleRepo] : [YGFileOperationView fileOperationViewWithStyle:YGFileOperationViewStyleDefault];
        _fileOperationView.delegate = self;
        [self.tabBarController.view addSubview:_fileOperationView];
        [self.tabBarController.view bringSubviewToFront:_fileOperationView];
    }
    return _fileOperationView;
}

- (UIBarButtonItem *)uploadItem
{
    if (_uploadItem == nil) {
        _uploadItem = [UIBarButtonItem itemWithImage:@"file_upload" highImage:@"file_upload_pressed" target:self action:@selector(fileUpload)];
    }
    return _uploadItem;
}

- (NSMutableArray *)libraries
{
    if (_libraries == nil) {
        _libraries = [NSMutableArray array];
    }
    return _libraries;
}

- (NSMutableArray *)selectedRepos
{
    if (_selectedRepos == nil) {
        _selectedRepos = [NSMutableArray array];
    }
    return _selectedRepos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupLoadingView];
    
    [self setupNavBar];
    
    [self setupShowTitle];
}

- (void)setupShowTitle
{
    self.showTitle = [self isRootViewController] ? @"幸福网盘" : self.currentFileModel.name;
}

/** 判断是否是push的栈底控制器 */
- (BOOL)isRootViewController
{
    if (self.navigationController.childViewControllers.count == 1) {
        return YES;
    }
    return NO;
}

/** 初始化tableView */
- (void)setupTableView
{
    // 无数据的空白cell不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // cell分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 添加下拉刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshLibrary)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.arrowView.image = [UIImage imageNamed:@"blueArrow"];
    self.tableView.mj_header = refreshHeader;
    
    YGHeaderView *headerView = [[YGHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 50)];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
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
    self.navigationItem.rightBarButtonItem = self.uploadItem;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.libraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileCell *cell = [YGFileCell fileCell];
    cell.delegate = self;
    self.tableView.allowsSelection = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.fileModel = self.libraries[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileModel *currentFileModel = self.libraries[indexPath.row];
    self.currentFileModel = currentFileModel;
    if (currentFileModel.isSelected) {
        [self cancelSelect];
        return;
    }
    [self cancelSelect];
    //  选中的是repo
    if ([YGFileTypeTool isRepo:currentFileModel]) {
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


#pragma mark - YGFileCellDelegate
- (void)fileCell:(YGFileCell *)fileCell didSelectCheckBtn:(UIButton *)checkBtn fileModel:(YGFileModel *)fileModel
{
    if (!checkBtn.isSelected) {
        fileModel.selected = YES;
        if (!fileModel) return;
        [self.selectedRepos addObject:fileModel];
        [UIView animateWithDuration:0.1 animations:^{
            self.fileOperationView.transform = CGAffineTransformMakeTranslation(0, -self.fileOperationView.height);
        }];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelect)];
        UIBarButtonItem *selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
        self.navigationItem.leftBarButtonItem = selectAllItem;
        self.navigationItem.rightBarButtonItem = cancelItem;
        self.navigationItem.title = [NSString stringWithFormat:@"已选择了%lu个资料夹", self.selectedRepos.count];
    } else {
        fileModel.selected = NO;
        [self.selectedRepos removeObject:fileModel];
        self.navigationItem.title = [NSString stringWithFormat:@"已选择了%lu个资料夹", self.selectedRepos.count];
    }
    
    [self selectNothing];
    [self.tableView reloadData];
}

/** 取消选择 */
- (void)cancelSelect
{
    for (YGFileModel *fileModel in self.selectedRepos) {
        fileModel.selected = NO;
    }
    [self.selectedRepos removeAllObjects];
    [self fileCell:nil didSelectCheckBtn:nil fileModel:nil];
    [self selectNothing];
    [self.tableView reloadData];
}

/** 全选文件 */
- (void)selectAll
{
    [self.selectedRepos removeAllObjects];
    
    [self.selectedRepos addObjectsFromArray:self.libraries];
    for (YGFileModel *fileModel in self.selectedRepos) {
        fileModel.selected = YES;
    }
    [self fileCell:nil didSelectCheckBtn:nil fileModel:nil];
    self.navigationItem.title = [NSString stringWithFormat:@"已选择了%lu个资料夹", self.selectedRepos.count];
    [self.tableView reloadData];
}

/** 未选择任何文件 */
- (void)selectNothing
{
    if (self.selectedRepos.count == 0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.fileOperationView.transform = CGAffineTransformIdentity;
        }];
        
        self.navigationItem.rightBarButtonItem = [self isRootViewController] ? nil : self.uploadItem;

        self.navigationItem.title = self.showTitle;
        self.navigationItem.leftBarButtonItem = nil;
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.fileOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabBarController.view);
        make.top.equalTo(self.tabBarController.view.mas_bottom);
        make.height.equalTo(@49);
    }];
}
@end
