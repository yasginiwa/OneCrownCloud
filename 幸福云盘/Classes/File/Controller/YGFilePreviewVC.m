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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDownloadView];
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
    NSDictionary *params = @{
                             @"p" : [NSString stringWithFormat:@"/%@", self.fileModel.name],
                             @"reuse" : @1
                             };
    [YGHttpTool getDownloadUrlWithRepoID:self.repoModel.ID params:params success:^(id responseObj) {
        NSString *genDownloadUrl = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        //  请求下载文件 progress 下载进度
//        [YGHttpTool downloadFile:genDownloadUrl finishProgress:^(NSProgress *progress) {
//            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//            self.progress = progress;
//        }];;
        
        [YGHttpTool downloadFile:genDownloadUrl finishProgress:^(NSProgress *progress) {
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            self.progress = progress;
        } completion:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//            [self.downloadView removeFromSuperview];
            YGLog(@"--completion--");
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
    
    [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downloadView);
        make.centerY.equalTo(self.downloadView).multipliedBy(0.9);
        make.width.height.equalTo(@60);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(20.0);
        make.centerX.equalTo(self.downloadView);
        make.height.equalTo(@5);
        make.width.equalTo(@180);
    }];
}

- (void)dealloc
{
    [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
}
@end
