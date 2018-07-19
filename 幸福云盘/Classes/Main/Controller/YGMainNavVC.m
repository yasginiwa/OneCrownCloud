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
    
//    UIImage *barBgImage = [UIImage imageNamed:@"nav_bg"];
//    [barBgImage stretchableImageWithLeftCapWidth:(barBgImage.size.width * 0.5 - 1) topCapHeight:(barBgImage.size.height * 0.5) - 1];
//    barAppearace.backgroundColor = [UIColor colorWithPatternImage:barBgImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
