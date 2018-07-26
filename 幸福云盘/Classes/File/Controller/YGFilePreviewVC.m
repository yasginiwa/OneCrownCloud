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

@interface YGFilePreviewVC ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) UIView *downloadView;
// 下载进度
@property (nonatomic, strong) NSProgress *progress;
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
    
    UIImageView *iconView = [[UIImageView alloc] init];
    
    // 文件夹显示默认图标
    NSString *fileExt = [NSString extensionWithFile:self.fileModel.name];
    
    // 文件显示图标判断
    NSArray *fileMimeTypes = [YGFileTypeTool fileMimeTypes];
    [fileMimeTypes enumerateObjectsUsingBlock:^(YGMimeType *mimeType, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[fileExt lowercaseString] isEqualToString:mimeType.mime]) {    // 能识别的文件类型
            iconView.image = [UIImage imageNamed:mimeType.icon];
            *stop = YES;
        } else {    // 不能识别的文件类型
            iconView.image = [UIImage imageNamed:@"file_unknown_icon"];
        }
    }];

    // 图标添加进downloadView
    [downloadView addSubview:iconView];
    self.iconView = iconView;
    
    // 创建进度控件
    UIProgressView *progressView = [[UIProgressView alloc] init];
    [downloadView addSubview:progressView];
    self.progressView = progressView;
    
    // 请求文件下载地址
    NSDictionary *params;
    if ([YGFileTypeTool isDir:self.repoModel]) {
        params = @{
                   @"p" : [[NSString stringWithFormat:@"/%@/%@", self.repoModel.name, self.fileModel.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   @"reuse" : @1
                   };
    }
    
    if ([YGFileTypeTool isFile:self.fileModel]) {
        params = @{
                   @"p" : [[NSString stringWithFormat:@"/%@", self.fileModel.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   @"reuse" : @1
                   };
    }
    
    YGFileModel *repoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:YGCurrentRepoPath];
    [YGHttpTool getDownloadUrlWithRepoID:repoModel.ID params:params success:^(id responseObj) {
        NSString *genDownloadUrl = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.fileModel.name];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.downloadView removeFromSuperview];
            return;
        }
        //  请求下载文件
        [YGHttpTool downloadFile:genDownloadUrl finishProgress:^(NSProgress *progress) {
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            self.progress = progress;
        } completion:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self.downloadView removeFromSuperview];
            [self refreshCurrentPreviewItem];
        }];

    } failure:^(NSError *error) {
        YGLog(@"--downloadFile--%@", error);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    float changeFL = [[change valueForKey:@"new"] floatValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:changeFL animated:YES];
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.downloadView.frame = self.view.bounds;
    
    self.iconView.centerX = self.view.centerX;
    self.iconView.y = self.view.height * 0.4;
    self.iconView.width = 60;
    self.iconView.height = self.iconView.width;
    
    self.progressView.centerX = self.view.centerX;
    self.progressView.y = CGRectGetMaxY(self.iconView.frame) + 30;
    self.progressView.width = 240;
    self.progressView.height = 5;
}

- (void)dealloc
{
    [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
}
@end
