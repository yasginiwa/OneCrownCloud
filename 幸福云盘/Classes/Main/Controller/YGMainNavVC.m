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
                            NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                            };
    [barAppearace setTitleTextAttributes:attrs];
    
    UIImage *backImage = [UIImage imageNamed:@"back_icon"];
    barAppearace.tintColor = YGColorRGB(54, 54, 54);
    [barAppearace setBackIndicatorImage:backImage];
    [barAppearace setBackIndicatorTransitionMaskImage:backImage];
}
@end
