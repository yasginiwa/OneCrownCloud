//
//  YGRepoTool.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/27.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGRepoTool.h"

@implementation YGRepoTool
+ (void)saveRepo:(YGFileModel *)repo
{
    [NSKeyedArchiver archiveRootObject:repo toFile:YGCurrentRepoPath];
}

+ (YGFileModel *)repo
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YGCurrentRepoPath];
}
@end
