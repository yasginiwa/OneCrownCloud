//
//  YGTransferProgressView.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTransferProgressView.h"

@implementation YGTransferProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.percent = 0.0;
        self.width = 0.0;
    }
    return self;
}

- (void)setPercent:(float)percent
{
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self addArcBackColor];
    
}

- (void)addArcBackColor
{
    CGColorRef color = (self.arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : self.arcBackColor.CGColor;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize size = self.bounds.size;
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    //  Draw the slices
    CGFloat radius = size.width * 0.5;
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddArc(ctx, center.x, center.y, radius, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(ctx, color);
    CGContextFillPath(ctx);
}
@end
