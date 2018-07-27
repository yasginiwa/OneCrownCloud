//
//  YGApiTokenTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGApiToken;

@interface YGApiTokenTool : NSObject

/** 保存token */
+ (void)saveToken:(YGApiToken *)apiToken;

/** 获取token */
+ (YGApiToken *)apiToken;

/** 清除token */
+ (void)clearToken;
@end
