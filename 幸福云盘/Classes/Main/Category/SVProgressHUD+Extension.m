//
//  SVProgressHUD+Extension.m
//  幸福云盘
//
//  Created by LiYugang on 2018/7/31.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "SVProgressHUD+Extension.h"

@implementation SVProgressHUD (Extension)
+ (void)showWaiting
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
}

+ (void)showMessage:(NSString *)message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showInfoWithStatus:message];
    [SVProgressHUD dismissWithDelay:0.5];
}

+ (void)showWaiting:(NSString *)title
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showWithStatus:title];
}

+ (void)showSuccess:(NSString *)success
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showSuccessWithStatus:success];
    [SVProgressHUD dismissWithDelay:0.5];
}

+ (void)showError:(NSString *)error
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showErrorWithStatus:error];
    [SVProgressHUD dismissWithDelay:0.5];
}

+ (void)showSuccessFace:(NSString *)success
{
    [SVProgressHUD showSuccess:success];
    [SVProgressHUD setImageViewSize:CGSizeMake(38, 38)];
    [SVProgressHUD showImage:[UIImage imageNamed:@"file_successface"] status:success];
    [SVProgressHUD dismissWithDelay:0.5];
}

+ (void)showFailureFace:(NSString *)failure
{
    [SVProgressHUD showError:failure];
    [SVProgressHUD setImageViewSize:CGSizeMake(38, 38)];
    [SVProgressHUD showImage:[UIImage imageNamed:@"file_failureface"] status:failure];
    [SVProgressHUD dismissWithDelay:0.5];
}

+ (void)hide
{
    [SVProgressHUD dismissWithDelay:0.0];
}
@end
