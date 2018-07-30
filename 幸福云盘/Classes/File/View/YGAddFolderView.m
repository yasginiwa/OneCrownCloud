//
//  YGAddFolderView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/30.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGAddFolderView.h"

@interface YGAddFolderView ()
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
        self.backgroundColor = [UIColor blackColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.0;
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
        inputField.backgroundColor = [UIColor lightGrayColor];
        inputField.borderStyle = UITextBorderStyleRoundedRect;
        inputField.text = @"新建文件夹";
        [self.bgView addSubview:inputField];
        self.inputField = inputField;
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.backgroundColor = [UIColor whiteColor];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:okBtn];
        self.okBtn = okBtn;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
    }
    return self;
}

- (void)okBtnClick:(UIButton *)okBtn
{
    if ([self.delegate respondsToSelector:@selector(addFolderViewDidClickOkBtn:)]) {
        [self.delegate addFolderViewDidClickOkBtn:self];
    }
}

- (void)cancelBtnClick:(UIButton *)cancelBtn
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
        make.height.equalTo(@170);
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
        make.width.equalTo(self.bgView).offset(-20.0);
        make.height.equalTo(@30);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.inputField.mas_bottom).offset(20.0);
        make.width.equalTo(self.bgView).multipliedBy(0.5);
        make.height.equalTo(@50);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.okBtn.mas_right);
        make.top.equalTo(self.okBtn);
        make.width.height.equalTo(self.okBtn);
    }];
}
@end
