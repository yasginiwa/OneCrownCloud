//
//  YGFileBaseVC.h
//  幸福云盘
//
//  Created by YGLEE on 2018/7/19.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YGFileBaseVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *libraries;
@property (nonatomic, weak) UIView *loadingView;
@end
