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
#import <TZImageManager.h>
#import <TZImagePickerController.h>

@interface YGSubFileVC () <UIGestureRecognizerDelegate, YGFileCellDelegate, YGAddFolderViewDelegate, YGHeaderViewDelegate, YGFileUploadDelegate, TZImagePickerControllerDelegate>
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
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVC.allowTakePicture = NO;
    imagePickerVC.naviBgColor = [UIColor whiteColor];
    imagePickerVC.naviTitleColor = [UIColor blackColor];
    imagePickerVC.allowPreview = NO;
    imagePickerVC.barItemTextColor = [UIColor blackColor];
    imagePickerVC.title = @"选择要上传照片";
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.doneBtnTitleStr = @"上传";
    imagePickerVC.allowPickingOriginalPhoto = YES;
    
    [fileUploadView dismiss];
    [fileUploadView removeFromSuperview];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)fileUploadDidClickVideoUploadBtn:(YGFileUploadView *)fileUploadView
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVC.allowTakePicture = NO;
    imagePickerVC.naviBgColor = [UIColor whiteColor];
    imagePickerVC.naviTitleColor = [UIColor blackColor];
    imagePickerVC.allowPreview = NO;
    imagePickerVC.barItemTextColor = [UIColor blackColor];
    imagePickerVC.title = @"选择要上传视频";
    imagePickerVC.allowPickingImage = NO;
    imagePickerVC.allowPickingVideo = YES;
    imagePickerVC.doneBtnTitleStr = @"上传";
    imagePickerVC.allowPickingOriginalPhoto = YES;
    
    [fileUploadView dismiss];
    [fileUploadView removeFromSuperview];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset
{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    //  设置options 允许从icloud下载高质量的照片
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        YGLog(@"%f-%@", progress, info);
    };
    
    //  初始化PHImageManager 通过是否存在PHImageResultIsInCloudKey键判断是否在icloud中
    PHImageManager *photoMgr = [PHImageManager defaultManager];
    for (PHAsset *asset in assets) {
        [photoMgr requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            //  在icloud上
            if ([[info allKeys] containsObject:@"PHImageResultIsInCloudKey"]) {
                [photoMgr requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    NSURL *imageUrl = info[@"PHImageFileURLKey"];
                    NSString *imagePath = [imageUrl absoluteString];
                    NSString *imageName = [[imagePath componentsSeparatedByString:@"/"] lastObject];
                    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *imageNewPath = [cacheDir stringByAppendingPathComponent:imageName];
                    [imageData writeToFile:imageNewPath atomically:YES];
                    [self uploadImage:[NSURL URLWithString:[NSString stringWithFormat:@"file://,%@",imageNewPath]]];
                }];
            } else {    //  在本手机上
                NSURL *imageUrl = info[@"PHImageFileURLKey"];
                [self uploadImage:imageUrl];
            }
        }];
    }
}

- (void)uploadImage:(NSURL *)imageUrl
{
    //  初始化网络上传相关参数
    NSString *folderPath = [NSString stringWithFormat:@"%@/", [YGDirTool dir]];
    NSDictionary *params = @{@"p" : folderPath};
    
    [YGHttpTool getUploadUrlWithRepoID:[YGRepoTool repo].ID params:params success:^(id  _Nonnull responseObj) {
        NSString *uploadUrl = [NSString stringWithFormat:@"%@?ret-json=1", responseObj];
        [YGHttpTool POST:uploadUrl params:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[folderPath dataUsingEncoding:NSUTF8StringEncoding] name:@"parent_dir"];
            [formData appendPartWithFileURL:imageUrl name:@"file" error:nil];
            [SVProgressHUD showSuccessFace:@"添加至传输列表"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            double progress = uploadProgress.fractionCompleted;
        } success:^(id  _Nonnull responseObject) {
            [self refreshLibrary];
            YGLog(@"%@", responseObject);
        } failure:^(NSError * _Nonnull error) {
            if (error.code == -1001) {
                [SVProgressHUD showFailureFace:@"网络超时..."];
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showFailureFace:@"上传失败"];
    }];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        
      if ([YGFileTypeTool isDir:self.currentFileModel]) {
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
        } else {
            
        }
        

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
