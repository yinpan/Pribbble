//
//  YPLikeButton.m
//  iDesign
//
//  Created by 千锋 on 16/3/10.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPLikeButton.h"


@interface YPLikeButton ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *act;

@end
@implementation YPLikeButton



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self unLikeState];
        [self setTitle:@"like" forState:UIControlStateNormal];
        [self addActivityIndicatorView];
        [self addTarget:self action:@selector(changeLikeState) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setShotId:(NSNumber *)shotId{
    _shotId = shotId;
    [self checkIsLike];
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (_isLoading) {
        self.enabled = NO;
        _loadingView.hidden = NO;
        [self unLikeState];
        [_act startAnimating];
    }else{
        self.enabled = YES;
        _loadingView.hidden = YES;
        [_act stopAnimating];
    }
}

- (void)setIsLike:(BOOL)isLike
{
    _isLike = isLike;
    self.isLoading = NO;
    if (_isLike) {
        [UIView animateWithDuration:0.5 animations:^{
            [self likeState];
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self unLikeState];
        } completion:nil];
    }
}

- (void)unLikeState
{
    self.layer.borderColor = [UIColor themeFontGrayColor].CGColor;
    [self setTitle:@"like" forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"like_gray"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor themeFontGrayColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor themeWhiteColor];
}

- (void)likeState
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
    [self setTitle:@"liked" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor themeWhiteColor] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor themeColor];
}

/** 添加加载指示器 */
- (void)addActivityIndicatorView
{
    _loadingView = [[UIView alloc] initWithFrame:self.bounds];
    _loadingView.backgroundColor = [[UIColor themeWhiteColor] colorWithAlphaComponent:0.3];
    _loadingView.hidden = YES;
    [self addSubview:_loadingView];
    
    _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetHeight(self.frame) * 0.8, CGRectGetHeight(self.frame) *0.8)];
    _act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _act.center = _loadingView.center;
    [_loadingView addSubview:_act];
}

- (void)checkIsLike
{
    if(![[YPFactory shareApiClient] isUserAuthorized]) return;
    self.isLoading = YES;
    [[YPFactory shareApiClient] checkLikeWithShot:_shotId responseHandler:^(DRApiResponse *response) {
        if (response.object) {
            self.isLike = YES;
        }else{
            self.isLike = NO;
        }
    }];
}

- (void)changeLikeState
{
    if (![[YPFactory shareApiClient] isUserAuthorized]) {
        [SVProgressHUD showInfoWithStatus:@"No Account!"];
        return;
    }
    if (_isLoading) {
        return;
    }
    self.isLoading = YES;
    if (!_isLike) {
        [[YPFactory shareApiClient] likeWithShot:_shotId responseHandler:^(DRApiResponse *response) {
            if (response.error) {
                self.isLike = NO;
            }else{
                self.isLike = YES;
                [self.delegate likeButton: self likeState:YES];
            }
        }];
    }else{
        [[YPFactory shareApiClient] unlikeWithShot:_shotId responseHandler:^(DRApiResponse *response) {
            if (response.error) {
                self.isLike = YES;
            }else{
                self.isLike = NO;
                [self.delegate likeButton: self likeState:NO];
            }
        }];
    }
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.x = 25;
    contentRect.size.width -= 25;
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.x = 7;
    contentRect.origin.y = 4;
    contentRect.size.width = 16;
    contentRect.size.height = 16;
    return contentRect;
}




@end
