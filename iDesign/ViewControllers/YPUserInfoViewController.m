
//
//  YPUserInfoViewController.m
//  iDesign
//
//  Created by Yinpan on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPFollowListViewController.h"
#import "YPUserInfoViewController.h"
#import "YPWelcomeViewController.h"
#import "YPShotViewController.h"
#import "YPCollectionViewCell.h"
#import <DRTransactionModel.h>
#import "UIImageView+Util.h"
#import "YPParamManager.h"
#import "YPFollowButton.h"
#import "YPTextButton.h"
#import "YPVCManager.h"
#import "YPUrlButton.h"
#import "AppDelegate.h"
#import "YPOAuth2Controller.h"
#import <DRLink.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>




static const int kUISpaceWidth = 2;

static const int kDefalutUrlButtonTagStartValue = 300;
static const int kDefalutTextButtonTagStartValue = 200;
static const int kDefalutButtonHeight = 40;

static NSString *kCellReuseIdentifier = @"CELL";

@interface YPUserInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) DRAuthority *authority;
@property (nonatomic, strong) YPFollowButton *followersButton;
@property (nonatomic, strong) YPFollowButton *followingButton;
@property (nonatomic, strong) UIButton *isFollowButton;

@property (nonatomic, strong) NSMutableArray *shotsDataArray;
@property (nonatomic, strong) NSMutableArray *likesDataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YPParamManager *paramManager;

@property (nonatomic, strong) UIVisualEffectView *maskView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) YPTextButton *shotButton;
@property (nonatomic, assign) BOOL isLoadingData;

@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation YPUserInfoViewController{
    CGFloat itemWidth;
    BOOL isMoreLike;
    BOOL isMoreShot;
}


- (NSMutableArray *)shotsDataArray
{
    if (!_shotsDataArray) {
        _shotsDataArray = [NSMutableArray array];
    }
    return _shotsDataArray;
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
        subTitle.text = @"Connet Dribbble to see your profile!";
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

- (YPParamManager *)paramManager
{
    if (!_paramManager) {
        _paramManager = [[YPParamManager alloc] init];
    }
    return _paramManager;
}

- (NSMutableArray *)likesDataArray
{
    if (!_likesDataArray) {
        _likesDataArray = [NSMutableArray array];
    }
    return _likesDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isMoreLike = YES;
    isMoreShot = YES;
    [self customNavigationbar];
    [self createUI];
    [self loadData];
}

- (void)loadData
{
    if (_userID) {
        if ([[YPFactory shareApiClient] isUserAuthorized]) {
            [SVProgressHUD showWithStatus:@"Loading"];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadUserShotsWithUserId:_userID];
        });
        [self loadAccountInfoWithUserId:_userID];
    }else{
        [self loadUserInfo];
    }
}

- (void)loadMore
{
    if (_shotButton.isSelected) {
        [self loadUserShotsWithUserId:_userID];
    }else{
        [self loadUserLikesWithUserId:_userID];
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

#pragma mark -- 加载用户投篮
- (void)loadUserShotsWithUserId:(NSNumber *)userID
{
    YPTextButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue];
    if (button.selected) {
        
        if (!isMoreShot) {
            if (!self.shotsDataArray.count) {
                [self showNoShotOrLike:YES];
            }
            return;
        }
        
        int count = (int)self.shotsDataArray.count;
        int page = count/25 + 1;
        
        [[YPFactory shareApiClient] loadShotsWithUser:userID params:@{@"page":@(page),@"per_page":@(25)} responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                NSArray *array = response.object;
                [self.shotsDataArray addObjectsFromArray:array];
                isMoreShot = (array.count == 25);
                [_collectionView reloadData];
                if (self.shotsDataArray.count) {
                    [self hiddenTip];
                }else{
                    [self showNoShotOrLike:YES];
                }
                _isLoadingData = NO;
            }
        }];
    }
}


