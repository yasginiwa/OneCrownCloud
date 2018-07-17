//
//  YGFileModel.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGFileModel : NSObject

/**
 encrypted = 0;
 "head_commit_id" = d45872e8163dcf76e51548e2c6607ea8c0c4946c;
 id = "2e6e74e8-9a17-40ff-b1d3-e4c9751210ce";
 "modifier_contact_email" = "admin@seafile.local";
 "modifier_email" = "admin@seafile.local";
 "modifier_name" = admin;
 mtime = 1531282503;
 "mtime_relative" = "<time datetime=\"2018-07-11T12:15:03\" is=\"relative-time\" title=\"Wed, 11 Jul 2018 12:15:03 +0800\" >5 \U5929\U524d</time>";
 name = "\U89c6\U9891";
 owner = "admin@seafile.local";
 permission = rw;
 root = "";
 size = 0;
 "size_formatted" = "0\U00a0bytes";
 type = repo;
 version = 1;
 virtual = 0;
 */

typedef enum {
    r,
    w,
    e,
    rw,
} YGPermissionType;

typedef enum {
    repo,
    dir,
    file,
    uploadfile
} YGFileType;

@property (nonatomic, assign) BOOL encrypted;

@property (nonatomic, copy) NSString *head_commit_id;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *modifier_contact_email;

@property (nonatomic, copy) NSString *modifier_email;

@property (nonatomic, copy) NSString *modifier_name;

@property (nonatomic, copy) NSString *mtime;

@property (nonatomic, copy) NSString *mtime_relative;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *owner;

@property (nonatomic, assign) YGPermissionType permission;

@property (nonatomic, copy) NSString *root;

@property (nonatomic, assign) NSUInteger size;

@property (nonatomic, copy) NSString *size_formatted;

@property (nonatomic, assign) YGFileType type;

@property (nonatomic, assign) NSInteger version;

@property (nonatomic, assign) BOOL VIRTUAL;

@end
