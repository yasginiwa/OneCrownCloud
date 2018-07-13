//
//  UIImage+Extension.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/13.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:(image.size.width * 0.5 - 1) topCapHeight:(image.size.height * 0.5 - 1)];
    return image;
}
@end
