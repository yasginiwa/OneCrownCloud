//
//  YGFileTypeTool.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFileModel;

@interface YGFileTypeTool : NSObject
/** 返回文件mimeType对象数组 */
+ (NSMutableArray *)fileMimeTypes;

/** 判断是否是repo */
+ (BOOL)isRepo:(YGFileModel *)fileModel;

/** 判断是否是dir */
+ (BOOL)isDir:(YGFileModel *)fileModel;

/** 判断是否是file */
+ (BOOL)isFile:(YGFileModel *)fileModel;


@end
