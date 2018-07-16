//
//  YGAccountTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/15.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGAccountTool.h"

@implementation YGAccountTool
+ (void)saveAccount:(YGAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:YGAccountPath];
}

+ (void)clearAccount
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:YGAccountPath error:nil];
}

+ (void)getTokenWithConnection:(SeafConnection *)connection success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSDictionary *params = @{
                             @"username" : connection.username,
                             @"password" : connection.password
                             };
    NSString *tokenURL = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:TOKEN_URL]];
    [mgr POST:tokenURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
