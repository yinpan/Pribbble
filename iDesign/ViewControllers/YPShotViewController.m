//
//  YPShotViewController.m
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPShotViewController.h"
#import "YPShotCommentCell.h"
#import "AFHTTPSessionManager+Util.h"
#import "YPShotView.h"
#import "YPParamManager.h"
#import "YPShotButton.h"
#import "YPUserInfoViewController.h"
#import "YPCommentBodyView.h"
#import "YPCommentView.h"
#import "YPShowShotViewController.h"
#import <YLImageView.h>
#import "YPAddBuketViewController.h"
#import <MJRefreshAutoNormalFooter.h>




static NSString * const kCellReuseIdentifier = @"CELL";

@interface YPShotViewController ()<UITableViewDataSource,UITableViewDelegate,YPShotButtonDelegate,YPCommentBodyViewDelegate,UITextFieldDelegate,YPCommentViewDelegate,YPShotViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YPShotView *shotView;
@property (nonatomic, strong) UIImageView *playerImageView;
@property (nonatomic, strong) UILabel *playerNameLabel;
@property (nonatomic, strong) UILabel *shotNameLabel;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) NSMutableArray *attachmentsArray;
@property (nonatomic, strong) YPCommentView *commentView;

@property (nonatomic, strong) YPParamManager *paramManager;
@property (nonatomic, assign) BOOL isHaveAttachments;

@property (nonatomic, assign) BOOL isNotMore;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation YPShotViewController{
    CGFloat tempDy;
    CGFloat tableHeaderHeight;
}

- (NSMutableArray *)attachmentsArray
{
    if (!_attachmentsArray) {
        _attachmentsArray = [NSMutableArray array];
    }
    return _attachmentsArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

- (YPParamManager *)paramManager{
    if (!_paramManager) {
        _paramManager = [[YPParamManager alloc] initWithStartPage:1 perPageNumber:30];
    }
    return _paramManager;
}

- (YPCommentView *)commentView
{
    if (!_commentView) {
        _commentView = [[YPCommentView alloc] initWithFrame:self.view.bounds];
        _commentView.avatarImageView.image = [UIImage imageWithData:[YPFactory userDefaultsObjectForKey:KEY_USER_AVATAR]];
        _commentView.textField.delegate = self;
        _commentView.delegate = self;
//        [self.view addSubview:_commentView];
    }
    return _commentView;
}

#pragma mark -- 页面UI加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createUI];
    [self createUserInfoView];
    [self loadData];
    // 注册观察者
    [self addobserver];
    
}


- (void)createUserInfoView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    view.backgroundColor = [[UIColor themeShotPlayerViewBlackColor] colorWithAlphaComponent:0.95];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayerInfo:)];
    [view addGestureRecognizer:tap];
    [self.view addSubview:view];
    
    
    _playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    _playerImageView.layer.cornerRadius = 5;
    _playerImageView.clipsToBounds = YES;
    [view addSubview:_playerImageView];
    
    _shotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerImageView.frame) + 20, CGRectGetMinY(_playerImageView.frame), WIDTH - CGRectGetMaxX(_playerImageView.frame) - 20, 30)];
    _shotNameLabel.font = [UIFont fontTitle];
    _shotNameLabel.textColor = [UIColor themeBarTinColor];
    [view addSubview:_shotNameLabel];
    
    UILabel *byLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shotNameLabel.frame), CGRectGetMaxY(_shotNameLabel.frame), 20, 20)];
    byLabel.text = @"by";
    byLabel.font = [UIFont fontminiStandard];
    byLabel.textColor = [UIColor themeFontGrayColor];
    [view addSubview:byLabel];
    
    _playerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shotNameLabel.frame) + 20, CGRectGetMaxY(_shotNameLabel.frame), CGRectGetWidth(_shotNameLabel.frame) - 20, 20)];
    _playerNameLabel.font = [UIFont fontminiStandard];
    _playerNameLabel.textColor = [UIColor themeColor];
    [view addSubview:_playerNameLabel];
}

- (void)createUI
{
    
    self.title = @"Shot";
//
//    
//    self.navigationItem.rightBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"write_comment" target:self action:@selector(writeComment)];
    
    self.navigationItem.rightBarButtonItem = [YPFactory createBarButtonItemWithImageName:@"globe" target:self action:@selector(showInWeb)];
    
    self.view.backgroundColor = [UIColor themeWhiteColor];
    if ([_shot.attachmentsCount intValue]) {
        _isHaveAttachments = YES;
    }
    _tableView = [[ UITableView alloc] initWithFrame:CGRectMake(0, 80, WIDTH, HEIGHT - 64 - 80) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.clipsToBounds = NO;
    _tableView.layer.masksToBounds = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"YPShotCommentCell" bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.view addSubview:_tableView];
    
    // 创建表格头视图

    tableHeaderHeight = WIDTH * 3 / 4.0 + 60;
    if ([_shot.attachmentsCount intValue]) {
        tableHeaderHeight += 90;
    }
    _shotView = [[YPShotView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, tableHeaderHeight)];
    _shotView.delegate = self;
    _shotView.imageView.image = [YPFactory createBlurImage:_sImage blurRadius:4];
    _shotView.model = _shot;
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:_shotView.bounds];
    [headerView addSubview:_shotView];
    _tableView.tableHeaderView = headerView;
}

