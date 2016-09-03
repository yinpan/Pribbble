//
//  YPScanViewController.m
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPScanViewController.h"
#import "YPOAuth2Controller.h"
#import "YPUserInfoViewController.h"
#import "YPShotsCollectionViewCell.h"
#import "YPShotsTableViewCell.h"
#import "YPShotViewController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager+Util.h"
#import <DRApiClientSettings.h>
#import <MJRefresh.h>
#import <DRApiClient.h>
#import "YPParamManager.h"
#import "YPMenuViewController.h"
#import "YPWelcomeViewController.h"
#import "YPAddBuketViewController.h"



static NSString * const kCellReuseIdentifier = @"CELL";

@interface YPScanViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,YPShotsTableViewCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *collectionViewDataArray;
@property (nonatomic, strong)YPParamManager *paranManager;
@property (nonatomic, strong)UIView *oautView;
@property (nonatomic, strong)NSMutableArray *likeArray;
@property (nonatomic, strong)NSMutableArray *tableDataArray;
@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, assign)BOOL isFollowing;
@end

@implementation YPScanViewController


#pragma mark -- 懒加载
- (YPParamManager *)paranManager
{
    if (!_paranManager) {
        _paranManager = [[YPParamManager alloc] initWithStartPage:1 perPageNumber:30];

    }
    return _paranManager;
}

- (NSMutableArray *)tableDataArray
{
    if (_tableDataArray == nil) {
        _tableDataArray = [NSMutableArray array];
    }
    return _tableDataArray;
}

- (NSMutableArray *)collectionViewDataArray
{
    if (_collectionViewDataArray == nil) {
        _collectionViewDataArray = [NSMutableArray array];
    }
    return _collectionViewDataArray;
}

- (NSMutableArray *)likeArray
{
    if (_likeArray == nil) {
        _likeArray = [NSMutableArray array];
        [[YPFactory shareApiClient] loadLikesWithUser:[YPFactory userDefaultsObjectForKey:KEY_USERID] params:@{@"per_page":@100} responseHandler:^(DRApiResponse *response) {
        }];
    }
    return _likeArray;
}

- (UIView *)oautView
{
    if (_oautView == nil) {
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _oautView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _oautView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self.view addSubview:_oautView];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
        [button setTitle:@"Connect" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontStandard];
        [button setTitleColor:[UIColor themeWhiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showLoginDribbble) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor themeColor]];
        button.layer.cornerRadius = 18;
        button.layer.masksToBounds = YES;
        button.center = _oautView.center;
        [_oautView addSubview:button];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH *0.15, CGRectGetMinY(button.frame) - 50, WIDTH * 0.7, 50)];
        subTitle.font = [UIFont fontStandard];
        subTitle.textColor = [UIColor themeButtonBlackColor];
        subTitle.numberOfLines = 2;
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.text = @"Connet Dribbble view shots from players you are following!";
        [_oautView addSubview:subTitle];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(subTitle.frame) - 25, WIDTH, 25)];
        titleLabel.text = @"No Account";
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor themeBackgroundBlack];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_oautView addSubview:titleLabel];
    }
    return _oautView;
}


- (UIView *)maskView
{
    
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_maskView];
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH * 0.5 - 20, 70, 40, 40)];
        act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _maskView.backgroundColor = [UIColor themeCellGrayBackground];
        [_maskView addSubview:act];
        [act startAnimating];
     }
    return _maskView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 定制导航栏
    [self customNavigationbar];
    
    // 创建视图
    [self createUI];
    [self changeTitle];
    [self resetSortType];
    
    // 加载数据
    [self loadData:YES changeType:YES];
}


#pragma mark -- 定制导航栏
- (void)customNavigationbar
{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _titleLabel.textColor = [UIColor themeWhiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    self.navigationItem.titleView = _titleLabel;
    [self changeTitle];
    
    self.navigationController.navigationBar.barTintColor = [UIColor themeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};

    // 设置状态栏左边用户图片圆角
//    UIImage *userImage = [UIImage imageNamed:@"user"];
//    userImage.
    self.navigationItem.leftBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"type" target:self action:@selector(showMenu:)];
    [self rightBarButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor themeBarTinColor];
}

