//
//  YGMainTabBarVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGMainTabBarVC.h"
#import "YGMainNavVC.h"
#import "YGFileVC.h"
#import "YGStarVC.h"
#import "YGTansferVC.h"
#import "YGProfileVC.h"

@interface YGMainTabBarVC ()

@end

@implementation YGMainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllChildVC];
    
    self.selectedIndex = 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedIndex = 0;
    });
}

- (void)addAllChildVC
{
    YGFileVC *fileVC = [[YGFileVC alloc] init];
    [self addOneChildVC:fileVC title:@"幸福网盘" image:@"tab_file_normal" selectedImage:@"tab_file_pressed"];
    
    YGStarVC *starVC = [[YGStarVC alloc] init];
    [self addOneChildVC:starVC title:@"分享" image:@"tab_share_normal" selectedImage:@"tab_share_pressed"];
    
    YGTansferVC *transferVC = [[YGTansferVC alloc] init];
    [self addOneChildVC:transferVC title:@"传输列表" image:@"tab_transfer_normal" selectedImage:@"tab_transfer_pressed"];
    
    YGProfileVC *profileVC = [[YGProfileVC alloc] init];
    [self addOneChildVC:profileVC title:@"我" image:@"tab_profile_normal" selectedImage:@"tab_profile_pressed"];
}

- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName
{
    // 设置tabBar标题
    childVC.title = title;
    
    // 设置tabBar图标
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.image = image;
    
    // 设置tabBar选中时的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = selectedImage;
    
    // 设置tabBar字体样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YGColorRGB(54, 54, 54);
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBar选中字体样式
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = YGColorRGB(36, 140, 251);
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    YGMainNavVC *navVC = [[YGMainNavVC alloc] initWithRootViewController:childVC];
    [self addChildViewController:navVC];
}
@end
