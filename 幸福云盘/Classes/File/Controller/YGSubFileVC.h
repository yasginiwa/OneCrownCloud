//
//  YGSubFileVC.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/20.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileBaseVC.h"

@class YGFileModel;

@interface YGSubFileVC : YGFileBaseVC
@property (nonatomic, copy) void (^uploadProgress)(double progress);
@end
