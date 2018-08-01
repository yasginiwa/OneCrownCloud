//
//  YGFileUploadVC.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/1.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileUploadVC.h"

@interface YGFileUploadVC ()
@property (nonatomic, weak) UIButton *picUploadBtn;
@property (nonatomic, weak) UILabel *picUploadLabel;
@property (nonatomic, weak) UIButton *videoUploadBtn;
@property (nonatomic, weak) UILabel *videoUploadLabel;
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation YGFileUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    //  初始化自己外观
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  添加图片上传按钮
    UIButton *picUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [picUploadBtn setImage:[UIImage imageNamed:@"file_upload_pic"] forState:UIControlStateNormal];
    [self.view addSubview:picUploadBtn];
    self.picUploadBtn = picUploadBtn;
    
    //  添加图片上传标签
    UILabel *picUploadLabel = [[UILabel alloc] init];
    picUploadLabel.text = @"上传图片";
    picUploadLabel.textAlignment = NSTextAlignmentCenter;
    picUploadLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:picUploadLabel];
    self.picUploadLabel = picUploadLabel;
    
    //  添加视频上传按钮
    UIButton *videoUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoUploadBtn setImage:[UIImage imageNamed:@"file_upload_video"] forState:UIControlStateNormal];
    [self.view addSubview:videoUploadBtn];
    self.videoUploadBtn = videoUploadBtn;
    
    //  添加视频上传标签
    UILabel *videoUploadLabel = [[UILabel alloc] init];
    videoUploadLabel.text = @"上传视频";
    videoUploadLabel.textAlignment = NSTextAlignmentCenter;
    videoUploadLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:videoUploadLabel];
    self.videoUploadLabel = videoUploadLabel;
    
    //  添加关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"file_upload_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.view setNeedsUpdateConstraints];

    [self.view updateConstraintsIfNeeded];

    [UIView animateWithDuration:1.0 animations:^{
        [self.picUploadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).multipliedBy(0.8);
        }];

        [self.picUploadBtn.superview layoutIfNeeded];
    }];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    [self.picUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view).multipliedBy(0.8);
//        make.height.width.equalTo(@123);
//    }];
//
//    [self.picUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.picUploadBtn.mas_bottom);
//        make.width.equalTo(self.view);
//        make.height.equalTo(@14);
//    }];
//
//    [self.videoUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.picUploadBtn);
//        make.top.equalTo(self.picUploadBtn.mas_bottom).offset(60.0);
//        make.height.width.equalTo(self.picUploadBtn);
//    }];
//
//    [self.videoUploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.videoUploadBtn.mas_bottom);
//        make.width.equalTo(self.view);
//        make.height.equalTo(self.picUploadLabel);
//    }];
//
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.videoUploadBtn);
//        make.top.equalTo(self.videoUploadBtn.mas_bottom).offset(120.0);
//        make.width.height.equalTo(@30);
//    }];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.picUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.width.equalTo(@123);
    }];
}

@end
