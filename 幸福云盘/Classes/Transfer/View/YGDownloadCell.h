//
//  YGDownloadCell.h
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel;

@interface YGDownloadCell : UITableViewCell
@property (nonatomic, strong) YGFileModel *downloadFileModel;
+(instancetype)downloadCell;
@end
