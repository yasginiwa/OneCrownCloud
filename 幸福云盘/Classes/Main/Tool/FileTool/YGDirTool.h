//
//  YGDirTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/29.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFileModel;

@interface YGDirTool : NSObject
/** 保存dir对象 */
+ (void)saveDir:(YGFileModel *)dir;

/** 从沙盒获取dir对象 */
+ (NSString *)dir;

/** 返回上一级目录 */
+ (void)backToParentDir;

/** 从沙盒删除dir对象 */
+ (void)removeDir;
@end
