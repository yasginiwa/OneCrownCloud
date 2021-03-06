//
//  YGInputView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/12.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGInputView.h"


@interface YGInputView ()<UITextFieldDelegate>
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, weak) UIView *editingLine;
@end

@implementation YGInputView
- (instancetype)initWithPlaceHolder:(NSString *)placeholder title:(NSString *)title security:(BOOL)security
{
    if (self = [super init]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.hidden = YES;
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UITextField *inputField = [[UITextField alloc] init];
        inputField.delegate = self;
        inputField.placeholder = placeholder;
        inputField.secureTextEntry = security;
        inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:inputField];
        self.inputField = inputField;
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@14);
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.inputField);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.titleLabel.hidden = NO;
    self.inputEditing = YES;
    [self drawEditingLine];
    [[NSNotificationCenter defaultCenter] postNotificationName:YGLoginDidBeginEditNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.titleLabel.hidden = YES;
    self.inputEditing = NO;
    [self drawEditingLine];
}

// 编辑时底部画黑线
- (void)drawEditingLine
{
    [self.editingLine removeFromSuperview];
    UIView *editingLine = [[UIView alloc] init];
    editingLine.backgroundColor = [UIColor blackColor];
    [self addSubview:editingLine];
    editingLine.x = 0;
    editingLine.y = self.bottomLine.y;
    editingLine.height = self.bottomLine.height;
    self.editingLine = editingLine;
    if (self.inputIsEditing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.editingLine.width = self.bottomLine.width;
        }];
    } else {
        [self.editingLine removeFromSuperview];
    }
}
@end
