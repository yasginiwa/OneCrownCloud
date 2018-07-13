//
//  YGLoginVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGLoginVC.h"
#import "YGLoginTopView.h"
#import "YGLoginMidView.h"

@interface YGLoginVC()
@property (nonatomic, weak) YGLoginTopView *loginTopView;
@property (nonatomic, weak) YGLoginMidView *loginMidView;
@end

@implementation YGLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    [self setupLoginTopView];
    
    [self setupLoginMidView];
}

- (void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.title = @"幸福云盘账号登录";
    
    UIImage *barBgImage = [UIImage imageNamed:@"nav_bg"];
    [barBgImage stretchableImageWithLeftCapWidth:(barBgImage.size.width * 0.5 - 1) topCapHeight:(barBgImage.size.height * 0.5) - 1];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:barBgImage];
}

- (void)setupLoginTopView
{
    YGLoginTopView *loginTopView = [[YGLoginTopView alloc] init];
    [self.view addSubview:loginTopView];
    loginTopView.frame = CGRectMake(0, 0, self.view.width, self.view.height * 0.3);
    self.loginTopView = loginTopView;
}

- (void)setupLoginMidView
{
    YGLoginMidView *loginMidView = [[YGLoginMidView alloc] init];
    [self.view addSubview:loginMidView];
    CGFloat loginMidViewY = CGRectGetMaxY(self.loginTopView.frame);
    loginMidView.frame = CGRectMake(0, loginMidViewY, self.view.width, self.view.height * 0.3);
    self.loginMidView = loginMidView;
}
@end
