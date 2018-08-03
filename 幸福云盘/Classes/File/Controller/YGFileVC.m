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

@interface YGFileVC () <YGFileCellDelegate, YGFileFirstCellDelegate, YGAddFolderViewDelegate, YGFileUploadDelegate, QBImagePickerControllerDelegate>
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

    NSDictionary *params = @{
                             @"name" : self.addRepoName,
                             @"desc" : @"new library"
                             };

    [YGHttpTool createLibraryParams:params success:^(id  _Nonnull responseObject) {
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
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)qb_imagePickerController:(QBImagePickerController *)imagePickerController shouldSelectAsset:(PHAsset *)asset
{
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileModel *currentFileModel = self.libraries[indexPath.row];
    self.currentFileModel = currentFileModel;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [YGHttpTool deleteLibrary:currentFileModel.ID success:^(id  _Nonnull responseObject) {
            [SVProgressHUD showSuccessFace:@"删除成功"];
            [self refreshLibrary];
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showFailureFace:@"删除失败"];
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
