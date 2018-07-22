//
//  YGHttpTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGApiToken;

@interface YGHttpTool : NSObject
/** GET POST方法 需传入token对象 */
+ (void)GET:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)POST:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** GET POST方法 已包含token 无需传入 */
+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
