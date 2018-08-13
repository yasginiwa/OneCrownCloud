//
//  YGHeaderView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/13.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGHeaderView.h"
#import "YGSearchField.h"

@interface YGHeaderView ()
@property (nonatomic, weak) UIButton *addFolderBtn;
@property (nonatomic, weak) UIButton *orderBtn;
@property (nonatomic, weak) UITextField *searchField;
@property (nonatomic, weak) UIView *devider;
@end

@implementation YGHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *addFolderBtn = [UIButton buttonWithImage:@"file_newfolder" highImage:@"file_newfolder_pressed" target:self action:@selector(addFolder)];
        [self addSubview:addFolderBtn];
        self.addFolderBtn = addFolderBtn;
        
        UIButton *orderBtn = [UIButton buttonWithImage:@"nav_order" highImage:@"nav_order_pressed" target:self action:@selector(orderFolder)];
        [self addSubview:orderBtn];
        self.orderBtn = orderBtn;
        
        YGSearchField *searchField = [[YGSearchField alloc] init];
        searchField.returnKeyType = UIReturnKeySearch;
        [self addSubview:searchField];
        self.searchField = searchField;
        
        UIView *devider = [[UIView alloc] init];
        devider.backgroundColor = YGColorRGB(222, 222, 222);
        [self addSubview:devider];
        self.devider = devider;
    }
    return self;
}

- (void)addFolder
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickAddFolderBtn:)]) {
        [self.delegate headerViewDidClickAddFolderBtn:self];
    }
}

- (void)orderFolder
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickOrderBtn:)]) {
        [self.delegate headerViewDidClickOrderBtn:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.addFolderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addFolderBtn.mas_right).offset(20.0);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self);
    }];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderBtn.mas_right).offset(20.0);
        make.right.equalTo(self).offset(-10.0);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [self.devider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.7);
    }];
}
@end
