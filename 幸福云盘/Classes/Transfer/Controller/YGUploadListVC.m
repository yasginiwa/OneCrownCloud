//
//  YGUploadListVC.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGUploadListVC.h"
#import "YGUploadCell.h"

@interface YGUploadListVC ()

@end

@implementation YGUploadListVC
#pragma mark - 懒加载
- (NSMutableArray *)uploadFiles
{
    if (_uploadFiles == nil) {
        _uploadFiles = [NSMutableArray array];
    }
    return _uploadFiles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self addObsvr];
}

- (void)setupAppearance
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)addObsvr
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUploadFileModel:) name:YGAddUploadFileNotification object:nil];
}

- (void)addUploadFileModel:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    YGFileModel *uploadFileModel = userInfo[@"uploadFileModel"];
    [self.uploadFiles addObject:uploadFileModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uploadFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGUploadCell *cell = [YGUploadCell uploadCell];
    cell.uploadFileModel = self.uploadFiles[indexPath.row];
    return cell;
}
@end