#pragma mark -- 加载用户喜欢
- (void)loadUserLikesWithUserId:(NSNumber *)userID
{
    YPTextButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue + 1];
    if (button.selected) {
        if (!isMoreLike) {
            if (!self.likesDataArray.count) {
                [self showNoShotOrLike:YES];
            }
            return;
        }
        int count = (int)self.likesDataArray.count;
        int page = count/25 + 1;
        
        [[YPFactory shareApiClient] loadLikesWithUser:userID params:@{@"page":@(page),@"per_page":@(25)} responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                NSArray *array = response.object;
                [self.likesDataArray addObjectsFromArray:array];
                isMoreLike = (array.count == 25);
                [_collectionView reloadData];
                if (self.likesDataArray.count) {
                    [self hiddenTip];
                }else{
                    [self showNoShotOrLike:NO];
                }
                _isLoadingData = NO;
                
            }
        }];
    }
}


#pragma mark -- 加载用户账户信息
- (void)loadAccountInfoWithUserId:(NSNumber *)userID
{
    [[YPFactory shareApiClient] loadAccountWithUser:_userID responseHandler:^(DRApiResponse *response) {
        [SVProgressHUD dismiss];
        self.authority = response.object;
    }];
}


#pragma mark -- 判断是否关注
- (void)checkUserIsFollowing
{
    [[YPFactory shareApiClient] checkFollowingWithUser:_userID responseHandler:^(DRApiResponse *response) {
        if (!response.error) {
            [self changeFollowState:nil];
        }
    }];
}

#pragma mark -- 加载用户信息
- (void)loadUserInfo
{
    if ([[YPFactory shareApiClient] isUserAuthorized]) {
        [SVProgressHUD showWithStatus:@"Loading"];
    }
    [[YPFactory shareApiClient] loadUserInfoWithResponseHandler:^(DRApiResponse *response) {
        [SVProgressHUD dismiss];
        self.authority = response.object;
        DRUser *user = response.object;
        [YPFactory userDefaultsSetObject:user.userId forKey:KEY_USERID];
        self.userID = user.userId;
        // 加载用户shots
        [self loadUserShotsWithUserId:_userID];
    }];
}

