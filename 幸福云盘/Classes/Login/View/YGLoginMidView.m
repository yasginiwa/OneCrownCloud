//
//  YGLoginMidView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGLoginMidView.h"
#import "YGInputView.h"
#import <SeafConnection.h>
#import "YGAccount.h"
#import "YGAccountTool.h"

@interface YGLoginMidView () <SeafLoginDelegate>
@property (nonatomic, weak) YGInputView *userView;
@property (nonatomic, weak) YGInputView *pwView;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, strong) SeafConnection *seafConn;
@end

@implementation YGLoginMidView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        YGInputView *userView = [[YGInputView alloc] initWithPlaceHolder:@"请输入用户名/邮箱" title:@"用户名/邮箱" security:NO];
        [self addSubview:userView];
        self.userView = userView;
        
        YGInputView *pwView = [[YGInputView alloc] initWithPlaceHolder:@"请输入登录密码" title:@"登录密码" security:YES];
        [self addSubview:pwView];
        self.pwView = pwView;
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_disabled"] forState:UIControlStateDisabled];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_normal"] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage resizeImage:@"login_button_pressed"] forState:UIControlStateHighlighted];
        [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.enabled = NO;

        [self addSubview:loginBtn];
        self.loginBtn = loginBtn;
    }
    return self;
}

//
- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToLogin) name:UITextFieldTextDidChangeNotification object:nil];
}

/*
 * 接收到通知 用户名\密码都已输入 可以准备登陆了
 */
- (void)readyToLogin
{
    if (self.userView.inputField.text.length && self.pwView.inputField.text.length) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}

/*
 * 布局子控件
 */
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

/*
 * 登陆
 */
- (void)login
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    SeafConnection *seafConn = [[SeafConnection alloc] initWithUrl:BASE_URL cacheProvider:nil];
    seafConn.loginDelegate = self;
    [seafConn loginWithUsername:self.userView.inputField.text password:self.pwView.inputField.text otp:nil rememberDevice:NO];
    self.seafConn = seafConn;
}

#pragma mark - SeafLoginDelegate
- (void)loginSuccess:(SeafConnection *)connection
{
    NSLog(@"登录成功");
    [SVProgressHUD dismiss];
    
    // 请求成功登录后的token
    __block NSString *token;
    [YGAccountTool getTokenWithConnection:connection success:^(id responseObject) {
        token = responseObject[@"token"];
    } failure:^(NSError *error) {
        YGLog(@"获取token失败");
    }];
    
    // 请求账号模型信息并储存
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    NSString *accountInfoUrl = [BASE_URL stringByAppendingString:@"/api2/account/info"];
    
    [mgr GET:accountInfoUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        YGAccount *account = [YGAccount mj_objectWithKeyValues:responseObject];
        [YGAccountTool saveAccount:account];
        YGLog(@"成功%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@", error);
    }];

//    NSURL *accountInfoURL = [NSURL URLWithString:@"http://www.crowncake.cn:50080/api2/account/info"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:accountInfoURL];
//    request.HTTPMethod = @"POST";
//    request.allHTTPHeaderFields
    
    
//    NSString *accountInfoURL = [NSString stringWithFormat:@"%@%@%@", BaseURL,API_URL,accountURL];
//    YGLog(@"%@---", self.seafConn.info);
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    [mgr GET:accountInfoURL parameters:@{@"user":@"admin@seafile.local"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        YGLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YGLog(@"%@", error);
//    }];
}

- (void)loginFailed:(SeafConnection *)connection response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    NSLog(@"登录失败%@", response);
    YGLog(@"%@---", self.seafConn.info);
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
