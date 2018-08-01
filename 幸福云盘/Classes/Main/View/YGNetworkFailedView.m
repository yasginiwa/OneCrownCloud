//
//  YGNetworkFailedView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/31.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGNetworkFailedView.h"

@interface YGNetworkFailedView ()
@property (nonatomic, weak) UIImageView *failedImageView;
@property (nonatomic, weak) UILabel *tipsLabel;
@end

@implementation YGNetworkFailedView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *failedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_failed"]];
        [self addSubview:failedImageView];
        self.failedImageView = failedImageView;
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.textColor = YGColorRGB(230, 230, 230);
        tipsLabel.text = @"请下拉重新加载...";
        [self addSubview:tipsLabel];
        self.tipsLabel = tipsLabel;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.bounds;
    self.y = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.failedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.7);
        make.width.equalTo(@60);
        make.height.equalTo(@130);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.failedImageView.mas_bottom).offset(30.0);
        make.width.equalTo(self);
        make.height.equalTo(@15);
    }];
}
@end
