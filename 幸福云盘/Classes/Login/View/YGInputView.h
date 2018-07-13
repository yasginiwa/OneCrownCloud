//
//  YGInputView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YGInputView : UIView
@property (nonatomic, assign, getter=inputIsEditing) BOOL inputEditing;
@property (nonatomic, weak) UITextField *inputField;
- (instancetype)initWithPlaceHolder:(NSString *)placeholder title:(NSString *)title security:(BOOL)security;
@end
