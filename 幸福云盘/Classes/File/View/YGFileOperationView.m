//
//  YGFileOperationView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/7.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileOperationView.h"

@interface YGFileOperationBtn : UIButton

@end

@implementation YGFileOperationBtn

typedef enum {
    YGFileOperationTypeDownload,
    YGFileOperationTypeCopy,
    YGFileOperationTypeMove,
    YGFileOperationTypeRename,
    YGFileOperationTypeDelete
} YGFileOperationType;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 35;
    CGFloat imageH = 35;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 0;

    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * 0.3;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

@implementation YGFileOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YGColorRGB(28, 28, 28);
        
        [self addButtonsWithTitle:@"下载" image:@"prevrew_down_normal" highImage:@"prevrew_down_pressed" operationType:YGFileOperationTypeDownload];
        [self addButtonsWithTitle:@"复制" image:@"prevrew_copy_normal" highImage:@"prevrew_copy_pressed" operationType:YGFileOperationTypeCopy];
        [self addButtonsWithTitle:@"移动" image:@"prevrew_move_normal" highImage:@"prevrew_move_pressed" operationType:YGFileOperationTypeMove];
        [self addButtonsWithTitle:@"重命名" image:@"prevrew_rename_normal" highImage:@"prevrew_rename_pressed" operationType:YGFileOperationTypeRename];
        [self addButtonsWithTitle:@"删除" image:@"prevrew_delete_normal" highImage:@"prevrew_delete_pressed" operationType:YGFileOperationTypeDelete];
    }
    return self;
}

- (void)addButtonsWithTitle:(NSString *)title image:(NSString *)image highImage:(NSString *)highImage operationType:(YGFileOperationType)operationType
{
    YGFileOperationBtn *btn = [YGFileOperationBtn buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.tag = operationType;
    [btn addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
}

- (void)operationClick:(YGFileOperationBtn *)button
{
    switch (button.tag) {
        case YGFileOperationTypeDownload:
            if ([self.delegate respondsToSelector:@selector(fileOperationViewDidClickDownloadBtn:)]) {
                [self.delegate fileOperationViewDidClickDownloadBtn:self];
            }
            break;
        case YGFileOperationTypeCopy:
            if ([self.delegate respondsToSelector:@selector(fileOperationViewDidClickCopyBtn:)]) {
                [self.delegate fileOperationViewDidClickCopyBtn:self];
            }
            break;
        case YGFileOperationTypeMove:
            if ([self.delegate respondsToSelector:@selector(fileOperationViewDidClickMoveBtn:)]) {
                [self.delegate fileOperationViewDidClickMoveBtn:self];
            }
            break;
        case YGFileOperationTypeRename:
            if ([self.delegate respondsToSelector:@selector(fileOperationViewDidClickRenameBtn:)]) {
                [self.delegate fileOperationViewDidClickRenameBtn:self];
            }
            break;
        case YGFileOperationTypeDelete:
            if ([self.delegate respondsToSelector:@selector(fileOperationViewDidClickDeleteBtn:)]) {
                [self.delegate fileOperationViewDidClickDeleteBtn:self];
            }
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    
    for (int i = 0; i < count; i++) {
        YGFileOperationBtn *btn = self.subviews[i];
        CGFloat btnX = btnW * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}
@end
