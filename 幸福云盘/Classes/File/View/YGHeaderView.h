//
//  YGHeaderView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/13.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGHeaderView;

@protocol YGHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickAddFolderBtn:(YGHeaderView *)headerView;
- (void)headerViewDidClickOrderBtn:(YGHeaderView *)headerView;
@end

@interface YGHeaderView : UIView
@property (nonatomic, weak) id<YGHeaderViewDelegate> delegate;
@end
