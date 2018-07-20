//
//  YGSearchField.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/20.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGSearchField.h"

@implementation YGSearchField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file_search_icon"]];
        self.leftView = leftImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.layer.cornerRadius = 8.0;
        self.clipsToBounds = YES;
        
        self.backgroundColor = YGColorRGB(247, 247, 247);
        self.borderStyle = UITextBorderStyleNone;
        
        self.font = [UIFont systemFontOfSize:13];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 37, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 37, 0);
}

@end
