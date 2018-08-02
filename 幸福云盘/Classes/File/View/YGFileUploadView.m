//
//  YGFileUploadView.m
//  幸福云盘
//
//  Created by YGLEE on 2018/8/1.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileUploadView.h"

@interface YGFileUploadView ()
@property (nonatomic, weak) UIButton *picUploadBtn;
@property (nonatomic, weak) UILabel *picUploadLabel;
@property (nonatomic, weak) UIButton *videoUploadBtn;
@property (nonatomic, weak) UILabel *videoUploadLabel;
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation YGFileUploadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //  初始化自己外观
        self.backgroundColor = [UIColor whiteColor];
        
        //  添加图片上传按钮
        UIButton *picUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picUploadBtn setImage:[UIImage imageNamed:@"file_upload_pic"] forState:UIControlStateNormal];
        [picUploadBtn addTarget:self action:@selector(picUploadClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:picUploadBtn];
        self.picUploadBtn = picUploadBtn;
        
        //  添加图片上传标签
        UILabel *picUploadLabel = [[UILabel alloc] init];
        picUploadLabel.text = @"上传图片";
        picUploadLabel.textAlignment = NSTextAlignmentCenter;
        picUploadLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:picUploadLabel];
        self.picUploadLabel = picUploadLabel;
        
        //  添加视频上传按钮
        UIButton *videoUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoUploadBtn setImage:[UIImage imageNamed:@"file_upload_video"] forState:UIControlStateNormal];
        [videoUploadBtn addTarget:self action:@selector(videoUploadClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:videoUploadBtn];
        self.videoUploadBtn = videoUploadBtn;
        
        //  添加视频上传标签
        UILabel *videoUploadLabel = [[UILabel alloc] init];
        videoUploadLabel.text = @"上传视频";
        videoUploadLabel.textAlignment = NSTextAlignmentCenter;
        videoUploadLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:videoUploadLabel];
        self.videoUploadLabel = videoUploadLabel;
        
        //  添加关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"file_upload_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        self.closeBtn = closeBtn;
        
        [self.picUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.height.width.equalTo(@123);
        }];
        
        [self.picUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.picUploadBtn.mas_bottom).offset(-10);
            make.width.equalTo(self);
            make.height.equalTo(@14);
        }];

        [self.videoUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.picUploadLabel.mas_bottom).offset(60);
            make.width.height.equalTo(@123);
        }];

        [self.videoUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.videoUploadBtn.mas_bottom).offset(-10);
            make.width.equalTo(self);
            make.height.equalTo(@14);
        }];

        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.videoUploadLabel.mas_bottom).offset(100);
            make.height.width.equalTo(@30);
        }];
    }
    return self;
}

- (void)popUpButtons
{
    [self.picUploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.8);
        make.height.width.equalTo(@123);
    }];
    
    [self setNeedsUpdateConstraints];
    
    [self updateConstraints];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self getDownButtons];
    }];
}

- (void)getDownButtons
{
    [self.picUploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.8).offset(20);
        make.height.width.equalTo(@123);
    }];
    
    [self setNeedsUpdateConstraints];
    
    [self updateConstraints];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.picUploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.width.equalTo(@123);
    }];
    
    [self setNeedsUpdateConstraints];
    
    [self updateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [super touchesBegan:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.closeBtn.hidden == NO) {
        CGPoint newPoint = [self convertPoint:point toView:self.closeBtn];
        if ([self.closeBtn pointInside:newPoint withEvent:event]) {
            return self.closeBtn;
        }
    }
    
    if (self.picUploadBtn.hidden == NO) {
        CGPoint newPoint = [self convertPoint:point toView:self.picUploadBtn];
        if ([self.picUploadBtn pointInside:newPoint withEvent:event]) {
            return self.picUploadBtn;
        }
    }
    
    if (self.videoUploadBtn.hidden == NO) {
        CGPoint newPoint = [self convertPoint:point toView:self.videoUploadBtn];
        if ([self.videoUploadBtn pointInside:newPoint withEvent:event]) {
            return self.videoUploadBtn;
        }
    }
    return self;
}

- (void)picUploadClick
{
    if ([self.uploadDelegate respondsToSelector:@selector(fileUploadDidClickPicUploadBtn:)]) {
        [self.uploadDelegate fileUploadDidClickPicUploadBtn:self];
    }
}

- (void)videoUploadClick
{
    if ([self.uploadDelegate respondsToSelector:@selector(fileUploadDidClickVideoUploadBtn:)]) {
        [self.uploadDelegate fileUploadDidClickVideoUploadBtn:self];
    }
}

- (void)dismiss
{
    [self.picUploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.width.equalTo(@123);
    }];
    
    [self setNeedsUpdateConstraints];
    
    [self updateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
