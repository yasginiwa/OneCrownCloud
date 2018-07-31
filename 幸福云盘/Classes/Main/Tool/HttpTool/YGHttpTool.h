//
//  YGHttpTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/16.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGApiToken, SeafConnection;

NS_ASSUME_NONNULL_BEGIN

@interface YGHttpTool : NSObject
/** GET请求方法封装 */
+ (void)GET:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** POST请求方法封装 */
+ (void)POST:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**返回值为非Json的GET方法*/
+ (void)nonJsonGet:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure;

/**返回值为非Json的POST方法*/
+ (void)nonJsonPOST:(NSString *)url params:(id)params success:(void (^)(id responseStr))success failure:(void (^)(NSError *))failure;

/** download方法封装 */
+ (void)DOWNLOAD:(NSString *)url progress:(void (^)(NSProgress *downloadProgress))progress destination:(NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/** upload方法封装 */
+ (void)UPLOAD:(NSString *)url progress:(void (^)(NSProgress *progress))progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

/** DELETE方法封装 */
+ (void)DELETE:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** PUT方法封装 */
+ (void)PUT:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** Obtain Token */
+ (void)getToken:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** List Libraries */
+ (void)listLibrariesParams:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Create Libraries */
+ (void)createLibraryParams:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Delete Libraries */
+ (void)deleteLibrary:(NSString *)repoID success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Rename Libraries */
+ (void)renameLibrary:(NSString *)repoID parmas:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** List Directory dirName如是中文必须添加%*/
+ (void)listDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Create Directory */
+ (void)createDirectoryWithRepoID:(NSString *)repoID dir:(NSString *)dir params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Delete Directory */
+ (void)deleteDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Rename Directory */
+ (void)renameDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Download Directory */
+ (void)downloadDirectoryWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Create File */
+ (void)createFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Delete File */
+ (void)deleteFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Rename File */
+ (void)renameFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Move File */
+ (void)moveFileWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id _Nonnull responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;

/** Get Download Link */
+ (void)getDownloadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/** Download File */
+ (void)downloadFile:(NSString *)url progress:(void (^)(NSProgress *downloadProgress))progress destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/** Get Upload Link*/
+ (void)getUploadUrlWithRepoID:(NSString *)repoID params:(id)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** Upload File */
+ (void)uploadFileWithUrl:(NSString *)url progress:(void (^)(NSProgress *uploadProgress))progress fromFile:(NSURL *)fromFile completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

NS_ASSUME_NONNULL_END
@end
