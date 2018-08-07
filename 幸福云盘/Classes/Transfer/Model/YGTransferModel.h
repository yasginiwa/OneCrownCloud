//
//  YGTransferModel.h
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFileModel;

@interface YGTransferModel : NSObject
@property (nonatomic, strong) YGFileModel *fileModel;
@property (nonatomic, copy) NSString *downloadTime;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end
