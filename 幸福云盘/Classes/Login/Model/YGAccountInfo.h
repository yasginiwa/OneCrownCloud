//
//  YGAccountInfo.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/15.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGAccountInfo : NSObject
/** 是否是shibboleth */
@property (nonatomic, assign) BOOL isshibboleth;
/** 请求的连接 */
@property (nonatomic, copy) NSString *link;
/** 请求成功的用户名 */
@property (nonatomic, copy) NSString *username;
/** 请求成功的密码 */
@property (nonatomic, copy) NSString *password;
/** 请求成功后获得的token */
@property (nonatomic, copy) NSString *token;
@end
