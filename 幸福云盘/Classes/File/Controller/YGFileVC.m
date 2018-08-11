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
#import "YGNetworkFailedView.h"
#import "YGFileFirstCell.h"
#import "YGAddFolderView.h"
#import "YGFileUploadView.h"
#import <QBImagePickerController.h>
#import "YGFileOperationView.h"

@interface YGFileVC () <YGFileCellDelegate, YGFileFirstCellDelegate, YGAddFolderViewDelegate>
@property (nonatomic, copy) NSString *addRepoName;
@property (nonatomic, strong) YGFileOperationView *fileOperationView;
@property (nonatomic, strong) NSMutableArray *selectedRepos;
@end

@implementation YGFileVC

#pragma mark - 懒加载
- (YGFileOperationView *)fileOperationView
{
    if (_fileOperationView == nil) {
        _fileOperationView = [[YGFileOperationView alloc] init];
        [self.tabBarController.view addSubview:_fileOperationView];
        [self.tabBarController.view bringSubviewToFront:_fileOperationView];
    }
    return _fileOperationView;
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

    [self judgeFirstLogin];
    
    [self addObsvr];
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

- (void)addObsvr
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)note
{
    UITextField *textField = note.object;
    self.addRepoName = textField.text;
}

/** 覆盖父类方法 去掉上传item 因为repo跟路径下不允许上传文件*/
- (void)setupNavBar
{
    
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
        if (error.code == -1001) {
            [self setupNetworkFailedView];
        }
    }];
}

#pragma mark - YGFileCellDelegate
- (void)fileCell:(YGFileCell *)fileCell didSelectCheckBtn:(UIButton *)checkBtn fileModel:(YGFileModel *)fileModel
{
    if (checkBtn.isSelected) {
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
        [self.selectedRepos removeObject:fileModel];
        self.navigationItem.title = [NSString stringWithFormat:@"已选择了%lu个资料夹", self.selectedRepos.count];
    }
    
    if (self.selectedRepos.count == 0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.fileOperationView.transform = CGAffineTransformIdentity;
        }];
        self.navigationItem.title = @"幸福网盘";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)cancelSelect
{
    [self.selectedRepos makeObjectsPerformSelector:@selector(setChecked:) withObject:@(NO)];
    [self.selectedRepos removeAllObjects];
    [self fileCell:nil didSelectCheckBtn:nil fileModel:nil];
    YGLog(@"%lu", self.selectedRepos.count);
}

- (void)selectAll
{
    [self.selectedRepos removeAllObjects];
    [self.selectedRepos addObjectsFromArray:self.libraries];
    [self.selectedRepos makeObjectsPerformSelector:@selector(setChecked:) withObject:@(YES)];
    [self fileCell:nil didSelectCheckBtn:nil fileModel:nil];
    YGLog(@"%lu", self.selectedRepos.count);
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
        
        [self.networkFailedView removeFromSuperview];
        [self.loadingView removeFromSuperview];
        
        NSArray *newFileModels = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:newFileModels];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        if (error.code == -1001) {
            [self setupNetworkFailedView];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 初始化网络请求超时的显示view */
- (void)setupNetworkFailedView
{
    [SVProgressHUD showFailureFace:@"网络不给力哦..."];
    YGNetworkFailedView *networkFailedView = [[YGNetworkFailedView alloc] init];
    [self.view addSubview:networkFailedView];
}

#pragma mark - YGFileFirstCellDelegate
- (void)fileFirstCellDidClickAddFolderBtn:(YGFileFirstCell *)cell
{
    YGAddFolderView *addFolderView = [[YGAddFolderView alloc] init];
    addFolderView.delegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:addFolderView];
    addFolderView.frame = keyWindow.bounds;
}

- (void)fileFirstCellDidClickOrderBtn:(YGFileFirstCell *)cell
{
    YGLog(@"-fileFirstCellDidClickOrderBtn--");
}

#pragma mark - YGAddFolderViewDelegate
- (void)addFolderViewDidClickOkBtn:(YGAddFolderView *)addFolderView
{
    if (self.addRepoName.length == 0) {
        addFolderView.emptyDirName = YES;
        return;
    }
    
    [addFolderView endEditing:YES];
    
    [SVProgressHUD showWaiting];

    NSDictionary *params = @{
                             @"name" : self.addRepoName,
                             @"desc" : @"new library"
                             };

    [YGHttpTool createLibraryParams:params success:^(id  _Nonnull responseObject) {
        [SVProgressHUD hide];
        [addFolderView removeFromSuperview];
        [SVProgressHUD showSuccessFace:@"创建成功"];
        [self refreshLibrary];
        
    } failure:^(NSError * _Nonnull error) {
        if (error.code == -1001) {
            [SVProgressHUD showFailureFace:@"网络不给力哦..."];
        }
    }];
}

- (void)addFolderViewDidClickCancelBtn:(YGAddFolderView *)addFolderView
{
    [addFolderView endEditing:YES];
    [addFolderView removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileModel *currentFileModel = self.libraries[indexPath.row];
    self.currentFileModel = currentFileModel;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD showWaiting];
        [YGHttpTool deleteLibrary:currentFileModel.ID success:^(id  _Nonnull responseObject) {
            [SVProgressHUD hide];
            [SVProgressHUD showSuccessFace:@"删除成功"];
            [self refreshLibrary];
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD hide];
            [SVProgressHUD showFailureFace:@"删除失败"];
        }];
    }
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
