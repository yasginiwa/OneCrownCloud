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
@end
