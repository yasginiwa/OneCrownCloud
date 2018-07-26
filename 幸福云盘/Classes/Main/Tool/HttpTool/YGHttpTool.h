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
+ (void)GET:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
+ (void)POST:(NSString *)url apiToken:(YGApiToken *)apiToken params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** GET POST方法 已包含token 无需传入 */
+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** List Libraries */
+ (void)listLibrariesParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Create Library */
+ (void)createLibraryParams:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/** Delete Library */
+ (void)deleteLibrarySuccess:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/** Rename Library */
+ (void)renameLibraryParmas:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/** List Directory Entries */
+ (void)listDirectorySuccess:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Create New Directory */
+ (void)createDirectoryParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Delete Directory */
+ (void)deleteDirectoryParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Rename Directory */
+ (void)renameDirectoryParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Create File */
+ (void)createFileParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Delete File */
+ (void)deleteFileParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Rename File */
+ (void)renameFileParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Move File */
+ (void)moveFileParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Upload File */
+ (void)uploadFileParams:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** 获得文件下载链接 */
+ (void)getDownloadUrlWithRepoID:(NSString *)repoID params:(id)params  success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/** downloadFile */
+ (void)downloadFile:(NSString *)url finishProgress:(void (^)(NSProgress *progress))finishProgress completion:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completion;
@end
