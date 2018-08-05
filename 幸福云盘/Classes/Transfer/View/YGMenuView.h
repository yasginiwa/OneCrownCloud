//
//  YGMenuView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/5.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGMenuView;

@protocol YGMenuViewDelegate <NSObject>
@optional
- (void)menuViewDidClickDownloadListBtn:(YGMenuView *)menuView;
- (void)menuViewDidClickUploadListBtn:(YGMenuView *)menuView;
@end

@interface YGMenuView : UIView
@property (nonatomic, weak) id<YGMenuViewDelegate> delegate;
@end
