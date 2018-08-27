//
//  YGFileTransferTool.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/24.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFileModel;

@interface YGFileTransferTool : NSObject
+ (NSMutableArray *)downloadFiles;
+ (void)saveDownloadFiles:(NSMutableArray *)downloadFiles;
+ (NSMutableArray *)uploadFiles;
+ (void)saveUploadFiles:(NSMutableArray *)uploadFiles;
@end
