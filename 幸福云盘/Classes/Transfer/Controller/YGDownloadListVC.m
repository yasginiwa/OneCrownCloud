//
//  YGDownloadListVC.m
//  幸福云盘
//
//  Created by LiYugang on 2018/8/6.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGDownloadListVC.h"
#import "YGDownloadCell.h"
#import "YGTransferModel.h"
#import "YGFileModel.h"

@interface YGDownloadListVC ()

@end

@implementation YGDownloadListVC

#pragma mark - 懒加载
- (NSMutableArray *)downloadTasks
{
    if (_downloadTasks == nil) {
        _downloadTasks = [NSMutableArray array];
    }
    return _downloadTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YGFileModel *file1 = [[YGFileModel alloc] init];
    file1.name = @"abc.xlsx";
    file1.type = @"file";
    file1.size = @456461;
    
    YGTransferModel *down1 = [[YGTransferModel alloc] init];
    down1.fileModel = file1;
    down1.downloadTime = @"2017-10-20 14:01:03";
    down1.progress = 0.8;
    
    [self.downloadTasks addObject:down1];
    
    [self.tableView reloadData];
    
    [self setupAppearance];
}

- (void)setupAppearance
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGDownloadCell *cell = [YGDownloadCell downloadCell];
    cell.transferModel = self.downloadTasks[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
@end
