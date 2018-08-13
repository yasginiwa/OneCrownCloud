//
//  YGFileOperationView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/7.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileOperationView;

@protocol YGFileOperationViewDelegate <NSObject>
@optional
- (void)fileOperationViewDidClickDownloadBtn:(YGFileOperationView *)headerView;
- (void)fileOperationViewDidClickCopyBtn:(YGFileOperationView *)headerView;
- (void)fileOperationViewDidClickMoveBtn:(YGFileOperationView *)headerView;
- (void)fileOperationViewDidClickRenameBtn:(YGFileOperationView *)headerView;
- (void)fileOperationViewDidClickDeleteBtn:(YGFileOperationView *)headerView;
@end

@interface YGFileOperationView : UIView
@property (nonatomic, weak) id<YGFileOperationViewDelegate> delegate;
@end
