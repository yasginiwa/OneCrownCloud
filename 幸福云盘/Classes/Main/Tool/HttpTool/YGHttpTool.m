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

/** GET请求方法封装 */
+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** POST请求方法封装 */
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** download方法封装 */
+ (void)DOWNLOAD:(NSString *)url progress:(NSProgress *)progress destination:(NSURL *(^)(NSURL *, NSURLResponse *))destination completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destination) {
            return NSURL * (^destination)(targetPath, response);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [downloadTask resume];
}


/** DELETE方法封装 */
+ (void)DELETE:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    [mgr DELETE:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** PUT方法封装 */
+ (void)PUT:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    [mgr PUT:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)listLibrariesParams:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    [YGHttpTool GET:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createLibraryParams:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject){
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteLibrary:(NSString *)repoID success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool DELETE:urlStr params:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameLibrary:(NSString *)repoID parmas:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)listDirectory:(NSString *)repoID success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool GET:urlStr params:nil success:^(id _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createDirectory:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteDirectory:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool DELETE:urlStr params:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameDirectory:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)downloadDirectory:(NSString *)repoID params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIRDOWNLOAD_URI];
    [YGHttpTool GET:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createFile:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteFile:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool DELETE:urlStr params:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameFile:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)moveFile:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)getUploadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_UPLOAD_URI];
    [YGHttpTool GET:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)uploadFileWithUrl:(NSString *)url params:(id)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    [YGHttpTool POST:url params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)getDownloadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    
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
