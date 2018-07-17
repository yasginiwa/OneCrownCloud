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
@property (nonatomic, weak) UIImageView *iconView;

/** 文件\文件夹名字 */
@property (nonatomic, weak) UILabel *nameLabel;

/** 文件\文件夹创建日志 */
@property (nonatomic, weak) UILabel *dateLabel;

/** 文件\文件夹大小 */
@property (nonatomic, weak) UILabel *sizeLabel;

/** 文件\文件夹checkbox*/
@property (nonatomic, weak) UIButton *checkBtn;
@end


@implementation YGFileCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"file";
    YGFileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YGFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UILabel *sizeLabel = [[UILabel alloc] init];
        sizeLabel.textColor = [UIColor lightGrayColor];
        sizeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:sizeLabel];
        self.sizeLabel = sizeLabel;
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setImage:[UIImage imageNamed:@"file_unselected"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"file_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:checkBtn];
        self.checkBtn = checkBtn;
    }
    return self;
}

- (void)setFileModel:(YGFileModel *)fileModel
{
    _fileModel = fileModel;
//    self.iconView.image = fileModel.type;
    self.nameLabel.text = fileModel.name;
    self.dateLabel.text = fileModel.mtime_relative;
    self.sizeLabel.text = fileModel.size_formatted;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10.0;
    
    // 图标的frame
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10.0);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@40.0);
    }];
    
    // 名字的frame
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView).offset(padding);
        make.right.equalTo(self.contentView).offset(80.0);
        make.top.equalTo(self.iconView).offset(padding);
        make.height.equalTo(@20);
    }];
    
    // 创建时间的frame
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(padding);
        make.height.equalTo(@10);
    }];
    
    // checkBtn的frame
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-padding);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
    }];
    
    // 文件大小label的frame
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.checkBtn).offset(-2 * padding);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
}
@end
