//
//  YGTransferListBtn.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/5.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTransferListBtn.h"

@implementation YGTransferListBtn

- (instancetype)initWithTitle:(NSString *)title
{
    YGTransferListBtn *listBtn = [YGTransferListBtn buttonWithType:UIButtonTypeCustom];
    [listBtn setTitle:title forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:140/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateSelected];
    return listBtn;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
