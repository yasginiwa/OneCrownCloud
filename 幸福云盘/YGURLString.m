//
//  YGURLString.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/13.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGURLString.h"

@implementation YGURLString
/** BaseURL */
NSString *const BASE_URL = @"http://www.crowncake.cn:50080/api2";

/** POST请求token的URI */
NSString *const TOKEN_URI = @"/auth-token/";

/** GET请求站好信息URL 后面要加上请求账号的email*/
NSString *const ACCOUNT_URI = @"/account/";

/** GET请求check账号信息的URL */
NSString *const CHECK_ACCOUNT_URI = @"/account/info/";

/** repo_URI*/
NSString *const REPO_URI = @"/repos/";

/** dir_URI */
NSString *const DIR_URI = @"/dir/";

/** file_URI */
NSString *const FILE_URI = @"/file/";

@end
