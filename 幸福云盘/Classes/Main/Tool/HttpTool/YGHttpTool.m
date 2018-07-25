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
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
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
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
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

+ (void)getDownloadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    NSString *url = [[[[BASE_URL stringByAppendingString:API_URL] stringByAppendingString:LIST_LIBARIES_URL] stringByAppendingString:repoID] stringByAppendingString:@"/file/"];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    YGApiToken *token = [YGApiTokenTool apiToken];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // 此项目中返回的是字符串 不是json 故返回结果序列化 然后转换成字符串
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)downloadFile:(NSString *)url finishProgress:(void (^)(NSProgress *progress))finishProgress completion:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completion
{
    // 去掉返回的downloadurl中多余的\"
    url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfg];
    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithRequest:downloadRequest progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *cacheUrl = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [cacheUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completion(response, filePath, error);
    }];

    [downloadTask resume];
    
    finishProgress([mgr downloadProgressForTask:downloadTask]);
}
@end
