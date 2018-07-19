//
//  UIButton+Extension.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+ (UIButton *)buttonWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
