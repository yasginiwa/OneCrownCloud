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
    self.dateLabel.text = fileModel.mtime_relative;
    self.sizeLabel.text = fileModel.size_formatted;
    
    // 文件夹显示默认图标
    if ([fileModel.type isEqualToString:@"repo"]) return;
    
    UIImage *fileIcon = [[UIImage alloc] init];
    NSString *fileExt = [NSString extensionWithFile:fileModel.name];
    
    // 文件显示图标判断
    for (YGMimeType *mimeType in [YGFileTypeTool fileMimeTypes]) {  // 能识别的文件类型
        if ([fileExt isEqualToString:mimeType.type]) {
            fileIcon = [UIImage imageNamed:mimeType.icon];
        } else {    // 不能识别的文件类型
            fileIcon = [UIImage imageNamed:@"file_unknown_icon"];
        }
    }
    self.iconView.image = fileIcon;
}

- (IBAction)checkRepoFile:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(fileCellDidSelectCheckBtn:)]) {
        [self.delegate fileCellDidSelectCheckBtn:self];
    }
}
@end
