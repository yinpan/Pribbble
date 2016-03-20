//
//  YPFollowListViewController.m
//  iDesign
//
//  Created by 千锋 on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPFollowListViewController.h"
#import "YPUserInfoViewController.h"
#import "YPFollowTableViewCell.h"
#import "YPParamManager.h"
#import <DRTransactionModel.h>
#import <MJRefresh.h>

static NSString * const kCellReuseIdentifier = @"CELL";
@interface YPFollowListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YPParamManager *paramManager;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *followCountLabel;
@property (nonatomic, assign) BOOL isNotMore;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation YPFollowListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = _isFollowers?@"Follows":@"Following";
    [self createTableView];
    [self createUserInfoView];
    [self loadData];
}

- (void)createUserInfoView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    view.backgroundColor = [[UIColor themeBackgroundBlack] colorWithAlphaComponent:0.8];
    [self.view addSubview:view];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    _imageView.layer.cornerRadius = 5;
    _imageView.clipsToBounds = YES;
    _imageView.image = _avatarImage;
    [view addSubview:_imageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 20, CGRectGetMinY(_imageView.frame), WIDTH - CGRectGetMaxX(_imageView.frame) - 20, 30)];
    _userNameLabel.font = [UIFont fontTitle];
    _userNameLabel.textColor = [UIColor themeBarTinColor];
    _userNameLabel.text = _userName;
    [view addSubview:_userNameLabel];
    
    
    _followCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userNameLabel.frame), CGRectGetMaxY(_userNameLabel.frame), CGRectGetWidth(_userNameLabel.frame), 20)];
    _followCountLabel.font = [UIFont fontminiStandard];
    _followCountLabel.textColor = [UIColor themeBarTinColor];
    _followCountLabel.text = _isFollowers?[NSString stringWithFormat:@"%@  Followers",_followCount]:[NSString stringWithFormat:@"%@  Following",_followCount];
    [view addSubview:_followCountLabel];
}

- (void)loadData
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        _paramManager = [[YPParamManager alloc] initWithStartPage:1 perPageNumber:30];
    }
    if (_isFollowers) {
        [[YPFactory shareApiClient] loadFollowersWithUser:_userId params:[_paramManager nowParams] responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                NSArray *array = response.object;
                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                _isNotMore = !(array.count==30);
                [_paramManager next];
            }
        }];
    }else{
        [[YPFactory shareApiClient] loadFolloweesWithUser:_userId params:[_paramManager nowParams] responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                NSArray *array = response.object;
                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                _isNotMore = !(array.count==30);
                [_paramManager next];
            }
        }];
    }
    
    [self addFooterLoadMore];

}
 
- (void)addFooterLoadMore
{
    if (!_isNotMore) {
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData];
        }];
        _footer.stateLabel.text = @"Loading...";
        [_footer setTitle:@"Loading..." forState:MJRefreshStatePulling];
        [_footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"Loading..." forState:MJRefreshStateIdle];
        [_footer setTitle:@"No more!" forState:MJRefreshStateNoMoreData];
        _footer.stateLabel.font = [UIFont fontStandard];
        _footer.automaticallyRefresh = NO;
        _tableView.mj_footer = _footer;
    }else{
        if (_footer) {
            [_footer endRefreshingWithNoMoreData];
        }
    }
}



// 初始化表格
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT  - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"YPFollowTableViewCell" bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
    
    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPFollowTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    YPUserInfoViewController *userVC = [[YPUserInfoViewController alloc] init];
    DRTransactionModel *model = _dataArray[indexPath.row];
    userVC.userID = model.followee?model.followee.userId:model.follower.userId;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
