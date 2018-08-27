//
//  YGFileTransferTool.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/24.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileTransferTool.h"

@implementation YGFileTransferTool
+ (NSMutableArray *)downloadFiles
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YGDownloadFilesPath];
}

+ (void)saveDownloadFiles:(NSMutableArray *)downloadFiles
{
    [NSKeyedArchiver archiveRootObject:downloadFiles toFile:YGDownloadFilesPath];
}

+ (NSMutableArray *)uploadFiles
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YGUploadFilesPath];
}

+ (void)saveUploadFiles:(NSMutableArray *)uploadFiles
{
    [NSKeyedArchiver archiveRootObject:uploadFiles toFile:YGUploadFilesPath];
}
@end
