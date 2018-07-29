//
//  NSString+Extension.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "NSString+Extension.h"
#import "YGFileTypeTool.h"

@implementation NSString (Extension)
+ (NSString *)extensionWithFile:(NSString *)file
{
    NSString *lastFiveStr = [file substringFromIndex:file.length - 5];

    NSArray *fileExts = [YGFileTypeTool fileExts];
    for (NSString *ext in fileExts) {
        if ([[lastFiveStr lowercaseString] containsString:ext]) return ext;
    }
    return nil;
}

+ (NSString *)stringWithSize:(NSNumber *)size
{
    NSInteger sizeFormat = [size integerValue];
    float metric = 1024.0;
    if (sizeFormat == 0) {
        return @"0 Byte";
        
    } else if (sizeFormat < metric) {
        return [NSString stringWithFormat:@"%.1f bytes", (float)sizeFormat];
        
    } else if ((sizeFormat >= metric) && (sizeFormat < metric * metric)) {
        return [NSString stringWithFormat:@"%.1f KB", sizeFormat / metric];
        
    } else if ((sizeFormat >= metric * metric) && (sizeFormat <= metric * metric * metric)) {
        return [NSString stringWithFormat:@"%.1f MB", sizeFormat / (metric * metric)];
    
    } else {
        return [NSString stringWithFormat:@"%.1f GB", sizeFormat / (metric * metric * metric)];
    }
}
@end
