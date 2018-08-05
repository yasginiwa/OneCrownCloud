//
//  SVProgressHUD+Extension.h
//  幸福云盘
//
//  Created by LiYugang on 2018/7/31.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (Extension)
+ (void)showWaiting;
+ (void)showMessage:(NSString *)message;
+ (void)showWaiting:(NSString *)title;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showSuccessFace:(NSString *)success;
+ (void)showFailureFace:(NSString *)failure;
+ (void)hide;
@end
