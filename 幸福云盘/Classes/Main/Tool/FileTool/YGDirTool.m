//
//  YGDirTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/29.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGDirTool.h"
#import "YGFileModel.h"

@implementation YGDirTool
+ (void)saveDir:(YGFileModel *)dir
{
    NSMutableArray *dirArray = [NSMutableArray array];
    if ([[NSFileManager defaultManager] fileExistsAtPath:YGDirPath]) {
        dirArray = [NSKeyedUnarchiver unarchiveObjectWithFile:YGDirPath];
    };
    [dirArray addObject:dir];
    [NSKeyedArchiver archiveRootObject:dirArray toFile:YGDirPath];
}

+ (NSString *)dir
{
    NSString *nilPath = @"";
    if (![[NSFileManager defaultManager] fileExistsAtPath:YGDirPath]) return nilPath;
    NSMutableArray *dirArray = [NSKeyedUnarchiver unarchiveObjectWithFile:YGDirPath];
    NSString *currentPath = nilPath;
    for (YGFileModel *dirModel in dirArray) {
        currentPath = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", dirModel.name]];
    }
    return currentPath;
}

+ (void)backToParentDir
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:YGDirPath]) return;
    NSMutableArray *dirArray = [NSKeyedUnarchiver unarchiveObjectWithFile:YGDirPath];
    [dirArray removeLastObject];
    [NSKeyedArchiver archiveRootObject:dirArray toFile:YGDirPath];
}

+ (void)removeDir
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:YGDirPath]) {
        [mgr removeItemAtPath:YGDirPath error:nil];
    }
}
@end
