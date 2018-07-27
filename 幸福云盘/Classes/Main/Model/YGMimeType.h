//
//  YGMimeType.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGMimeType : NSObject
/** 文件拓展名 */
@property (nonatomic, copy) NSString *mime;

/** 文件类型(视频、音频、文档) */
@property (nonatomic, copy) NSString *type;

/** 文件图标 */
@property (nonatomic, copy) NSString *icon;
@end
