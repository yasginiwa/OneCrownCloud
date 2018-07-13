//
//  YGLoginMidView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGLoginMidView.h"
#import "YGInputView.h"

@interface YGLoginMidView () <YGInputViewDelegate>
@property (nonatomic, weak) YGInputView *userView;
@property (nonatomic, weak) YGInputView *pwView;
@property (nonatomic, weak) UIButton *loginBtn;
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
        pwView.delegate = self;
        [self addSubview:pwView];
        self.pwView = pwView;
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_disabled"] forState:UIControlStateDisabled];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_normal"] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_pressed"] forState:UIControlStateHighlighted];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        loginBtn.enabled = NO;

        [self addSubview:loginBtn];
        self.loginBtn = loginBtn;
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
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.pwView).offset(80.0);
        make.height.equalTo(@37);
        make.left.equalTo(self.pwView).equalTo(@20);
        make.right.equalTo(self.pwView).equalTo(@-20);
    }];
}

#pragma mark - YGInputViewDelegate
- (void)inputViewDidEndEditing:(YGInputView *)inputView
{
    self.loginBtn.enabled = YES;
}
@end
