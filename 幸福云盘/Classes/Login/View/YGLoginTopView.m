//
//  YGLoginTopView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGLoginTopView.h"

@interface YGLoginTopView ()
@property (nonatomic, weak) UIImageView *loginLogoView;
@property (nonatomic, weak) UILabel *welcomeLabel;
@end

@implementation YGLoginTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *loginLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
        [self addSubview:loginLogoView];
        self.loginLogoView = loginLogoView;
        
        UILabel *welcomeLabel = [[UILabel alloc] init];
        welcomeLabel.text = @"欢迎登录幸福云盘";
        welcomeLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:welcomeLabel];
        self.welcomeLabel = welcomeLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.loginLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.top.equalTo(@140);
    }];
    
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginLogoView);
        make.top.equalTo(self.loginLogoView.mas_bottom).offset(5.0);
    }];
}
@end
