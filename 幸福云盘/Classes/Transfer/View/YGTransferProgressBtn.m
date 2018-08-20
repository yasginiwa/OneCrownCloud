//
//  YGTransferProgressBtn.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTransferProgressBtn.h"

@interface YGProgressView : UIView
@property (nonatomic, assign) float progress;
@end

@implementation YGProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat radius = rect.size.width * 0.5 - 2.5;
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    
    CGContextAddArc(ctx, center.x, center.y, radius, -M_PI_2, self.progress * M_PI * 2 - M_PI_2, 0);
    
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    [[UIColor colorWithRed:36/255.0 green:140/255.0 blue:251/255.0 alpha:1.0] set];
    
    CGContextStrokePath(ctx);
}
@end



@interface YGTransferProgressBtn ()
@property (nonatomic, weak) YGProgressView *progressView;
@end

@implementation YGTransferProgressBtn
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        YGProgressView *progressView = [[YGProgressView alloc] init];
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    self.progressView.progress = progress;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.progressView.frame = self.bounds;
}
@end
