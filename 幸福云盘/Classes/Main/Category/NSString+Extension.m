//
//  NSString+Extension.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (NSString *)extensionWithFile:(NSString *)file
{
    NSRange range = [file rangeOfString:@"."];
    NSString *fileExt = [file substringWithRange:NSMakeRange(range.location, (file.length - range.location))];
    YGLog(@"%@", fileExt);
    return fileExt;
}
@end
