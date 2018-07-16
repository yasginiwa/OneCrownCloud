//
//  YGAccountTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/15.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGAccount.h"

@interface YGAccountTool : NSObject
+ (void)saveAccount:(YGAccount *)account;
+ (void)clearAccount;
+ (void)getTokenWithConnection:(SeafConnection *)connection success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
