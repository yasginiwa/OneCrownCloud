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
NSString *const BASE_URL = @"http://www.crowncake.cn:50080";

/** v2API_URL */
NSString *const API_URL = @"/api2";

/** POST请求token的URL */
NSString *const TOKEN_URL = @"/auth-token/";

/** GET请求站好信息URL 后面要加上请求账号的email*/
NSString *const ACCOUNT_URL = @"/account/";

/** GET请求check账号信息的URL */
NSString *const CHECK_ACCOUNT_URL = @"/account/info/";

/** GET List Libraries */
NSString *const LIST_LIBARIES_URL = @"/repos/";
@end
