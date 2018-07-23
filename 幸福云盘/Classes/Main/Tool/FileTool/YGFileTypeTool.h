//
//  YGFileTypeTool.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGFileTypeTool : NSObject
/** 返回文件类型数组 */
+ (NSMutableArray *)fileTypes;

/** 返回文件mimeType对象数组 */
+ (NSMutableArray *)fileMimeTypes;
@end
