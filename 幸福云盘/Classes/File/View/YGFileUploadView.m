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
@property (nonatomic, assign, getter=isOnBottom) BOOL onBottom;
@end

@implementation YGFileUploadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //  初始化自己外观
        self.backgroundColor = [UIColor whiteColor];
        self.onBottom = NO;
        
        //  添加图片上传按钮
        UIButton *picUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picUploadBtn setImage:[UIImage imageNamed:@"file_upload_pic"] forState:UIControlStateNormal];
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
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        self.closeBtn = closeBtn;
        
        self.onBottom = NO;
        
//        [self.picUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.picUploadBtn);
//            make.top.equalTo(self.picUploadBtn.mas_bottom);
//            make.width.equalTo(@(scrnW));
//            make.height.equalTo(@14);
//        }];
//
//        [self.videoUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.picUploadBtn);
//            make.top.equalTo(self.picUploadBtn.mas_bottom).offset(60.0);
//            make.height.width.equalTo(self.picUploadBtn);
//        }];
//
//        [self.videoUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.picUploadBtn);
//            make.top.equalTo(self.videoUploadBtn.mas_bottom);
//            make.width.equalTo(@(scrnW));
        //            make.height.equalTo(self.picUploadLabel);
        //        }];
        //
        //        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.picUploadBtn);
        //            make.top.equalTo(self.videoUploadBtn.mas_bottom).offset(120.0);
        //            make.width.height.equalTo(@30);
        //        }];

        [self.picUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(scrnW * 0.5));
            make.centerY.equalTo(@(scrnH));
            make.height.width.equalTo(@123);
        }];
        
        YGLog(@"%@", NSStringFromCGRect(self.picUploadBtn.frame));
    }
    return self;
}


- (void)updateConstraints
{
    [self.picUploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.width.equalTo(@123);
    }];
    
    [super updateConstraints];
}

- (void)didMoveToWindow
{
    [UIView animateWithDuration:2.0 animations:^{
        [self layoutIfNeeded];
    }];
}

//- (void)popUp
//{
//    [UIView animateWithDuration:1.0 animations:^{
//        [self.picUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.centerY.equalTo(self).multipliedBy(0.8);
//            make.height.width.equalTo(@123);
//        }];
//    }];
//}
//
//
//- (void)close
//{
//
//    [self setNeedsUpdateConstraints];
//
//    [self updateConstraints];
//
//    [UIView animateWithDuration:10.0 animations:^{
//
//    }];
//
//    [self layoutIfNeeded];
//}
@end
