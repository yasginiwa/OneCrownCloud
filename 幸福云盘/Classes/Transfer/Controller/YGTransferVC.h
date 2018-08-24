//
//  YGTransferVC.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YGTransferShowContenTypeDownload,
    YGTransferShowContenTypeUpload
}YGTransferShowContenType;

@interface YGTransferVC : UIViewController
@property (nonatomic, assign) YGTransferShowContenType contenType;
@end
