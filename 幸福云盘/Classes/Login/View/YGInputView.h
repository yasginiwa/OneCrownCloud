//
//  YGInputView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGInputView;

@protocol YGInputViewDelegate <NSObject>
@optional
- (void)inputViewDidEndEditing:(YGInputView *)inputView;
@end

@interface YGInputView : UIView
@property (nonatomic, weak) id<YGInputViewDelegate> delegate;
@property (nonatomic, assign, getter=isSecurity)BOOL security;
@property (nonatomic, assign, getter=inputIsEditing) BOOL inputEditing;
- (instancetype)initWithPlaceHolder:(NSString *)placeholder title:(NSString *)title;
@end
