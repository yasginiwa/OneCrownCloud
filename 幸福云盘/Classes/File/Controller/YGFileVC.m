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
#import "YGFileUploadVC.h"

@interface YGFileVC () <YGFileCellDelegate, YGFileFirstCellDelegate, YGAddFolderViewDelegate>
@property (nonatomic, copy) NSString *addRepoName;
@end

@implementation YGFileVC

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
        
        [self.networkFailedView removeFromSuperview];
        [self.loadingView removeFromSuperview];
        
        NSArray *newFileModels = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:newFileModels];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        if (error.code == - 1001) {
            [self setupNetworkFailedView];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 初始化网络请求超时的显示view */
- (void)setupNetworkFailedView
{
    [SVProgressHUD showError:@"网络不给力哦..."];
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
    [addFolderView endEditing:YES];

    [SVProgressHUD showWaiting];

    NSDictionary *params = @{
                             @"name" : self.addRepoName,
                             @"desc" : @"new library"
                             };

    if (self.addRepoName.length == 0) {
        [SVProgressHUD showMessage:@"文件名不能为空"];
        [SVProgressHUD dismissWithDelay:0.6];
        return;
    }

    [YGHttpTool createLibraryParams:params success:^(id  _Nonnull responseObject) {
        
        [addFolderView removeFromSuperview];
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [SVProgressHUD hideHud];
        [self refreshLibrary];
        
    } failure:^(NSError * _Nonnull error) {
        
        if (error.code == -1001) {
            [SVProgressHUD showError:@"网络不给力哦..."];
        }
    }];
}

- (void)addFolderViewDidClickCancelBtn:(YGAddFolderView *)addFolderView
{
    [addFolderView endEditing:YES];
    [addFolderView removeFromSuperview];
}

/** 文件上传 */
- (void)fileUpload
{
    YGFileUploadVC *fileUploadVC = [[YGFileUploadVC alloc] init];
    [self.navigationController presentViewController:fileUploadVC animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
