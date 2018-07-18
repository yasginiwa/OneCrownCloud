//
//  YGFileModel.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileModel.h"

@implementation YGFileModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             @"VIRTUAL" : @"virtual"
             };
}

- (void)setMtime_relative:(NSString *)mtime_relative
{
    // 截串返回的数值 重新给时间赋值
    NSRange fromRange = [mtime_relative rangeOfString:@"title=\""];
    mtime_relative = [mtime_relative substringWithRange:NSMakeRange(fromRange.location + 7, fromRange.length + 24)];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE, dd MM yyyy HH:mm:ss Z";
    NSDate *originDate = [fmt dateFromString:mtime_relative];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    mtime_relative = [fmt stringFromDate:originDate];
    _mtime_relative = mtime_relative;
}
@end
