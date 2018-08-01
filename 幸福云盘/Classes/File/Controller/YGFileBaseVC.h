//
//  YGFileBaseVC.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel, YGFileEmptyView, YGNetworkFailedView;

@interface YGFileBaseVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *libraries;
@property (nonatomic, weak) UIView *loadingView;
@property (nonatomic, weak) YGFileEmptyView *fileEmptyView;
@property (nonatomic, weak) YGNetworkFailedView *networkFailedView;
@property (nonatomic, strong) YGFileModel *currentFileModel;

- (void)fileUpload;
@end
