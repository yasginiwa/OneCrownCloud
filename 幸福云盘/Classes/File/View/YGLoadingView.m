//
//  YGLoadingView.m
//  皇冠幸福里
//
//  Created by LiYugang on 2018/4/25.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import "YGLoadingView.h"
#import "YGActivityIndicator.h"

@interface YGLoadingView ()
@property (nonatomic, weak) UIImageView *logoView;
@property (nonatomic, weak) YGActivityIndicator *waitingIndicator;
@end


@implementation YGLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBg"]];
        [self addSubview:logoView];
        self.logoView = logoView;
        
        YGActivityIndicator *waitingIndicator = [[YGActivityIndicator alloc] init];
        [waitingIndicator startAnimating];
        [self addSubview:waitingIndicator];
        self.waitingIndicator = waitingIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 8;
    CGFloat delta = 80;
    
    self.logoView.x = scrnW * 0.6 - self.logoView.width;
    self.logoView.centerY = scrnH * 0.5 - delta;
    
    self.waitingIndicator.x = CGRectGetMaxX(self.logoView.frame) + padding;
    self.waitingIndicator.centerY = scrnH * 0.5 - delta - 15;
    self.waitingIndicator.width = 30;
    self.waitingIndicator.height = 30;
}

@end
