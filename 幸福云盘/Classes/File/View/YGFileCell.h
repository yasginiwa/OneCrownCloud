//
//  YGFileCell.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel;

@interface YGFileCell : UITableViewCell
@property (nonatomic, strong) YGFileModel *fileModel;
+ (instancetype)fileCell;

@end