- (void)rightBarButtonItem
{
    if ([[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] != 1) {
        self.navigationItem.rightBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"down" target:self action:@selector(showMenu:)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/** 初始化排序 */
- (void)resetSortType
{
    if ([YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX]) {
        [YPFactory userDefaultsSetObject:@"0" forKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX];
    }
    if ([YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_TIME_SELECTEDINDEX]) {
        [YPFactory userDefaultsSetObject:@"0" forKey:KEY_MENU_SORT_TIME_SELECTEDINDEX];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showOAuthViewOrMaskView];
}

- (void)showOAuthViewOrMaskView
{
    if (![[YPFactory shareApiClient] isUserAuthorized] && [[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] == 1) {
        [self oautView];
        if (_maskView) {
            [_maskView removeFromSuperview];
            _maskView = nil;
        }
    }else{
        if (_oautView) {
            [_oautView removeFromSuperview];
        }
    }
}

#pragma mark -- 创建页面视图
- (void)createUI
{
    
    // 创建ScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 2, HEIGHT - 64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    // 创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(_scrollView.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"YPShotsTableViewCell" bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
    _tableView.backgroundColor = [UIColor themeBackgroundGray];
    [_scrollView addSubview:_tableView];
    // 创建头尾视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES changeType:NO];
    }];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTintColor:[UIColor themeFontGrayColor]];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    [header beginRefreshing];
    
    // 创建集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(WIDTH * 0.5, WIDTH * 0.5 * 0.75);
//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, CGRectGetHeight(_scrollView.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.contentInset = UIEdgeInsetsMake( 10 + 57, WIDTH * 0.09 * 0.333, 10, WIDTH * 0.09 * 0.333);
    _collectionView.contentInset = UIEdgeInsetsMake( 0, 0, 0, 0);
    [_collectionView registerNib:[UINib nibWithNibName:@"YPShotsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    _collectionView.backgroundColor = [UIColor themeBackgroundGray];
    
    MJRefreshNormalHeader *cHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES changeType:NO];
    }];
    [cHeader setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [cHeader setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    [cHeader setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [cHeader setTintColor:[UIColor themeFontGrayColor]];
    cHeader.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = cHeader;
    [_scrollView addSubview:_collectionView];

}

#pragma mark -- 加载数据
- (void)loadData:(BOOL)isRefresh changeType:(BOOL)isChange
{
    if (isRefresh) {
        [self.paranManager reset];
        if (![[YPFactory shareApiClient] isUserAuthorized] && [[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] == 1) {
            [self oautView];
        }else{
            if (_oautView) {
                [_oautView removeFromSuperview];
                _oautView = nil;
            }
            if (isChange) {
                [self maskView];
            }
        }
    }
    
    if ([[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] == 1) {
        
    }
    [YPFactory networkActivityIndicatorShow];
    
    if ([[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] == 1) {
        [[YPFactory shareApiClient] loadFolloweesShotsWithParams:[self nowParams] responseHandler:^(DRApiResponse *response) {
            [self dealWithResponse:response isRefresh:isRefresh changeType:isChange];
        }];
    }else{
        [[YPFactory shareApiClient] yp_requestShotsWithparams:[self nowParams] responseHandler:^(DRApiResponse *response) {
            [self dealWithResponse:response isRefresh:isRefresh changeType:isChange];
        }];
    }
}


- (NSDictionary *)nowParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.paranManager nowParams]];
    
    NSArray *listArray = @[@"",@"",@"debuts",@"animated",@"teams",@"playoffs"];
    NSArray *sortArray = @[@"recent",@"popular",@"views",@"comments"];
    NSArray *timeArray = @[@"",@"week",@"month",@"year",@"ever"];
    
    
    if ([[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue] != 1) {
        if ([YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX]) {
            [dict setObject:listArray[[[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX]intValue]] forKey:@"list"];
        }else{
            [dict setObject:@"" forKey:@"list"];
        }
        if ([YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX]) {
            [dict setObject:sortArray[[[YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX]intValue]] forKey:@"sort"];
        }else{
            [dict setObject:@"" forKey:@"sort"];
        }
        if ([YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_TIME_SELECTEDINDEX]) {
            [dict setObject:timeArray[[[YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_TIME_SELECTEDINDEX]intValue]] forKey:@"timeframe"];
        }
        _isFollowing = NO;
    }else{
        _isFollowing = YES;
    }
    return dict;
}

- (void)dealWithResponse:(DRApiResponse *)response isRefresh:(BOOL)refresh changeType:(BOOL)isChange
{
    [self endRefreshing];
    if (!response.error) {
        if (refresh) {
            [_tableView setContentOffset:CGPointZero animated:NO];
            [_collectionView setContentOffset:CGPointZero animated:NO];
            if (_isFollowing) {
                [self.tableDataArray removeAllObjects];
            }else{
                [self.collectionViewDataArray removeAllObjects];
            }
        }
        [self.paranManager next];
        [self addDataAndReloadData:response.object];
        [self addFooterLoadMore:refresh];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error" maskType:0];
    }
    if (isChange) {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
    [YPFactory networkActivityIndicatorClose];
}

- (void)addFooterLoadMore:(BOOL)isRefresh
{
    if (isRefresh) {
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData:NO changeType:NO];
        }];
        footer.stateLabel.text = @"Loading...";
        [footer setTitle:@"Loading..." forState:MJRefreshStatePulling];
        [footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"Loading..." forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont fontStandard];
        footer.automaticallyRefresh = NO;
        _tableView.mj_footer = footer;
        
        MJRefreshAutoNormalFooter *cFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData:NO changeType:NO];
        }];
        cFooter.stateLabel.text = @"Loading...";
        [cFooter setTitle:@"Loading..." forState:MJRefreshStatePulling];
        [cFooter setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
        [cFooter setTitle:@"Loading..." forState:MJRefreshStateIdle];
        cFooter.stateLabel.font = [UIFont fontStandard];
        cFooter.automaticallyRefresh = NO;
        
        _collectionView.mj_footer = cFooter;
    }
}