#pragma  mark -- 创建视图
- (void)createUI
{

    self.view.backgroundColor = [UIColor themeBackgroundBlack];
    
    
    UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49)];
    baseScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT>675?HEIGHT:675);
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:baseScrollView];
    
    if (HEIGHT > 660) {
        _baseView = self.view;
    }else{
        UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49)];
        if (_isSelf) {
            baseScrollView.contentSize = CGSizeMake(WIDTH, 500);
        }else{
            baseScrollView.contentSize = CGSizeMake(WIDTH, 600);
        }
        baseScrollView.showsVerticalScrollIndicator = NO;
        baseScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:baseScrollView];
        _baseView = baseScrollView;
    }
    
    
    // 创建用户头像ImageView
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 70)/2.0, 35, 70, 70)];
    _userImageView.layer.cornerRadius = 4;
    _userImageView.clipsToBounds = YES;
    [_baseView addSubview:_userImageView];
    
    // 创建用户名label
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_userImageView.frame) + 5, WIDTH, 30)];
    _usernameLabel.font = [UIFont fontUserName];
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    _usernameLabel.textColor = [UIColor themeBarTinColor];
    [_baseView addSubview:_usernameLabel];
    
    // 创建城市lable
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_usernameLabel.frame), WIDTH, 30)];
    _cityLabel.font = [UIFont fontSmall];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    _cityLabel.textColor = [UIColor themeFontGrayColor];
    [_baseView addSubview:_cityLabel];
    
    // 创建关注按钮
    _isFollowButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 100)/2.0, CGRectGetMaxY(_cityLabel.frame) + 5, 100, 30)];
    if (_isSelf) {
        [_isFollowButton setTitle:@"Your Profile" forState:UIControlStateNormal];
        _isFollowButton.backgroundColor = [UIColor themeButtonBlackColor];
        [_isFollowButton setTitleColor:[UIColor themeBarTinColor] forState:UIControlStateNormal];
        _isFollowButton.highlighted = NO;
    }else{
        self.title = @"Player";
        [_isFollowButton setTitle:@"Follow" forState:UIControlStateNormal];
        [_isFollowButton setTitleColor:[UIColor themeBarTinColor] forState:UIControlStateNormal];
        [_isFollowButton setTitleColor:[UIColor themeButtonTintBlackColor] forState:UIControlStateHighlighted];
        _isFollowButton.backgroundColor = [UIColor themeButtonGreenColor];
        [_isFollowButton addTarget:self action:@selector(changeFollowState:) forControlEvents:UIControlEventTouchUpInside];
        [self checkUserIsFollowing];
    }
    _isFollowButton.layer.cornerRadius = CGRectGetHeight(_isFollowButton.frame) * 0.5;
    _isFollowButton.clipsToBounds = YES;
    _isFollowButton.titleLabel.font = [UIFont fontStandard];
    [_baseView addSubview:_isFollowButton];

    
    
    // 粉丝数视图
    _followersButton = [[YPFollowButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_isFollowButton.frame) + 15, (WIDTH - kUISpaceWidth) * 0.5 , 50)];
    _followersButton.isFollowing = NO;
    [_followersButton addTarget:self action:@selector(showFollowList:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_followersButton];
    
    // 正在关注视图
    CGRect rect = _followersButton.frame;
    rect.origin.x = rect.size.width + kUISpaceWidth;
    _followingButton = [[YPFollowButton alloc] initWithFrame:rect];
    _followingButton.isFollowing = YES;
    [_followingButton addTarget:self action:@selector(showFollowList:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_followingButton];
    
    UIView *buttonBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_followersButton.frame) + kUISpaceWidth, WIDTH, kDefalutButtonHeight)];
    buttonBaseView.backgroundColor = [UIColor themeButtonBlackColor];
    [_baseView addSubview:buttonBaseView];
    
    
    NSArray *nameArray = @[@"Shots",@"Likes"];
    for (int i = 0; i < 2; i++) {
        YPTextButton *textButton = [[YPTextButton alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(buttonBaseView.frame) * 0.5 , 0, CGRectGetWidth(buttonBaseView.frame) * 0.5, CGRectGetHeight(buttonBaseView.frame))];
        [textButton setTitle:nameArray[i] forState:UIControlStateNormal];
        [textButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        textButton.tag = kDefalutTextButtonTagStartValue + i;
        [buttonBaseView addSubview:textButton];
        if (i == 0) {
            textButton.selected = YES;
            _shotButton = textButton;
        }else{
            textButton.selected = NO;
        }
        
    }
    
    
    
    
    
    CGRect cloRect = CGRectMake(0, CGRectGetMaxY(buttonBaseView.frame), WIDTH, HEIGHT * 0.18);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat h = HEIGHT * 0.18 - 10;
    itemWidth = h * 4 /3.0;
    layout.itemSize = CGSizeMake( itemWidth, h);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:cloRect collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor themeBackgroundBlack];
    _collectionView.contentInset = UIEdgeInsetsMake( 5, 5 , 5, 5);
    _collectionView.showsHorizontalScrollIndicator = NO;

    [_collectionView registerClass:[YPCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [_baseView addSubview:_collectionView];
    

    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(buttonBaseView.frame) + 15 , WIDTH, 50)];
    [_baseView addSubview:_tipLabel];
    
    _tipLabel.font = [UIFont fontStandard];
    _tipLabel.textColor = [UIColor themeWhiteColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.hidden = YES;
    
    
    if (!_isSelf) {
        NSArray *logoNameArray = @[@"Dribbble",@"WebSite",@"Twitter"];
        NSArray *iconNameArray = @[@"dribbble",@"globe",@"twitter"];
        for (int i = 0; i < 3; i++) {
            YPUrlButton *urlButton = [[YPUrlButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame)  + i * (kDefalutButtonHeight +  kUISpaceWidth), WIDTH, kDefalutButtonHeight)];
            urlButton.type = logoNameArray[i];
            urlButton.logoImageName = iconNameArray[i];
            if (i >0) {
                urlButton.hidden = YES;
            }
            urlButton.tag = kDefalutUrlButtonTagStartValue + i;
            urlButton.backgroundColor = [UIColor themeButtonBlackColor];
            [_baseView addSubview:urlButton];
        }
    }
}

