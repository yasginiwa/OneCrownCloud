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
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) YGLoginTopView *loginTopView;
@property (nonatomic, weak) YGLoginMidView *loginMidView;
@end

@implementation YGLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    
    [self addEidtObserver];
    
    [self setupNavBar];
    
    [self setupLoginTopView];
    
    [self setupLoginMidView];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = CGRectMake(0, 0, scrnW, scrnH);
    scrollView.contentSize = CGSizeMake(0, scrnH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupNavBar
{
    self.title = @"幸福云盘账号登录";
    

}

- (void)setupLoginTopView
{
    YGLoginTopView *loginTopView = [[YGLoginTopView alloc] init];
    [self.scrollView addSubview:loginTopView];
    loginTopView.frame = CGRectMake(0, 0, self.view.width, self.view.height * 0.3);
    self.loginTopView = loginTopView;
}

- (void)setupLoginMidView
{
    YGLoginMidView *loginMidView = [[YGLoginMidView alloc] init];
    [self.scrollView addSubview:loginMidView];
    CGFloat loginMidViewY = CGRectGetMaxY(self.loginTopView.frame);
    loginMidView.frame = CGRectMake(0, loginMidViewY, self.view.width, self.view.height * 0.7);
    self.loginMidView = loginMidView;
}

- (void)addEidtObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToLogin) name:YGLoginDidBeginEditNotification object:nil];
}

- (void)scrollToLogin
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 64);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
