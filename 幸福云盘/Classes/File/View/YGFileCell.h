//
//  YGFileCell.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/17.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel, YGFileCell;

@protocol YGFileCellDelegate <NSObject>
@optional
- (void)fileCell:(YGFileCell *)fileCell didSelectCheckBtn:(UIButton *)checkBtn fileModel:(YGFileModel *)fileModel;
@end

@interface YGFileCell : UITableViewCell
@property (nonatomic, weak) id<YGFileCellDelegate> delegate;
@property (nonatomic, strong) YGFileModel *fileModel;
+ (instancetype)fileCell;

@end
