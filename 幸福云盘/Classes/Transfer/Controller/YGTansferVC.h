//
//  YGTansferVC.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel;

@interface YGTansferVC : UIViewController
@property (nonatomic, strong) YGFileModel *uploadFileModel;
@property (nonatomic, strong) YGFileModel *downloadFileModel;
@end
