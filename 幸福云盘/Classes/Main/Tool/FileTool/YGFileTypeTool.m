//
//  YGFileTypeTool.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileTypeTool.h"
#import "YGMimeType.h"

@implementation YGFileTypeTool
+ (NSMutableArray *)fileTypes
{
    NSArray *mimeTypes = [YGFileTypeTool fileTypes];
    if (mimeTypes == nil) return nil;
    NSMutableArray *fileTypes = [NSMutableArray array];
    for (YGMimeType *mimeType in mimeTypes) {
        [fileTypes addObject:mimeType.type];
    }
    return fileTypes;
}

+ (NSMutableArray *)fileMimeTypes
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FileMimeType.plist" ofType:nil];
    NSArray *fileMimeTypes = [NSArray arrayWithContentsOfFile:filePath];
    return [YGMimeType mj_objectArrayWithKeyValuesArray:fileMimeTypes];
}
@end
