//
//  YGAccountTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/15.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGAccountTool.h"

@implementation YGAccountTool
+ (void)saveAccount:(YGAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:YGAccountPath];
}

+ (void)clearAccount
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:YGAccountPath error:nil];
}
@end
