//
//  YGHttpTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGHttpTool.h"
#import "YGApiToken.h"
#import "YGApiTokenTool.h"

@implementation YGHttpTool
+ (void)GET:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", apiToken.token] forHTTPHeaderField:@"Authorization"];
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)POST:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", apiToken.token] forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    [YGHttpTool GET:url apiToken:token params:params success:success failure:failure];
}

+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    [YGHttpTool POST:url apiToken:token params:params success:success failure:failure];
}
@end
