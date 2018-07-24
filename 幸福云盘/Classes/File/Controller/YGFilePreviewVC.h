//
//  YGFilePreviewVC.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/24.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@class YGFileModel;

@interface YGFilePreviewVC : QLPreviewController
@property (nonatomic, strong) YGFileModel *repoModel;
@property (nonatomic, strong) YGFileModel *fileModel;
@end
