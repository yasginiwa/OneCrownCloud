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
#import "YGFileCell.h"
#import "YGAddFolderView.h"
#import "YGFileFirstCell.h"

@interface YGSubFileVC () <UIGestureRecognizerDelegate, YGFileCellDelegate, YGAddFolderViewDelegate, YGFileFirstCellDelegate>
@property (nonatomic, copy) NSString *addDirName;
@end

@implementation YGSubFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.currentFileModel.name;

    [self setupObserv];
    
    [self requestDir];
}

/** 初始化监听新建文件夹内文本变化的通知中心 */
- (void)setupObserv
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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
                fileEmptyView.frame = CGRectMake(0, 50, self.tableView.width, self.tableView.height);
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
    
}

#pragma mark - YGAddFolderViewDelegate
- (void)addFolderViewDidClickOkBtn:(YGAddFolderView *)addFolderView
{
    [addFolderView endEditing:YES];
    
    [SVProgressHUD showWaiting];
    
    NSString *repoID = [YGRepoTool repo].ID;
    
    if (self.addDirName.length == 0) {
        [SVProgressHUD showMessage:@"文件名不能为空"];
        return;
    }
    
    NSDictionary *params = @{
                             
                             @"operation" : @"mkdir"
                             };

    [YGHttpTool createDirectoryWithRepoID:repoID dir:self.addDirName params:params success:^(id  _Nonnull responseObject) {
        [addFolderView removeFromSuperview];
        
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [SVProgressHUD hideHud];
        [self refreshLibrary];
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        YGLog(@"%@", error);
    }];
}

- (void)addFolderViewDidClickCancelBtn:(YGAddFolderView *)addFolderView
{
    [addFolderView endEditing:YES];
    [addFolderView removeFromSuperview];
}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    YGLog(@"--fileCellDidSelectCheckBtn--");
}


- (void)textChanged:(NSNotification *)note
{
    UITextField *textField = note.object;
    self.addDirName = textField.text;
}

- (void)dealloc
{
    [YGDirTool backToParentDir];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
