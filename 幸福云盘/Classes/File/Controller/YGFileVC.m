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
#import "YGLoadingView.h"

@interface YGFileVC () <YGFileCellDelegate>
@property (nonatomic, strong) NSMutableArray *libraries;
@property (nonatomic, weak) UIView *loadingView;
@end

@implementation YGFileVC

/** 懒加载 */
- (NSMutableArray *)libraries
{
    if (_libraries == nil) {
        _libraries = [NSMutableArray array];
    }
    return _libraries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoadingView];
    
    [self judgeFirstLogin];
    
    [self setupNavBar];
}

/** 判断是否第一次登陆 然后请求所有的repo */
- (void)judgeFirstLogin
{
    if ([YGApiTokenTool apiToken]) {
        [self requestLibraries];
    } else {
        [self addObserver];
    }
}

/** 添加KVO */
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLibraries) name:YGTokenSavedNotification object:nil];
}

/** 初始化loadingView */
- (void)setupLoadingView
{
    YGLoadingView *loadingView = [[YGLoadingView alloc] init];
    loadingView.frame = self.view.bounds;
    [self.view addSubview:loadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loadingView = loadingView;
}

/** 请求repo */
- (void)requestLibraries
{
    NSString *librariesURL = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:LIST_LIBARIES_URL]];
    
    YGApiToken *token = [YGApiTokenTool apiToken];
    [YGHttpTool GET:librariesURL apiToken:token params:nil success:^(id responseObject) {
        NSArray *libs = [YGFileModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.libraries addObjectsFromArray:libs];
        [self.loadingView removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
        YGLog(@"reloadData---");
    } failure:^(NSError *error) {
        YGLog(@"%@", error);
    }];
}

/** 初始化navBar */
- (void)setupNavBar
{
    UIBarButtonItem *newFolderItem = [UIBarButtonItem itemWithImage:@"file_newfolder" highImage:@"file_newfolder_pressed" target:self action:@selector(newFolder)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 0;
    UIBarButtonItem *orderItem = [UIBarButtonItem itemWithImage:@"nav_order" highImage:@"nav_order_pressed" target:self action:@selector(orderFolder)];
    UIBarButtonItem *uploadItem = [UIBarButtonItem itemWithImage:@"file_upload" highImage:@"file_upload_pressed" target:self action:@selector(fileUpload)];
    self.navigationItem.leftBarButtonItems = @[newFolderItem, spaceItem, orderItem];
    self.navigationItem.rightBarButtonItem = uploadItem;
}

- (void)newFolder
{
    YGLog(@"--newFolder--");
}

- (void)orderFolder
{
    YGLog(@"--orderFolder--");
}

- (void)fileUpload
{
    YGLog(@"--fileUpload--");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.libraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileCell *cell = [YGFileCell fileCell];
    cell.delegate = self;
    cell.fileModel = self.libraries[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGFileModel *fileModel = self.libraries[indexPath.row];
    [self requestSubRepoWithFileModel:fileModel];
    
}

- (void)requestSubRepoWithFileModel:(YGFileModel *)fileModel
{
    NSString *rootRepoURL = [BASE_URL stringByAppendingString:[API_URL stringByAppendingString:LIST_LIBARIES_URL]];
    NSString *subRepoURL = [rootRepoURL stringByAppendingString:[NSString stringWithFormat:@"%@/dir/sub_repo/?p=/\&name=sub_lib", fileModel.ID]];
    
    YGApiToken *token = [YGApiTokenTool apiToken];
    [YGHttpTool GET:subRepoURL apiToken:token params:nil success:^(id responseObject) {
        YGFileModel *subFileModel = [[YGFileModel alloc] init];
        subFileModel.ID = responseObject[@"sub_repo_id"];
        [YGHttpTool GET:[NSString stringWithFormat:@"%@%@", rootRepoURL, subFileModel.ID] apiToken:token params:nil success:^(id responseObject) {
            YGLog(@"%@", responseObject);
        } failure:^(NSError *error) {
            YGLog(@"%@", error);
        }];
    } failure:^(NSError *error) {
        YGLog(@"%@", error);
    }];
}

#pragma mark - YGFileCellDelegate
- (void)fileCellDidSelectCheckBtn:(YGFileCell *)fileCell
{
    NSLog(@"--fileCellDidSelectCheckBtn--");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
