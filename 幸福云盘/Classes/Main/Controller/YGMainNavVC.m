//
//  YGMainNavVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGMainNavVC.h"

@interface YGMainNavVC ()

@end


@implementation YGMainNavVC


+ (void)initialize
{
    //  统一设置bar的外观
    UINavigationBar *barAppearace = [UINavigationBar appearance];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [barAppearace setTitleTextAttributes:attrs];
    
    UIImage *backImage = [UIImage imageNamed:@"back_icon"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    barAppearace.tintColor = YGColorRGB(54, 54, 54);
    [barAppearace setBackIndicatorImage:backImage];
    [barAppearace setBackIndicatorTransitionMaskImage:backImage];
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIOffset offset;
    offset.vertical = -0.8;
    [barButtonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
    
    //   统一设置item的外观
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSDictionary *itemAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    [appearance setTitleTextAttributes:itemAttrs  forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
}

@end
