//
//  YGFilePreviewVC.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/24.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFilePreviewVC.h"
#import "YGFileModel.h"
#import "YGFileTypeTool.h"
#import "YGMimeType.h"
#import "YGHttpTool.h"
#import "YGApiTokenTool.h"
#import "YGApiToken.h"
#import "YGFileUnableView.h"
#import "YGDirTool.h"

@interface YGFilePreviewVC ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) UIView *downloadView;
// 下载进度
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, weak) YGFileUnableView *fileUnableView;
@end

@implementation YGFilePreviewVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self setupDownloadView];
}

- (void)setupAppearance
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupDownloadView
{
    UIView *downloadView = [[UIView alloc] init];
    downloadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downloadView];
    self.downloadView = downloadView;
    

    
    YGFileUnableView *fileUnableView = [[YGFileUnableView alloc] init];
    [self.view addSubview:fileUnableView];
    self.fileUnableView = fileUnableView;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    
    // 文件夹显示默认图标
    NSString *fileExt = [NSString extensionWithFile:self.currentFileModel.name];
    
    // 文件显示图标判断
    NSArray *fileMimeTypes = [YGFileTypeTool fileMimeTypes];
    [fileMimeTypes enumerateObjectsUsingBlock:^(YGMimeType *mimeType, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[fileExt lowercaseString] isEqualToString:mimeType.mime]) {    // 能识别的文件类型
            iconView.image = [UIImage imageNamed:mimeType.icon];
            *stop = YES;
            
            self.downloadView.hidden = NO;
            self.fileUnableView.hidden = YES;
        } else {    // 不能识别的文件类型
            self.downloadView.hidden = YES;
            self.fileUnableView.hidden = NO;
        }
    }];

    // 图标添加进downloadView
    [downloadView addSubview:iconView];
    self.iconView = iconView;
    
    // 创建进度控件
    UIProgressView *progressView = [[UIProgressView alloc] init];
    [downloadView addSubview:progressView];
    self.progressView = progressView;
    
    YGFileModel *repoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:YGCurrentRepoPath];
    NSString *dirPath = [YGDirTool dir];
    
    // 请求文件下载地址
    NSDictionary *params = @{
                               @"p" : [NSString stringWithFormat:@"%@%@", dirPath, self.currentFileModel.name],
                               @"reuse" : @1
                               };

    [YGHttpTool getDownloadUrlWithRepoID:repoModel.ID params:params success:^(id responseObj) {
        NSString *genDownloadUrl = responseObj;
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.currentFileModel.name];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.downloadView removeFromSuperview];
        } else {
            //  请求下载文件
            [YGHttpTool downloadFile:genDownloadUrl progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressView setProgress:downloadProgress.fractionCompleted animated:YES];
                });
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSURL *cacheDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
                return [cacheDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self.downloadView removeFromSuperview];
                [self refreshCurrentPreviewItem];
            }];
        }
        
    } failure:^(NSError *error) {
        YGLog(@"--downloadFile--%@", error);
    }];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.fileUnableView.frame = self.view.bounds;
    
    self.downloadView.frame = self.view.bounds;
    
    self.iconView.centerX = self.view.centerX;
    self.iconView.y = self.view.height * 0.4;
    self.iconView.width = 60;
    self.iconView.height = self.iconView.width;
    
    self.progressView.centerX = self.view.centerX;
    self.progressView.y = CGRectGetMaxY(self.iconView.frame) + 30;
    self.progressView.width = 240;
    self.progressView.height = 10;
}

@end
