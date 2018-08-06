//
//  YGTransferProgressView.h
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGTransferProgressView : UIImageView
@property (nonatomic, strong) UIColor *arcFinishColor;
@property (nonatomic, strong) UIColor *arcUnFinishColor;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float width;
@end
