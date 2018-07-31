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
#import "YGDirTool.h"

@implementation YGHttpTool

/** GET请求方法封装 */
+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 3.0;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** POST请求方法封装 */
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}

/**返回值为非Json的GET方法*/
+ (void)nonJsonGet:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        success(responseStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**返回值为非Json的POST方法*/
+ (void)nonJsonPOST:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        success(responseStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** download方法封装 */
+ (void)DOWNLOAD:(NSString *)url progress:(void (^)(NSProgress *downloadProgress))progress destination:(NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionDownloadTask *downloadTask = [mgr downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
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
+ (void)UPLOAD:(NSString *)url progress:(void (^)(NSProgress *uploadProgress))progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionHandler(response, responseObject, error);
    }];

    [uploadTask resume];
}

/** DELETE方法封装 */
+ (void)DELETE:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    [mgr DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/** PUT方法封装 */
+ (void)PUT:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    YGApiToken *token = [YGApiTokenTool apiToken];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token.token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8; indent=4" forHTTPHeaderField:@"Accept"];
    
    [mgr PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    [YGHttpTool POST:urlStr params:params success:^(id  _Nonnull responseObject){
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)deleteLibrary:(NSString *)repoID success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [NSString stringWithFormat:@"%@%@", urlStr, repoID];
    NSDictionary *params = nil;
    [YGHttpTool DELETE:urlStr params:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)renameLibrary:(NSString *)repoID parmas:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    urlStr = [NSString stringWithFormat:@"%@%@", urlStr, repoID];
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

+ (void)createDirectoryWithRepoID:(NSString *)repoID dir:(NSString *)dir params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure
{
    
    NSString *urlStr = [BASE_URL stringByAppendingString:REPO_URI];
    NSString *currentDir = [[YGDirTool dir] substringFromIndex:1];
    urlStr = [[[[NSString stringWithFormat:@"%@%@", urlStr, repoID] stringByAppendingString:DIR_URI] stringByAppendingString:[NSString stringWithFormat:@"?p=/%@%@", currentDir, dir]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YGHttpTool nonJsonPOST:urlStr params:params success:^(id  _Nonnull responseStr) {
        success(responseStr);
    } failure:^(NSError * error) {
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

+ (void)downloadFile:(NSString *)url progress:(void (^)(NSProgress *downloadProgress))progress destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    [YGHttpTool DOWNLOAD:url progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *destURL = destination(targetPath, response);
        return destURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
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

+ (void)uploadFileWithUrl:(NSString *)url progress:(void (^)(NSProgress *uploadProgress))progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    [YGHttpTool UPLOAD:url progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } fromFile:fromFile completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
        completionHandler(response, responseObject, error);
    }];
}
@end
