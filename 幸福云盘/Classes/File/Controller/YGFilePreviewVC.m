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

@interface YGFilePreviewVC ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) UIView *downloadView;

@end

@implementation YGFilePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDownloadView];
}

- (void)setupDownloadView
{
    UIView *downloadView = [[UIView alloc] init];
    downloadView.frame = self.view.bounds;
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

    
    [downloadView addSubview:iconView];
    self.iconView = iconView;
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    [downloadView addSubview:progressView];
    self.progressView = progressView;
    
    NSString *downloadUrl = [[[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:self.repoModel.ID] stringByAppendingString:@"/file/"];
    
    NSDictionary *params = @{
                             @"p" : [NSString stringWithFormat:@"/%@", self.fileModel.name]
                             };
    
    [YGHttpTool GET:downloadUrl params:params success:^(id responseObj) {
        YGLog(@"%@", responseObj);
    } failure:^(NSError *error) {
        YGLog(@"%@", error);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downloadView);
        make.centerY.equalTo(self.downloadView).multipliedBy(0.7);
        make.width.height.equalTo(@40);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView).offset(20.0);
        make.centerX.equalTo(self.downloadView);
        make.height.equalTo(@3);
        make.width.equalTo(@100);
    }];
}
@end
