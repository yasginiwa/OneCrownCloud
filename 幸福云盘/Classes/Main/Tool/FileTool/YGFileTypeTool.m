//
//  YGFileTypeTool.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileTypeTool.h"
#import "YGMimeType.h"
#import "YGFileModel.h"

@implementation YGFileTypeTool

+ (NSMutableArray *)fileMimeTypes
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FileMimeType.plist" ofType:nil];
    NSArray *fileMimeTypes = [NSArray arrayWithContentsOfFile:filePath];
    return [YGMimeType mj_objectArrayWithKeyValuesArray:fileMimeTypes];
}

+ (BOOL)isRepo:(YGFileModel *)fileModel
{
    return [fileModel.type isEqualToString:@"repo"];
}

+ (BOOL)isDir:(YGFileModel *)fileModel
{
    return [fileModel.type isEqualToString:@"dir"];
}

+ (BOOL)isFile:(YGFileModel *)fileModel
{
    return [fileModel.type isEqualToString:@"file"];
}
@end
