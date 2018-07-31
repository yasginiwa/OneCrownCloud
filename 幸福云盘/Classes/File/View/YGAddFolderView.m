//
//  YGAddFolderView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/30.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGAddFolderView.h"

@interface YGAddFolderBtn : UIButton

@end

@implementation YGAddFolderBtn
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] set];
    CGContextStrokePath(ctx);
}

@end


@interface YGAddFolderView () <UITextFieldDelegate>
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITextField *inputField;
@property (nonatomic, weak) UIButton *okBtn;
@property (nonatomic, weak) UIButton *cancelBtn;
@end

@implementation YGAddFolderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YGColorRGBA(0, 0, 0, 0.3);
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 8.0;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"新建文件夹";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UITextField *inputField = [[UITextField alloc] init];
        inputField.backgroundColor = YGColorRGB(247, 247, 247);
        inputField.borderStyle = UITextBorderStyleRoundedRect;
        inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputField.text = @"新建文件夹";
        [inputField becomeFirstResponder];
        [inputField performSelector:@selector(selectAll:) withObject:nil afterDelay:0.0];
        [self.bgView addSubview:inputField];
        self.inputField = inputField;
        
        YGAddFolderBtn *okBtn = [YGAddFolderBtn buttonWithType:UIButtonTypeCustom];
        okBtn.backgroundColor = [UIColor whiteColor];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:okBtn];
        self.okBtn = okBtn;
        
        YGAddFolderBtn *cancelBtn = [YGAddFolderBtn buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
    }
    return self;
}

- (void)okBtnClick:(YGAddFolderBtn *)okBtn
{
    if ([self.delegate respondsToSelector:@selector(addFolderViewDidClickOkBtn:)]) {
        [self.delegate addFolderViewDidClickOkBtn:self];
    }
}

- (void)cancelBtnClick:(YGAddFolderBtn *)cancelBtn
{
    if ([self.delegate respondsToSelector:@selector(addFolderViewDidClickCancelBtn:)]) {
        [self.delegate addFolderViewDidClickCancelBtn:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.8);
        make.width.equalTo(@240);
        make.height.equalTo(@150);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(20.0);
        make.width.equalTo(self.bgView);
        make.height.equalTo(@15);
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20.0);
        make.width.equalTo(self.bgView).offset(-40.0);
        make.height.equalTo(@30);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(-1.0);
        make.top.equalTo(self.inputField.mas_bottom).offset(20.0);
        make.width.equalTo(@121);
        make.height.equalTo(@50);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBtn.mas_right);
        make.top.equalTo(self.cancelBtn);
        make.width.equalTo(self.cancelBtn);
        make.height.equalTo(self.cancelBtn);
    }];
}
@end
