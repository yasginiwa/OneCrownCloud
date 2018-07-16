//
//  YGAccount.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/14.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGAccount : NSObject
/** 联系邮箱 */
@property (nonatomic, copy) NSString *contact_email;

/** 用户部门 */
@property (nonatomic, copy) NSString *department;

/** 登录邮箱 */
@property (nonatomic, copy) NSString *email;

/** 所属机构 */
@property (nonatomic, copy) NSString *institution;

/** 登录id */
@property (nonatomic, copy) NSString *login_id;

/** 用户角色 */
@property (nonatomic, copy) NSString *name;

/** 用户网盘配额 */
@property (nonatomic, strong) NSNumber *total;

/** 用户已使用配额 单位是byte */
@property (nonatomic, strong) NSNumber *usage;
@end
