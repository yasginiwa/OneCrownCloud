//
//  YGUploadCell.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGUploadCell.h"
#import "YGTransferProgressBtn.h"
#import "YGFileTypeTool.h"
#import "YGFileModel.h"
#import "YGMimeType.h"

@interface YGUploadCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *uploadLabel;
@property (nonatomic, weak) IBOutlet UILabel *uploadTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property (nonatomic, weak) IBOutlet YGTransferProgressBtn *transferProgressBtn;
@end


@implementation YGUploadCell
+ (instancetype)uploadCell
{
    YGUploadCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YGUploadCell" owner:nil options:nil] lastObject];
    return cell;
}

- (void)setUploadFileModel:(YGFileModel *)uploadFileModel
{
    _uploadFileModel = uploadFileModel;
    // 文件夹显示默认图标
    if ([YGFileTypeTool isRepo:uploadFileModel] || [YGFileTypeTool isDir:uploadFileModel]) {
        self.iconView.image = [UIImage imageNamed:@"file_folder_icon"];
    } else {    // 文件显示图标判断
        NSString *fileExt = [NSString extensionWithFile:uploadFileModel.name];
        
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
    
    //  设置上传文件名称
    self.uploadLabel.text = uploadFileModel.name;
    
    //  设置上传文件的时间
    self.uploadTimeLabel.text = [NSString stringWithFormat:@"%@", uploadFileModel.mtime];
    
    if (uploadFileModel.size) {
        self.sizeLabel.text = [NSString stringWithSize:uploadFileModel.size];
    } else {
        self.sizeLabel.text = nil;
    }
    
    self.transferProgressBtn.progress = uploadFileModel.uploadProgress;
}
@end
