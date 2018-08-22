//
//  YGMenuView.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/5.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGMenuView : UIView
- (void)downloadAddTarget:(id)target action:(SEL)action;
- (void)uploadAddTarget:(id)target action:(SEL)action;
@end
