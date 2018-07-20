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
    UINavigationBar *barAppearace = [UINavigationBar appearance];
    NSDictionary *attrs = @{
                            NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                            };
    [barAppearace setTitleTextAttributes:attrs];
    
    [barAppearace setBackIndicatorImage:[UIImage imageNamed:@"nav_back_icon"]];
    [barAppearace setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_back_icon"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
