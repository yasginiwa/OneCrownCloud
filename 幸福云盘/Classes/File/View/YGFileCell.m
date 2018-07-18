//
//  YGFileCell.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileCell.h"
#import "YGFileModel.h"

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
}

- (IBAction)checkRepoFile:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(fileCellDidSelectCheckBtn:)]) {
        [self.delegate fileCellDidSelectCheckBtn:self];
    }
    NSLog(@"%@", NSStringFromCGRect(self.dateLabel.frame));
    NSLog(@"%@", self.dateLabel.text);
}
@end
