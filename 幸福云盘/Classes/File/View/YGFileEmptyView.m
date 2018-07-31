//
//  YGFileEmptyView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/21.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileEmptyView.h"

@interface YGFileEmptyView ()
@property (nonatomic, weak) UIImageView *emptyImageView;
@property (nonatomic, weak) UILabel *emptyLabel;
@end

@implementation YGFileEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file_empty_normal"]];
        [self addSubview:emptyImageView];
        self.emptyImageView = emptyImageView;
        
        UILabel *emptyLabel = [[UILabel alloc] init];
        emptyLabel.font = [UIFont systemFontOfSize:15];
        emptyLabel.textColor = YGColorRGB(181, 181, 181);
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.text = @"哎哟，文件夹是空的^_^";
        [self addSubview:emptyLabel];
        self.emptyLabel = emptyLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.6);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(30.0);
        make.centerX.equalTo(self.emptyImageView);
        make.width.equalTo(self);
        make.height.equalTo(@15);
    }];
}
@end
