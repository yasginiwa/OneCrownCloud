//
//  YGMenuView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/5.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGMenuView.h"
#import "YGTransferListBtn.h"

#define titleFont [UIFont systemFontOfSize:14]

@interface YGMenuView ()
@property (nonatomic, weak) YGTransferListBtn *downloadListBtn;
@property (nonatomic, weak) YGTransferListBtn *uploadListBtn;
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation YGMenuView

#pragma mark - 懒加载
- (UIView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor colorWithRed:36/255.0 green:140/255.0 blue:251/255.0 alpha:1.0];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        YGTransferListBtn *downloadListBtn = [[YGTransferListBtn alloc] initWithTitle:@"下载列表"];
        downloadListBtn.titleLabel.font = titleFont;
        [downloadListBtn addTarget:self action:@selector(clickDownloadBtn) forControlEvents:UIControlEventTouchDown];
        [self addSubview:downloadListBtn];
        self.downloadListBtn = downloadListBtn;
        [self addSubview:downloadListBtn];
        
        YGTransferListBtn *uploadListBtn = [[YGTransferListBtn alloc] initWithTitle:@"上传列表"];
        uploadListBtn.titleLabel.font = titleFont;
        [uploadListBtn addTarget:self action:@selector(clickUploadBtn) forControlEvents:UIControlEventTouchDown];
        [self addSubview:uploadListBtn];
        self.uploadListBtn = uploadListBtn;
        [self addSubview:uploadListBtn];
        
        [downloadListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.mas_equalTo(scrnW * 0.5);
            make.height.equalTo(self);
        }];
        
        [uploadListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.width.mas_equalTo(scrnW * 0.5);
            make.height.equalTo(self);
        }];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [self clickDownloadBtn];
}

- (void)setIndicatorPosition:(UIButton *)button font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGFloat titleWidth = [self.uploadListBtn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(button);
        make.width.mas_equalTo(titleWidth);
        make.height.equalTo(@2);
    }];
}

- (void)downloadAddTarget:(id)target action:(SEL)action
{
    [self clickDownloadBtn];
    
    [self.downloadListBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)uploadAddTarget:(id)target action:(SEL)action
{
    [self clickUploadBtn];
    
    [self.uploadListBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)clickDownloadBtn
{
    self.downloadListBtn.selected = YES;
    self.uploadListBtn.selected = NO;
    [self setIndicatorPosition:self.downloadListBtn font:titleFont];
}

- (void)clickUploadBtn
{
    self.uploadListBtn.selected = YES;
    self.downloadListBtn.selected = NO;
    [self setIndicatorPosition:self.uploadListBtn font:titleFont];
}
@end
