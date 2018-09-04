//
//  YGTransferVC.h
//  幸福云盘
//
//  Created by YGLEE on 2018/8/23.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGFileModel;

typedef enum {
    YGTransferShowContenTypeDownload,
    YGTransferShowContenTypeUpload
}YGTransferShowContenType;

@interface YGTransferVC : UIViewController
@property (nonatomic, assign) YGTransferShowContenType contenType;
/** 上传文件传输数组(包括未完成和完成的) */
@property (nonatomic, strong) NSMutableArray *uploadTransferFiles;
/** 下载文件传输数组(包括未完成和完成的) */
@property (nonatomic, strong) NSMutableArray *downloadTransferFiles;
/** 正在上传的当前文件模型*/
@property (nonatomic, strong) YGFileModel *uploadingFileModel;
/** 正在下载的当前文件模型 */
@property (nonatomic, strong) YGFileModel *downloadingFileModel;
@end
