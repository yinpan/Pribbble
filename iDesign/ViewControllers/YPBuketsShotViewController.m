//
//  YPBuketsShotViewController.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.

#import "YPBuketsShotViewController.h"
#import "YPBuketsTableViewCell.h"
#import "YPShotViewController.h"
#import "AppDelegate.h"
#import "YPParamManager.h"
#import <MJRefresh.h>

@interface YPBuketsShotViewController ()<UITableViewDataSource,UITableViewDelegate,YPShotCellViewDelegate>

@property (nonatomic, strong) YPParamManager *paramManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation YPBuketsShotViewController


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (YPParamManager *)paramManager
{
    if (_paramManager == nil) {
        _paramManager = [[YPParamManager alloc] init];
    }
    return _paramManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationbar];
    [self createUI];
    
    if ([[YPFactory shareApiClient] isUserAuthorized]) {
        [self loadBuketsData:YES];
    }else{
        
    }
}



#pragma mark -- 定制导航栏
- (void)customNavigationbar
{
    self.navigationController.navigationBar.barTintColor = [UIColor themeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};
    self.navigationController.navigationBar.tintColor = [UIColor themeBarTinColor];
}

#pragma mark -- 创建视图
- (void)createUI
{
    self.view.backgroundColor = [UIColor themeCellGrayBackground];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"YPBuketsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)loadBuketsData:(BOOL)isRefresh
{

    [[YPFactory shareApiClient] loadBucketShots:_buketId params:[self.paramManager nowParams] responseHandler:^(DRApiResponse *response) {
        [self dealWithResponse:response isRefresh:isRefresh];
    }];
}


- (void)dealWithResponse:(DRApiResponse *)response isRefresh:(BOOL)refresh
{
    [self endRefreshing];
    if (!response.error) {
        if (refresh) {
            [self.dataArray removeAllObjects];
        }
        [self.paramManager next];
        NSArray *array = response.object;
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        if (array.count > 30) {
            [self addFooterLoadMore:refresh];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error" maskType:0];
    }
    [YPFactory networkActivityIndicatorClose];
}

- (void)addFooterLoadMore:(BOOL)isRefresh
{
    if (isRefresh) {
        MJRefreshAutoNormalFooter *cFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadBuketsData:NO];
        }];
        cFooter.stateLabel.text = @"Load...";
        [cFooter setTitle:@"Load..." forState:MJRefreshStatePulling];
        [cFooter setTitle:@"Load..." forState:MJRefreshStateRefreshing];
        [cFooter setTitle:@"Load..." forState:MJRefreshStateIdle];
        cFooter.stateLabel.font = [UIFont fontStandard];
        cFooter.automaticallyRefresh = NO;
        _tableView.mj_footer = cFooter;
    }
}

- (void) endRefreshing {
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
    }
    
    if (_tableView.mj_footer.isRefreshing) {
        [_tableView.mj_footer endRefreshing];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count % 2 + self.dataArray.count / 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPBuketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.leftView.model = self.dataArray[indexPath.row * 2];
    cell.leftView.delegate = self;
    if (self.dataArray.count > indexPath.row * 2 + 1) {
        cell.rightView.model = self.dataArray[indexPath.row * 2 + 1];
        cell.rightView.delegate = self;
    }else{
        cell.rightView.model = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WIDTH * 0.5 * 3 / 4.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor themeCellGrayBackground];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, WIDTH - 20, 22)];
    label.text = [NSString stringWithFormat:@"%@ SHOTS",_buketsCount];
    label.font = [UIFont fontStandard];
    label.textColor = [UIColor themeFontGrayColor];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


#pragma mark -- cellView点击事件
- (void)shotCellView:(YPShotCellView *)shotCellView didSelectedWithShot:(DRShot *)shot shotImageView:(UIImage *)sImage
{
    YPShotViewController *shotVC = [[YPShotViewController alloc] init];
    shotVC.shot = shot;
    shotVC.sImage = sImage;
    [self.navigationController pushViewController:shotVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