- (void)addDataAndReloadData:(id)object
{
    if (_isFollowing) {
        [self.tableDataArray addObjectsFromArray:object];
    }else{
        [self.collectionViewDataArray addObjectsFromArray:object];
    }
    [self showShotsAtCollectionVieworTableView];
}

#pragma mark -- 切换显示模式
- (void)showShotsAtCollectionVieworTableView
{
    if (_isFollowing) {
        // 列表视图
        CGRect rect = _scrollView.frame;
        rect.origin.x = 0;
        _scrollView.frame = rect;
        
        [_tableView reloadData];
        [self.collectionViewDataArray removeAllObjects];
        [_collectionView reloadData];
    }else{
        // 集合视图
        CGRect rect = _scrollView.frame;
        rect.origin.x = - WIDTH;
        _scrollView.frame = rect;
        [_collectionView reloadData];
        [self.tableDataArray removeAllObjects];
        [_tableView reloadData];
        
    }
}

#pragma mark -- 跳转用户详情界面
- (void)showUserDetailInfo:(UIBarButtonItem *)sender
{

    YPUserInfoViewController *userInfoVC = [[YPUserInfoViewController alloc] init];
    userInfoVC.isSelf = YES;
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}



#pragma mark -- 展开菜单
- (void)showMenu:(UIBarButtonItem *)sender
{
    YPMenuViewController *menuVC = [[YPMenuViewController alloc] init];
    menuVC.selectedBlock = ^(BOOL success){
        if (success) {
            [self loadData:YES changeType:YES];
            [self changeTitle];
            [self rightBarButtonItem];
        }
    };
    self.definesPresentationContext = YES;
    menuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    if(sender == self.navigationItem.rightBarButtonItem){
        menuVC.isSort = YES;
    }else{
        menuVC.isSort = NO;
    }
    [self presentViewController:menuVC animated:NO completion:nil];
    
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPShotsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    DRShot *shot = self.tableDataArray[indexPath.row];
    [cell scrollViewInTableView:tableView inView:self.view];
    cell.model = shot;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70 + WIDTH * 5/8.0 + 60;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPShotsTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self loadShotDetailViewControlWithIndexPath:indexPath atView:tableView];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark -- UICollectionViewDataSource &Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPShotsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.collectionViewDataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadShotDetailViewControlWithIndexPath:indexPath atView:collectionView];
}


