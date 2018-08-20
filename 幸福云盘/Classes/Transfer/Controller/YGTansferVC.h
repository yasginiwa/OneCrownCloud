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
@property (nonatomic, copy) void (^downloadFile)(YGFileModel *downloadFileModel);
@property (nonatomic, copy) void (^uploadFile)(YGFileModel *uploadFileModel);
@end
