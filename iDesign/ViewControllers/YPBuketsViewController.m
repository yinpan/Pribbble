//
//  YPBuketsViewController.m
//  iDesign
//
//  Created by 千锋 on 16/3/10.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPBuketsViewController.h"
#import "AppDelegate.h"
#import "YPParamManager.h"
#import "YPBuketsCollectionViewCell.h"
#import "YPBuketsShotViewController.h"
#import "YPOAuth2Controller.h"
#import <MJRefresh.h>

@interface YPBuketsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic, strong) YPParamManager *paramManager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *loadingView;


@end

@implementation YPBuketsViewController

- (UIView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_loadingView];
        _loadingView.backgroundColor = [UIColor themeCellGrayBackground];
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.frame = CGRectMake(WIDTH * 0.5 - 20, 70, 40, 40);
        [act startAnimating];
        [_loadingView addSubview:act];
    }
    return _loadingView;
}

- (UIView *)maskView
{
    if (_maskView == nil) {
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _maskView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _maskView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self.view addSubview:_maskView];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
        [button setTitle:@"Connect" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontStandard];
        [button setTitleColor:[UIColor themeWhiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showLoginDribbble) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor themeColor]];
        button.layer.cornerRadius = 18;
        button.layer.masksToBounds = YES;
        button.center = _maskView.center;
        [_maskView addSubview:button];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH *0.15, CGRectGetMinY(button.frame) - 50, WIDTH * 0.7, 50)];
        subTitle.font = [UIFont fontStandard];
        subTitle.textColor = [UIColor themeButtonBlackColor];
        subTitle.numberOfLines = 2;
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.text = @"Connet Dribbble to create and view buckets!";
        [_maskView addSubview:subTitle];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(subTitle.frame) - 25, WIDTH, 25)];
        titleLabel.text = @"No Account";
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor themeBackgroundBlack];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_maskView addSubview:titleLabel];
    }
    return _maskView;
}



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
        [self maskView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customNavigationbar];
    if (![[YPFactory shareApiClient] isUserAuthorized]) {
        [self maskView];
    }else{
        if (_maskView) {
            [_maskView removeFromSuperview];
            _maskView = nil;
        }
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(WIDTH * 0.5, WIDTH * 0.5 * 0.74);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 69 ) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor themeWhiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"YPBuketsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    MJRefreshNormalHeader *cHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBuketsData:YES];
    }];
    [cHeader setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [cHeader setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    [cHeader setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [cHeader setTintColor:[UIColor themeFontGrayColor]];
    cHeader.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = cHeader;
    
    
    [self.view addSubview:_collectionView];
}

- (void)loadBuketsData:(BOOL)isRefresh
{
    if (isRefresh) {
        [self.paramManager reset];
        [self loadingView];
    }
    
    NSNumber *userId = [YPFactory userDefaultsObjectForKey:KEY_BUKET_ID];
    [YPFactory networkActivityIndicatorShow];
    if (!userId) {
       [[YPFactory shareApiClient] loadUserInfoWithResponseHandler:^(DRApiResponse *response) {
           if (!response.error) {
               DRUser *user = response.object;
               [YPFactory userDefaultsSetObject:user.userId forKey:KEY_USERID];
               [[YPFactory shareApiClient] loadBucketsWithUser:user.userId params:[self.paramManager nowParams] responseHandler:^(DRApiResponse *response) {
                   [self dealWithResponse:response isRefresh:isRefresh];
               }];
           }
       }];
    }else{
        [[YPFactory shareApiClient] loadBucket:userId params:[self.paramManager nowParams] responseHandler:^(DRApiResponse *response) {
            [self dealWithResponse:response isRefresh:isRefresh];
        }];
    }
}


- (void)dealWithResponse:(DRApiResponse *)response isRefresh:(BOOL)refresh
{
    [self endRefreshing];
    if (!response.error) {
        if (refresh) {
            [self.dataArray removeAllObjects];
        }
        [self.paramManager next];
        if (_loadingView) {
            [_loadingView removeFromSuperview];
            _loadingView = nil;
        }
        NSArray *array = response.object;
        if (array.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"No Buckets"];
        }
        [self.dataArray addObjectsFromArray:array];
        [self.collectionView reloadData];
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
        _collectionView.mj_footer = cFooter;
    }
}

- (void) endRefreshing {
    if (_collectionView.mj_header.isRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
    
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
}




#pragma mark -- UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPBuketsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPBuketsCollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    YPBuketsShotViewController *shotVC = [[YPBuketsShotViewController alloc] init];
    shotVC.buketId = cell.model.bucketId;
    shotVC.buketsCount = cell.model.shotsCount;
    shotVC.hidesBottomBarWhenPushed = YES;
    shotVC.title = cell.model.name;
    [self.navigationController pushViewController:shotVC animated:YES];
}

- (void)showLoginDribbble
{
    YPOAuth2Controller *oauthVC = [[YPOAuth2Controller alloc] init];
    __weak typeof(self) weakSelf = self;
    oauthVC.finishBlock = ^(BOOL finished){
        if (finished) {
            [weakSelf loadBuketsData:YES];
            [weakSelf.maskView removeFromSuperview];
        }
    };
    oauthVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oauthVC animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