#pragma mark -- 查看Shot详情
- (void)loadShotDetailViewControlWithIndexPath:(NSIndexPath *)indexPath atView:(id)view
{
    YPShotViewController *shotVC = [[YPShotViewController alloc] init];
    shotVC.hidesBottomBarWhenPushed = YES;
    if (view == _tableView) {
        YPShotsTableViewCell *cell = (id)[_tableView cellForRowAtIndexPath:indexPath];
        shotVC.sImage = cell.shotImageView.image;
        shotVC.shot = self.tableDataArray[indexPath.row];
    }else{
        YPShotsCollectionViewCell *cell = (id)[_collectionView cellForItemAtIndexPath:indexPath];
        shotVC.shot = self.collectionViewDataArray[indexPath.row];
        shotVC.sImage = cell.shotImageView.image;
    }
    [self.navigationController pushViewController:shotVC animated:YES];
}


#pragma mark -- 视差效果
/*滑动视图滑动的时候的回调方法*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==_tableView) {
        // 1.获取可视的cells
        NSArray *cells = [_tableView visibleCells];
        
        for (YPShotsTableViewCell *cell in cells) {
            // 改变cell的位置
            [cell scrollViewInTableView:_tableView inView:self.view];
        }
    }    
}


- (void) endRefreshing {
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
    }
    
    if (_tableView.mj_footer.isRefreshing) {
        [_tableView.mj_footer endRefreshing];
    }
    if (_collectionView.mj_header.isRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
    
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
}

- (void)showLoginDribbble
{
    YPOAuth2Controller *oauthVC = [[YPOAuth2Controller alloc] init];
    oauthVC.hidesBottomBarWhenPushed = YES;
    oauthVC.finishBlock = ^(BOOL finished){
        if (finished) {
            [self loadData:YES changeType:YES];
            [self.maskView removeFromSuperview];
        }
    };
    [self.navigationController pushViewController:oauthVC animated:YES];
}

#pragma mark -- 设置title
- (void)changeTitle
{
    NSArray *titleArray =  @[@"Popular",@"Following",@"Debuts",@"AnimatedGIFs",@"Teams",@"PlayOffs"];
    if([YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX]){
        _titleLabel.text = titleArray[[[YPFactory userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue]];
    }else{
        _titleLabel.text = @"Popular";
    }
    
}

#pragma mark -- cell点击事件代理方法
- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell buketsButtonDidClickedWithShot:(DRShot *)shot shotImage:(UIImage *)image
{
    if ([[YPFactory shareApiClient] isUserAuthorized]) {
        YPAddBuketViewController *addVC = [[YPAddBuketViewController alloc] init];
        addVC.shot = shot;
        addVC.sImage = image;
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"No Account!"];
    }
}

- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell likeButtonDidClickedWithShotId:(NSNumber *)shotId likeState:(BOOL)like
{
    if (like) {
        [[YPFactory shareApiClient] unlikeWithShot:shotId responseHandler:^(DRApiResponse *response) {
            if (response.error) {
                shotsTabCell.likeView.likeButton.isLike = YES;
            }else{
                shotsTabCell.likeView.likeButton.isLike = NO;
            }
        }];
    }else{
        [[YPFactory shareApiClient] likeWithShot:shotId responseHandler:^(DRApiResponse *response) {
            if (response.error) {
                shotsTabCell.likeView.likeButton.isLike = NO;
            }else{
                shotsTabCell.likeView.likeButton.isLike = YES;
            }
        }];
    }
}

- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell playerButtonOrAvatarDidClickedWithUserId:(NSNumber *)userId
{
    YPUserInfoViewController *playerVC = [[YPUserInfoViewController alloc] init];
    playerVC.userID = userId;
    playerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerVC animated:YES];
}

                                        
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
