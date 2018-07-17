//
//  YGFileVC.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/11.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "YGFileVC.h"
#import "YGHttpTool.h"
#import "YGApiTokenTool.h"
#import "YGFileModel.h"
#import "YGFileCell.h"

@interface YGFileVC ()
@property (nonatomic, strong) NSMutableArray *libraries;
@end

@implementation YGFileVC

/** 懒加载 */
- (NSMutableArray *)libraries
{
    if (_libraries == nil) {
        _libraries = [NSMutableArray array];
        NSString *librariesURL = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:LIST_LIBARIES_URL]];
        [YGHttpTool GET:librariesURL apiToken:[YGApiTokenTool apiToken] params:nil success:^(id responseObject) {
            NSArray *libs = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
            _libraries = [NSMutableArray arrayWithArray:libs];
        } failure:^(NSError *error) {
            
        }];
    }
    return _libraries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YGLog(@"%@", self.libraries);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.libraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileCell *cell = [YGFileCell cellWithTableView:tableView];
    cell.fileModel = self.libraries[indexPath.row];
    return cell;
}
@end
