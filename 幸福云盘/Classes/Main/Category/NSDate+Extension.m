//
//  NSDate+Extension.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/28.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+ (NSString *)dateWithMtime:(NSNumber *)mtime
{
    float seconds = [mtime longLongValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:date];
}
@end
