//
//  YGAddFolderView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/30.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGAddFolderView;

@protocol YGAddFolderViewDelegate <NSObject>
- (void)addFolderViewDidClickOkBtn:(YGAddFolderView *)addFolderView;
- (void)addFolderViewDidClickCancelBtn:(YGAddFolderView *)addFolderView;
@end

@interface YGAddFolderView : UIView
@property (nonatomic, weak) id<YGAddFolderViewDelegate> delegate;
@end
