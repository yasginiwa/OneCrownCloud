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
+ (NSArray *)fileTypes
{

    NSArray *mimeTypes = [YGFileTypeTool fileTypes];
    if (mimeTypes == nil) return nil;
    NSMutableArray *fileTypes = [NSMutableArray array];
    for (YGMimeType *mimeType in mimeTypes) {
        [fileTypes addObject:mimeType.type];
    }
    return fileTypes;
}

+ (NSArray *)fileMimeTypes
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FileMimeType.plist" ofType:nil];
    return [YGMimeType mj_objectArrayWithFilename:filePath];
}
@end
