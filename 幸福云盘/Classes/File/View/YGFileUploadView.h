//
//  YGFileUploadView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/1.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileUploadView;

@protocol YGFileUploadDelegate <NSObject>
@optional
- (void)fileUploadDidClickPicUploadBtn:(YGFileUploadView *)fileUploadView;
- (void)fileUploadDidClickVideoUploadBtn:(YGFileUploadView *)fileUploadView;
@end

@interface YGFileUploadView : UIToolbar
@property (nonatomic, weak) id<YGFileUploadDelegate> uploadDelegate;
- (void)popUpButtons;
- (void)dismiss;
@end
