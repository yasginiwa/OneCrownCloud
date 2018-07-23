//
//  YGURLString.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/13.
//  Copyright © 2018年 YGLEE. All rights reserved.
//
//  https://manual.seafile.com/develop/web_api.html#seafile-web-api-v2

#import <Foundation/Foundation.h>

@interface YGURLString : NSObject
/** BaseURL */
UIKIT_EXTERN NSString *const BASE_URL;

/** v2API_URL */
UIKIT_EXTERN NSString *const API_URL;

/** POST请求token的URL */
UIKIT_EXTERN NSString *const TOKEN_URL;

/** GET请求站好信息URL 后面要加上请求账号的email*/
UIKIT_EXTERN NSString *const ACCOUNT_URL;

/** GET请求check账号信息的URL */
UIKIT_EXTERN NSString *const CHECK_ACCOUNT_URL;

/** GET List Libraries */
UIKIT_EXTERN NSString *const LIST_LIBARIES_URL;

/** GET 下载文件 https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo */
@end
