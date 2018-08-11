//
//  YGFileCell.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileCell.h"
#import "YGFileModel.h"
#import "YGFileTypeTool.h"
#import "YGMimeType.h"

@interface YGFileCell ()
/** 文件\文件夹图标 */
@property (nonatomic, weak) IBOutlet UIImageView *iconView;

/** 文件\文件夹名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

/** 文件\文件夹创建日志 */
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

/** 文件\文件夹大小 */
@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;

/** 文件\文件夹checkbox*/
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@end


@implementation YGFileCell
+ (instancetype)fileCell
{
    YGFileCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YGFileCell" owner:nil options:nil] lastObject];
    
    return cell;
}

- (void)setFileModel:(YGFileModel *)fileModel
{
    _fileModel = fileModel;
    self.nameLabel.text = fileModel.name;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", fileModel.mtime];
    
    if (fileModel.size) {
        self.sizeLabel.text = [NSString stringWithSize:fileModel.size];
    } else {
        self.sizeLabel.text = nil;
    }
    
    // 文件夹显示默认图标
    if ([YGFileTypeTool isRepo:fileModel] || [YGFileTypeTool isDir:fileModel]) {
        self.iconView.image = [UIImage imageNamed:@"file_folder_icon"];
    } else {    // 文件显示图标判断
        NSString *fileExt = [NSString extensionWithFile:fileModel.name];
    
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
    
    self.checkBtn.selected = fileModel.isChecked;
}

- (IBAction)checkRepoFile:(UIButton *)sender {
    self.fileModel.checked = !sender.isSelected;
    sender.selected = self.fileModel.isChecked;
    if ([self.delegate respondsToSelector:@selector(fileCell:didSelectCheckBtn:fileModel:)]) {
        [self.delegate fileCell:self didSelectCheckBtn:sender fileModel:self.fileModel];
    }
}
@end
