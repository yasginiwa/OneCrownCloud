//
//  YGLoginMidView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGLoginMidView.h"
#import "YGInputView.h"

@interface YGLoginMidView ()
@property (nonatomic, weak) YGInputView *userView;
@property (nonatomic, weak) YGInputView *pwView;
@end

@implementation YGLoginMidView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        YGInputView *userView = [[YGInputView alloc] initWithPlaceHolder:@"请输入用户名/邮箱" title:@"用户名/邮箱"];
        userView.security = NO;
        [self addSubview:userView];
        self.userView = userView;
        
        YGInputView *pwView = [[YGInputView alloc] initWithPlaceHolder:@"请输入登录密码" title:@"登录密码"];
        pwView.security = YES;
        [self addSubview:pwView];
        self.pwView = pwView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.top.equalTo(@20);
        make.height.equalTo(@80);
    }];
    
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userView);
        make.top.equalTo(self.userView.mas_bottom).offset(10.0);
        make.height.equalTo(self.userView);
    }];
}
@end
