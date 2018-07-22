//
//  YGFileFirstCell.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileFirstCell.h"
#import "YGSearchField.h"

@interface YGFileFirstCell ()
@property (nonatomic, weak) UIButton *addFolderBtn;
@property (nonatomic, weak) UIButton *orderBtn;
@property (nonatomic, weak) UITextField *searchField;
@end

@implementation YGFileFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.separatorInset = UIEdgeInsetsZero;
        
        UIButton *addFolderBtn = [UIButton buttonWithImage:@"file_newfolder" highImage:@"file_newfolder_pressed" target:self action:@selector(addFolder)];
        [self.contentView addSubview:addFolderBtn];
        self.addFolderBtn = addFolderBtn;
        
        UIButton *orderBtn = [UIButton buttonWithImage:@"nav_order" highImage:@"nav_order_pressed" target:self action:@selector(orderFolder)];
        [self.contentView addSubview:orderBtn];
        self.orderBtn = orderBtn;
        
        YGSearchField *searchField = [[YGSearchField alloc] init];
        searchField.returnKeyType = UIReturnKeySearch;
        [self.contentView addSubview:searchField];
        self.searchField = searchField;
        
    }
    return self;
}

- (void)addFolder
{
    if ([self.delegate respondsToSelector:@selector(fileFirstCellDidClickAddFolderBtn:)]) {
        [self.delegate fileFirstCellDidClickAddFolderBtn:self];
    }
}

- (void)orderFolder
{
    if ([self.delegate respondsToSelector:@selector(fileFirstCellDidClickOrderBtn:)]) {
        [self.delegate fileFirstCellDidClickOrderBtn:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.addFolderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addFolderBtn.mas_right).offset(20.0);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderBtn.mas_right).offset(20.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];
    
    YGLog(@"%@", NSStringFromCGRect(self.searchField.leftView.frame));
}
@end
