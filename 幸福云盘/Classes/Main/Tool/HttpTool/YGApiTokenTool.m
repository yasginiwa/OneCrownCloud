//
//  YGApiTokenTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGApiTokenTool.h"

@implementation YGApiTokenTool
+ (void)saveToken:(YGApiToken *)apiToken
{
    [NSKeyedArchiver archiveRootObject:apiToken toFile:YGTokenPath];
}

+ (YGApiToken *)apiToken
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YGTokenPath];
}

+ (void)clearToken
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:YGTokenPath error:nil];
}
@end