- (void)loadData
{
    if (_isNotMore) {
        return;
    }
    _shotView.model = _shot;
    _playerNameLabel.text = _shot.user.name;
    _shotNameLabel.text = _shot.title;
    [_playerImageView loadImageWithUrlString:_shot.user.avatarUrl];
    if ([_shot.attachmentsCount intValue]) {
        [_tableView reloadData];
        [[YPFactory shareApiClient] loadAccountWithUser:_shot.shotId responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                [self.attachmentsArray addObject:response.object];
                [_tableView reloadData];
            }
        }];
    }
    [self loadComment:YES];
}

- (void)loadComment:(BOOL)isRefresh
{
    if (isRefresh) {
        [self.dataArray removeAllObjects];
        [self.paramManager reset];
    }
    [[YPFactory shareApiClient] loadCommentsWithShot:_shot.shotId params:[self.paramManager nowParams] responseHandler:^(DRApiResponse *response) {
        if (!response.error) {
            NSArray *array = response.object;
            [self.dataArray addObjectsFromArray:array];
            [self reloadCellHeight];
            [_tableView reloadData];
            _isNotMore = !(array.count == 30);
            [self.paramManager next];
            [self addFooterLoadMore];
        }
    }];
}

- (void)addFooterLoadMore
{
    if (!_isNotMore) {
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadComment:NO];
        }];
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



#pragma mark -- 计算cell的高度
- (void) reloadCellHeight
{
    NSArray *array = self.dataArray;
    if (array.count) {
        NSMutableArray *hArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            DRComment *comment = array[i];
            NSString *string = comment.body;
            CGFloat height = [self cellHeightWithString:string];
            [hArray addObject:[NSString stringWithFormat:@"%f",height]];
        }
        self.heightArray = hArray;
    }
}

- (CGFloat)cellHeightWithString:(NSString *)string
{
    NSAttributedString *newStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    // 重新计算label大小
    CGSize size = [newStr.string boundingRectWithSize:CGSizeMake(WIDTH - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontComment]} context:nil].size;
    return  size.height + 45 + 15;
}

#pragma mark -- 跳转显示作者详情页面
- (void) showPlayerInfo:(UITapGestureRecognizer *)sender
{
    [self showPlayerInfoViewControllerWithUserId:_shotView.model.user.userId];
}

- (void) showPlayerInfoViewControllerWithUserId:(NSNumber *)userId
{
    YPUserInfoViewController *userVC = [[YPUserInfoViewController alloc] init];
    userVC.userID = userId;
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPShotCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.model =  self.dataArray[indexPath.row];
    cell.commentBodyView.delegate = self;
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor themeWhiteColor];
    }else{
        cell.backgroundColor = [[UIColor themeCellGrayBackground] colorWithAlphaComponent:0.5];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] doubleValue];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
    view.backgroundColor = [[UIColor themeFontGrayWhiteColor] colorWithAlphaComponent:0.8];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 15, 25)];
    label.font = [UIFont fontStandard];
    label.textColor = [[UIColor themeWhiteColor] colorWithAlphaComponent:0.8];
    [view addSubview:label];

    label.text = [NSString stringWithFormat:@"Commets %@",_shot.commentsCount];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[YPFactory shareApiClient] isUserAuthorized]) {
//        YPShotCommentCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
//        cell.selected = NO;
//        self.commentView.commentId = cell.model.commentId;
//        self.commentView.userAccount = cell.model.user.name;
//        [self.commentView up];
//        [self tableviewChangeFrame];
//        [self.commentView.textField becomeFirstResponder];
//    }else{
//        [SVProgressHUD showInfoWithStatus:@"No Account!"];
//    }
    YPShotCommentCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}



- (void)shotButton:(YPShotButton *)shotButton likeStateChange:(BOOL)isLike
{
    if (isLike) {
        [[YPFactory shareApiClient] likeWithShot:_shot.shotId responseHandler:^(DRApiResponse *response) {
            
        }];
    }else{
        [[YPFactory shareApiClient] unlikeWithShot:_shot.shotId responseHandler:^(DRApiResponse *response) {

        }];
    }
}

#pragma mark -- commentView 事件




#pragma mark -- tableView跟随commentView事件
- (void)tableviewChangeFrame
{
    CGRect rect = _tableView.frame;
    if (_commentView) {
        rect.origin.y -= self.commentView.baseView.frame.size.height;
        [UIView  animateWithDuration:0.5 animations:^{
            _tableView.frame = rect;
        } completion:nil];
    }else{
        rect.origin.y += HEIGHT - CGRectGetMaxY(_tableView.frame) - 64;
        [UIView  animateWithDuration:0.5 animations:^{
            _tableView.frame = rect;
        } completion:nil];
    }
}

