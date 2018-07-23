//
//  YGApiTokenTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGApiTokenTool.h"
#import "YGApiTokenTool.h"

@implementation YGApiTokenTool
+ (void)requestApiTokenWithConnection:(SeafConnection *)connection success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{
                             @"username" : connection.username,
                             @"password" : connection.password
                             };
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *url = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:TOKEN_URL]];
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)saveToken:(YGApiToken *)apiToken
{
    [NSKeyedArchiver archiveRootObject:apiToken toFile:YGTokenPath];
}

+ (YGApiToken *)apiToken
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YGTokenPath];
}

+ (void)clearToken
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:YGTokenPath error:nil];
}
@end
