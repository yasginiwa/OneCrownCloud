//
//  NSString+Extension.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
+ (NSString *)extensionWithFile:(NSString *)file;
+ (NSString *)stringWithSize:(NSNumber *)size;
@end
