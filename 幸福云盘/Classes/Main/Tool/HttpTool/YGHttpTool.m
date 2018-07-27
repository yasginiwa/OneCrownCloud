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
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
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

/**返回值为非Json的GET方法*/
+ (void)nonJsonGet:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [YGHttpTool GET:url params:params success:^(id  _Nonnull responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(responseStr);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**返回值为非Json的POST方法*/
+ (void)nonJsonPOST:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [YGHttpTool POST:url params:params success:^(id  _Nonnull responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(responseStr);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/** download方法封装 */
+ (void)DOWNLOAD:(NSString *)url progress:(NSProgress *)progress destination:(NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *destURL;
        if (destination) {
            destURL = destination(targetPath, response);
        }
        return destURL;

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    
    [downloadTask resume];
}

/** upload方法封装 */
+ (void)UPLOAD:(NSString *)url progress:(NSProgress *)progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithRequest:request fromFile:fromFile progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionHandler(response, responseObject, error);
    }];
    
    [uploadTask resume];
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

+ (void)getToken:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:TOKEN_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)listLibrariesParams:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    [YGHttpTool GET:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createLibraryParams:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject){
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteLibrary:(NSString *)repoID success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool DELETE:urlStr params:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameLibrary:(NSString *)repoID parmas:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)listDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool GET:urlStr params:params success:^(id _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool DELETE:urlStr params:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)downloadDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIRDOWNLOAD_URI];
    [YGHttpTool GET:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)createFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool DELETE:urlStr params:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)moveFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)getDownloadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_URI];
    
    [YGHttpTool nonJsonGet:urlStr params:params success:^(id responseStr) {
        success(responseStr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)downloadFile:(NSString *)url progress:(NSProgress *)progress destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    [YGHttpTool DOWNLOAD:url progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *destURL = destination(targetPath, response);
        return destURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completionHandler(response, filePath, error);
    }];
}

+ (void)getUploadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:FILE_UPLOAD_URI];
    [YGHttpTool  nonJsonGet:urlStr params:params success:^(id responseStr) {
        success(responseStr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)uploadFileWithUrl:(NSString *)url progress:(NSProgress *)progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    [YGHttpTool UPLOAD:url progress:progress fromFile:fromFile completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionHandler(response, responseObject, error);
    }];
}
@end
