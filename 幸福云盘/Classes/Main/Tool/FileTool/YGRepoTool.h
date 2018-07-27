//
//  YGRepoTool.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/27.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFileModel;

@interface YGRepoTool : NSObject
/** 保存repo对象 */
+ (void)saveRepo:(YGFileModel *)repo;

/** 从沙盒获取repo对象 */
+ (YGFileModel *)repo;
@end