#pragma mark -- 关注按钮点击事件
/** 有参数是按钮点击事件，无参数是无按钮点击方法调用 */
- (void)changeFollowState:(UIButton *)sender
{
    if (![[YPFactory shareApiClient] isUserAuthorized]){
        [SVProgressHUD showWithStatus:@"No Account!"];
        return;
    }
    
    if ([_isFollowButton.titleLabel.text isEqualToString:@"Follow"]) {
        [_isFollowButton setTitle:@"Following" forState:UIControlStateNormal];
        [_isFollowButton setBackgroundColor:[UIColor themeButtonTintBlackColor]];
        if (sender) {
            [[YPFactory shareApiClient] followUserWith:_userID responseHandler:^(DRApiResponse *response) {
                
            }];
        }
    }else{
        [_isFollowButton setTitle:@"Follow" forState:UIControlStateNormal];
        [_isFollowButton setBackgroundColor:[UIColor themeButtonGreenColor]];
        if (sender) {
            [[YPFactory shareApiClient] unFollowUserWith:_userID responseHandler:^(DRApiResponse *response) {
                
            }];
        }
    }
}

#pragma mark - 查看喜欢与作品
- (void)buttonClicked:(UIButton *)sender
{
    if (!sender.selected) {
        for (YPTextButton *button in sender.superview.subviews) {
            button.selected = !button.selected;
        }
        _isLoadingData = NO;
        [self hiddenTip];
        [_collectionView reloadData];
        if ([sender.titleLabel.text isEqualToString:@"Shots"]) {
            if (!_shotsDataArray.count) {
                [self loadUserShotsWithUserId:_userID];
            }
        }else{
            if (!_likesDataArray.count) {
                [self loadUserLikesWithUserId:_userID];
            }
        }
    }
}


#pragma mark -- 绑定视图
- (void)setAuthority:(DRAuthority *)authority
{
    _authority = authority;
    if (!_isSelf) {
        [_userImageView loadImageWithUrlString:_authority.avatarUrl];
    }else{
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_authority.avatarUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [YPFactory userDefaultsSetObject:UIImagePNGRepresentation(_userImageView.image) forKey:KEY_USER_AVATAR];
        }];
    }
    
    _usernameLabel.text = _authority.name;
    _cityLabel.text = _authority.location;
    _followersButton.number = _authority.followersCount?_authority.followersCount:@0;
    _followingButton.number = _authority.followingsCount?_authority.followingsCount:@0;
    
    if(!_isSelf){
         DRLink *links = _authority.links;
        for (int i = 0; i < 3; i++) {
            YPUrlButton *urlButton = (id)[self.view viewWithTag:kDefalutUrlButtonTagStartValue + i];
            if (i == 0) {
                urlButton.url = _authority.htmlUrl;
            }else{
                if (links.web) {
                    if (i == 1) {
                        urlButton.url = links.web;
                    }
                    if (links.twitter && i==2) {
                        urlButton.url = links.twitter;
                    }
                }else{
                    if (links.twitter && i==2) {
                        YPUrlButton *button = (id)[self.view viewWithTag:kDefalutUrlButtonTagStartValue + 1];
                        urlButton.center = button.center;
                        urlButton.url = links.twitter;
                    }
                }
            }
        }
    }
}

