//
//  YGDownloadCell.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGDownloadCell.h"
#import "YGFileTypeTool.h"
#import "YGFileModel.h"
#import "YGMimeType.h"
#import "YGTransferProgressBtn.h"

@interface YGDownloadCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *downloadTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property (nonatomic, weak) IBOutlet YGTransferProgressBtn *transferProgressBtn;
@end


@implementation YGDownloadCell

+ (instancetype)downloadCell
{
    YGDownloadCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YGDownloadCell" owner:nil options:nil] lastObject];
    return cell;
}

- (void)setDownloadFileModel:(YGFileModel *)downloadFileModel
{
    _downloadFileModel = downloadFileModel;
    
    // 文件夹显示默认图标
    if ([YGFileTypeTool isRepo:downloadFileModel] || [YGFileTypeTool isDir:downloadFileModel]) {
        self.iconView.image = [UIImage imageNamed:@"file_folder_icon"];
    } else {    // 文件显示图标判断
        NSString *fileExt = [NSString extensionWithFile:downloadFileModel.name];
        
        NSArray *fileMimeTypes = [YGFileTypeTool fileMimeTypes];
        [fileMimeTypes enumerateObjectsUsingBlock:^(YGMimeType *mimeType, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[fileExt lowercaseString] isEqualToString:mimeType.mime]) {    // 能识别的文件类型
                self.iconView.image = [UIImage imageNamed:mimeType.icon];
                *stop = YES;
            } else {
                self.iconView.image = [UIImage imageNamed:@"file_unknown_icon"];
            }
        }];
    }
    
    //  文件名称
    self.nameLabel.text = downloadFileModel.name;
    
    //  创建文件下载日期
    self.downloadTimeLabel.text = downloadFileModel.mtime;
    
    //  文件大小
    if (downloadFileModel.size) {
        self.sizeLabel.text = [NSString stringWithSize:downloadFileModel.size];
    } else {
        self.sizeLabel.text = nil;
    }
    
    self.transferProgressBtn.progress = downloadFileModel.downloadFromIcloudProgress;
}
@end
