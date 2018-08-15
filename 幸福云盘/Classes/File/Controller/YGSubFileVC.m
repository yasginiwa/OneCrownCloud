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
#import "YGFileUploadView.h"
#import "YGHeaderView.h"
#import <QBImagePickerController.h>

@interface YGSubFileVC () <UIGestureRecognizerDelegate, YGFileCellDelegate, YGAddFolderViewDelegate, YGHeaderViewDelegate, YGFileUploadDelegate, QBImagePickerControllerDelegate>
@property (nonatomic, copy) NSString *addDirName;
@end

@implementation YGSubFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.currentFileModel.name;

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
    // 从沙盒中取出当前repo
    YGFileModel *repo = [YGRepoTool repo];
    NSString *repoID = repo.ID;
    
    NSDictionary *params;
    
    //  如果当前点击的是repo 则请求列出目录时param为空
    if ([YGFileTypeTool isRepo:self.currentFileModel]) {
        params = nil;
    }
    
    //  如果当前点击的是dir 则请求列出目录时param的参数是目录的名字
    if ([YGFileTypeTool isDir:self.currentFileModel] || [YGFileTypeTool isFile:self.currentFileModel]) {
        
        NSString *currentDir = [YGDirTool dir];
        
        params = @{
                   @"p" : currentDir
                   };
    }
    
    [YGHttpTool listDirectoryWithRepoID:repoID params:params success:^(id  _Nonnull responseObject) {
            
            NSArray *repos = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
            [self.libraries addObjectsFromArray:repos];
            [self.loadingView removeFromSuperview];
            if (self.libraries.count < 1) {
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
    //  如果有选中的文件 不刷新
    if (self.selectedRepos.count) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    //  刷新前先清空数组
    [self.libraries removeAllObjects];
    
    //  请求最新数据
    [self requestDir];
}

#pragma mark - YGFileFirstCellDelegate
- (void)headerViewDidClickAddFolderBtn:(YGHeaderView *)headerView
{
    YGAddFolderView *addFolderView = [[YGAddFolderView alloc] init];
    addFolderView.delegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:addFolderView];
    addFolderView.frame = keyWindow.bounds;
}

- (void)headerViewDidClickOrderBtn:(YGHeaderView *)headerView
{
    YGLog(@"subFile--headerViewDidClickOrderBtn--");
}

#pragma mark - YGAddFolderViewDelegate
- (void)addFolderViewDidClickOkBtn:(YGAddFolderView *)addFolderView
{
    NSString *repoID = [YGRepoTool repo].ID;
    
    if (self.addDirName.length == 0) {
        addFolderView.emptyDirName = YES;
        return;
    }
    
    [addFolderView endEditing:YES];
    [SVProgressHUD showWaiting];
    self.addDirName = [NSString stringWithFormat:@"/%@", self.addDirName];
    NSDictionary *params = @{
                             @"operation" : @"mkdir"
                             };

    [YGHttpTool createDirectoryWithRepoID:repoID dir:self.addDirName params:params success:^(id  _Nonnull responseObject) {
        [SVProgressHUD hide];
        [addFolderView removeFromSuperview];
        self.addDirName = nil;
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

/** 文件上传 */
- (void)fileUpload
{
    YGFileUploadView *fileUploadView = [[YGFileUploadView alloc] init];
    fileUploadView.uploadDelegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:fileUploadView];
    fileUploadView.frame = [UIScreen mainScreen].bounds;
    
    fileUploadView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        fileUploadView.alpha = 0.9;
    } completion:^(BOOL finished) {
        [fileUploadView popUpButtons];
    }];
}

#pragma mark - YGFileUploadDelegate
- (void)fileUploadDidClickPicUploadBtn:(YGFileUploadView *)fileUploadView
{
    QBImagePickerController *imagePickerVC = [[QBImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsMultipleSelection = YES;
    imagePickerVC.maximumNumberOfSelection = 9;
    imagePickerVC.showsNumberOfSelectedAssets = YES;
    imagePickerVC.numberOfColumnsInPortrait = 4;
    imagePickerVC.showsNumberOfSelectedAssets = YES;
    imagePickerVC.mediaType = QBImagePickerMediaTypeImage;
    imagePickerVC.assetCollectionSubtypes = @[
                                              @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                              ];
    
    [fileUploadView dismiss];
    [fileUploadView removeFromSuperview];
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)fileUploadDidClickVideoUploadBtn:(YGFileUploadView *)fileUploadView
{
    QBImagePickerController *imagePickerVC = [[QBImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsMultipleSelection = YES;
    imagePickerVC.maximumNumberOfSelection = 9;
    imagePickerVC.showsNumberOfSelectedAssets = YES;
    imagePickerVC.numberOfColumnsInPortrait = 4;
    imagePickerVC.showsNumberOfSelectedAssets = YES;
    imagePickerVC.mediaType = QBImagePickerMediaTypeVideo;
    imagePickerVC.assetCollectionSubtypes = @[
                                              @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                              ];
    
    [fileUploadView dismiss];
    [fileUploadView removeFromSuperview];
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    PHAsset *asset = [assets firstObject];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        YGLog(@"%@-%@", result, info);
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{

}


- (void)textChanged:(NSNotification *)note
{
    UITextField *textField = note.object;
    self.addDirName = textField.text;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileModel *currentFileModel = self.libraries[indexPath.row];
    if (currentFileModel.isSelected) {
        [self cancelSelect];
        return;
    }
    self.currentFileModel = currentFileModel;
    [YGDirTool saveDir:currentFileModel];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD showWaiting];
        
        NSString *repoID = [YGRepoTool repo].ID;
        NSString *dirName = [YGDirTool dir];
        NSDictionary *params = @{
                                 @"p" : dirName
                                 };
        
        [YGHttpTool deleteDirectoryWithRepoID:repoID params:params success:^(id  _Nonnull responseObject) {
            [SVProgressHUD hide];
            [SVProgressHUD showSuccessFace:@"删除成功"];
            if ([YGFileTypeTool isDir:currentFileModel]) {
                [YGDirTool backToParentDir];
            }             
            [self refreshLibrary];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD hide];
            [SVProgressHUD showFailureFace:@"删除失败"];
        }];
    }
}


#pragma mark - YGFileOperationViewDelegate
- (void)fileOperationViewDidClickDownloadBtn:(YGFileOperationView *)headerView
{
    YGLog(@"subFileOperationViewDidClickDownloadBtn---");
}

- (void)fileOperationViewDidClickShareBtn:(YGFileOperationView *)headerView
{
    YGLog(@"subFileOperationViewDidClickShareBtn---");
}

- (void)fileOperationViewDidClickMoveBtn:(YGFileOperationView *)headerView
{
    YGLog(@"subFileOperationViewDidClickMoveBtn---");
}

- (void)fileOperationViewDidClickRenameBtn:(YGFileOperationView *)headerView
{
    YGLog(@"subFileOperationViewDidClickRenameBtn---");
}

- (void)fileOperationViewDidClickDeleteBtn:(YGFileOperationView *)headerView
{
    YGLog(@"subFileOperationViewDidClickDeleteBtn---");
}

- (void)dealloc
{
    [YGDirTool backToParentDir];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
