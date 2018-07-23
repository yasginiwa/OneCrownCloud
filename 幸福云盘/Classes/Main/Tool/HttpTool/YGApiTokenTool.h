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
+ (void)requestApiTokenWithConnection:(SeafConnection *)connection success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)saveToken:(YGApiToken *)apiToken;
+ (YGApiToken *)apiToken;
+ (void)clearToken;
@end