#pragma mark -- YPCommentBodyViewDelegate
- (void)commentBodyView:(YPCommentBodyView *)commentView showInfoWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

- (void)commentBodyView:(YPCommentBodyView *)commentView showUserInfoWithUserId:(NSNumber *)userId
{
    [self showPlayerInfoViewControllerWithUserId:userId];
}

#pragma mark -- 评论

- (void)commentView:(YPCommentView *)commentView postCommentWithBody:(NSString *)string commentId:(NSNumber *)commentId
{
    [self.commentView.textField resignFirstResponder];
    if ([string isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Cannot be null"];
    }else{
        CGRect rect = _tableView.frame;
        rect.origin.y += HEIGHT - CGRectGetMaxY(_tableView.frame) - 64;
        [self.commentView downAnimation:^{
                                _tableView.frame = rect;
                            } Finished:^{
                                [self.commentView removeFromSuperview];
                                _commentView = nil;
        }];
        NSString *bodyString = [NSString stringWithFormat:@"<p>%@</p>",string];
        if (commentId) {
            [[YPFactory shareApiClient] updateCommentWith:commentId forShot:_shot.shotId withBody:bodyString responseHandler:^(DRApiResponse *response) {
                if (response.error) {
                    [SVProgressHUD showErrorWithStatus:@"Comment fail"];
                }else{
                    [self loadComment:YES];
                    [SVProgressHUD showSuccessWithStatus:@"Comments success"];
                }
            }];
            
        }else{
            [[YPFactory shareApiClient] uploadCommentWithShot:_shot.shotId withBody:bodyString responseHandler:^(DRApiResponse *response) {
                if (response.error) {
                    [SVProgressHUD showErrorWithStatus:@"Comment fail"];
                }else{
                    [self loadComment:YES];
                    [SVProgressHUD showSuccessWithStatus:@"Comments success"];
                }
            }];
        }
    }
}


- (void)commentViewCancelPostMsg
{
    [self.commentView.textField resignFirstResponder];
    [self.commentView downAnimation:^{
        CGRect rect = _tableView.frame;
        rect.origin.y = HEIGHT - CGRectGetHeight(_tableView.frame) - 64;
        _tableView.frame = rect;
    } Finished:^{
        [self.commentView removeFromSuperview];
        _commentView = nil;
    }];
}

- (void)changeCommentAndTableViewFrameWithOffsetY:(CGFloat)offsetY
{
    CGRect tableRect = _tableView.frame;
    CGRect commentRect = self.commentView.frame;
//    CGFloat dy = offsetY - (HEIGHT - 64 - CGRectGetMaxY(_tableView.frame));
    tableRect.origin.y -= offsetY;
    commentRect.origin.y -= offsetY;
    [UIView animateWithDuration:0.5 animations:^{
        _tableView.frame = tableRect;
        self.commentView.frame = commentRect;
    }];
}


#pragma mark -- 监听键盘状态
- (void)addobserver
{
    // 添加两个通知观察者分别观察键盘出现和键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveDown:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void) moveUp:(NSNotification *) sender {
    NSValue *val = sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    tempDy = val.CGRectValue.size.height;
    [self changeCommentAndTableViewFrameWithOffsetY:tempDy];
}

- (void) moveDown:(NSNotification *) sender {
    [self changeCommentAndTableViewFrameWithOffsetY: -tempDy];
}


#pragma mark -- commentViewTextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y<=0) {
        _shotView.addHeith = - y;
    }
}


#pragma mark -- show Shot
- (void)shotImageViewDidTap:(UIImageView *)shotImageView
{
    YPShowShotViewController *showVC = [[YPShowShotViewController alloc] init];
    CGRect rect = [_shotView.imageView convertRect:_shotView.imageView.frame toView:self.view];
    rect.origin.y += 64;
    showVC.originRect = &(rect);
    showVC.shotData = UIImagePNGRepresentation(_shotView.imageView.image);
    self.definesPresentationContext = YES;
    showVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:showVC animated:NO completion:nil];
}

- (void)shotAttachmentImageViewWithURL:(NSString *)url
{
    YPShowShotViewController *showVC = [[YPShowShotViewController alloc] init];
    showVC.url = url;
    self.definesPresentationContext = YES;
    showVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:showVC animated:NO completion:nil];
}

- (void)addBuketEvent
{
    if ([[YPFactory shareApiClient] isUserAuthorized]) {
        YPAddBuketViewController *addVC = [[YPAddBuketViewController alloc] init];
        addVC.sImage = _shotView.imageView.image;
        addVC.shot = _shot;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"No Account!"];
    }
}

- (void)writeComment
{
    if ([[YPFactory shareApiClient] isUserAuthorized]) {
        if (self.commentView.isUp) {
            [self commentViewCancelPostMsg];
        }else{
            self.commentView.commentId = nil;
            [self.commentView up];
            [self tableviewChangeFrame];
            [self.commentView.textField becomeFirstResponder];
        }
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"No Account!"];
    }
}

- (void)showInWeb
{
    NSLog(@"%@",_shot);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shot.htmlUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
