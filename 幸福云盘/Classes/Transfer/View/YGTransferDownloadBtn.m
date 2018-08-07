//
//  YGTransferDownloadBtn.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/7.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGTransferDownloadBtn.h"

@interface YGProgressView : UIView
@property (nonatomic, assign) float progress;
@end

@implementation YGProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.progress = 0.0;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
    
    YGLog(@"%f", progress);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat radius = rect.size.width * 0.5 - 2.5;
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);

    CGContextAddArc(ctx, center.x, center.y, radius, 0, 2 * M_PI * self.progress, 1);

    CGContextSetLineWidth(ctx, 3.0);

    CGContextSetLineCap(ctx, kCGLineCapRound);

    [[UIColor colorWithRed:36/255.0 green:140/255.0 blue:251/255.0 alpha:1.0] set];

    CGContextStrokePath(ctx);
}
@end


@interface YGTransferDownloadBtn ()
@property (nonatomic, weak) YGProgressView *progressView;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YGTransferDownloadBtn

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        YGProgressView *progressView = [[YGProgressView alloc] init];
        [self addSubview:progressView];
        self.progressView = progressView;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(test) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    return self;
}

- (void)test
{
    if (self.progress <= 0) {
        self.progress += 0.1;
    }
    if (self.progress > 1.0) {
        self.progress = 0.0;
    }
    
    self.progressView.progress = self.progress;
    
    YGLog(@"%f", self.progress);
}

//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
//    if (controlEvents == UIControlEventTouchUpInside) {
//        [self setImage:[UIImage imageNamed:@"fav_pause_normal"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"fav_pause_pressed"] forState:UIControlStateHighlighted];
//    }
//
//    [super addTarget:target action:action forControlEvents:controlEvents];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.progressView.frame = self.bounds;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
@end
