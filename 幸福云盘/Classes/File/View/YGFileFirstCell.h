//
//  YGFileFirstCell.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileFirstCell;

@protocol YGFileFirstCellDelegate <NSObject>
@optional
- (void)fileFirstCellDidClickAddFolderBtn:(YGFileFirstCell *)cell;
- (void)fileFirstCellDidClickOrderBtn:(YGFileFirstCell *)cell;
@end

@interface YGFileFirstCell : UITableViewCell
@property (nonatomic, weak) id<YGFileFirstCellDelegate> delegate;
@end