#pragma mark -- 查看关注与粉丝列表
- (void)showFollowList:(UIButton *)sender
{
    YPFollowListViewController *listVC = [[YPFollowListViewController alloc] init];
    if (sender == _followingButton) {
        listVC.isFollowers =  NO;
        listVC.followCount = _authority.followingsCount;
    }else{
        listVC.isFollowers = YES;
        listVC.followCount = _authority.followersCount;
    }
    listVC.avatarImage = _userImageView.image;
    listVC.userName = _usernameLabel.text;
    listVC.userId = self.userID;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark -- UICollectionViewDataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    UIButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue];
    // shots处于选中状态
    if (button.selected) {
        return self.shotsDataArray.count;
    }
    return self.likesDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    YPTextButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue];
    cell.isShot = button.selected;
    if (button.selected) {
        cell.model = [self.shotsDataArray objectAtIndex:indexPath.row];
    }else{
        cell.model = [self.likesDataArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPTextButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue];
    YPShotViewController *shotVC = [[YPShotViewController alloc] init];
    
    if (button.selected) {
        shotVC.shot = [self.shotsDataArray objectAtIndex:indexPath.row];
    }else{
        DRTransactionModel *model = [self.likesDataArray objectAtIndex:indexPath.row];
        shotVC.shot = model.shot;
    }
    YPCollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    shotVC.sImage = cell.imageView.image;
    shotVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shotVC animated:YES];
}


#pragma mark -- logout
- (void)logout
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Are you sure quit?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[YPFactory shareApiClient] logout];
        [YPFactory removeUserPeferences];
        [self maskView];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 清除缓存
- (void)clearWebCach
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Are you sure clear caches?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self removeCachs];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)removeCachs
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *cachArray =  [fm contentsOfDirectoryAtPath:path error:nil];
    //遍历arr,对每个文件进行处理
    for (NSString* fileName in cachArray) {
        [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
    }
    [SVProgressHUD showSuccessWithStatus:@"Finished!"];
}

- (void)showLoginDribbble
{
    YPOAuth2Controller *oauthVC = [[YPOAuth2Controller alloc] init];
    __weak typeof(self) weakSelf = self;
    oauthVC.finishBlock = ^(BOOL finished){
        if (finished) {
            [weakSelf loadUserInfo];
            _tipLabel.hidden = YES;
            weakSelf.shotButton.selected =YES;
            YPTextButton *button = (id)[self.view viewWithTag:kDefalutTextButtonTagStartValue + 1];
            button.selected = NO;
            [weakSelf.maskView removeFromSuperview];
            weakSelf.maskView = nil;
        }
    };
    oauthVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oauthVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};
    [super viewWillAppear:animated];
    
    if (![[YPFactory shareApiClient] isUserAuthorized] && _isSelf) {
        [self maskView];
    }else{
        if (!_userImageView.image) {
            [self loadData];
        }
        if ([[YPFactory shareApiClient] isUserAuthorized] && _isSelf) {
            self.navigationItem.rightBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"out" target:self action:@selector(logout)];
            self.navigationItem.leftBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"clear" target:self action:@selector(clearWebCach)];
            if (_maskView) {
                [_maskView removeFromSuperview];
                _maskView = nil;
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width;
    if (_shotButton.isSelected) {
        width = _shotsDataArray.count * (itemWidth + 5) + 5 - WIDTH;
    }else{
        width = _likesDataArray.count * (itemWidth + 5) + 5 - WIDTH;
    }
    if (_collectionView.contentOffset.x > width && !_isLoadingData) {
        _isLoadingData = YES;
        [self loadMore];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)showNoShotOrLike:(BOOL)isShot
{
    if (isShot) {
        self.tipLabel.text = @"no shot ☺️";
        self.tipLabel.hidden = NO;
    }else{
        self.tipLabel.text = @"no like 😅";
        self.tipLabel.hidden = NO;
    }
}

- (void)hiddenTip
{
    if (_tipLabel) {
        _tipLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
