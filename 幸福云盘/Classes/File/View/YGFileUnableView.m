//
//  YGFileUnableView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/29.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileUnableView.h"

@interface YGFileUnableView ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *unableLabel;
@end


@implementation YGFileUnableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"file_unable_normal"];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *unableLabel = [[UILabel alloc] init];
        unableLabel.text = @"抱歉，该文件暂时无法预览";
        unableLabel.font = [UIFont systemFontOfSize:18];
        unableLabel.textAlignment = NSTextAlignmentCenter;
        unableLabel.textColor = [UIColor grayColor];
        [self addSubview:unableLabel];
        self.unableLabel = unableLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.centerX = self.centerX;
    self.iconView.y = self.height * 0.4;
    self.iconView.width = 100;
    self.iconView.height = self.iconView.width;
    
    self.unableLabel.centerX = self.centerX;
    self.unableLabel.y = CGRectGetMaxY(self.iconView.frame) + 30;
    self.unableLabel.width = self.width;
    self.unableLabel.height = 18;
}

@end
