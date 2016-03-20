//
//  YPShotsTableViewCell.m
//  iDesign
//
//  Created by 千锋 on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPShotsTableViewCell.h"
#import <DRShot.h>
#import "YPShotHeaderView.h"
#import <SDWebImageManager.h>
#import <YLImageView.h>
#import <YLGIFImage.h>
#import <UIImageView+WebCache.h>




@interface YPShotsTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;


@end
@implementation YPShotsTableViewCell

- (void)awakeFromNib {
//
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor themeButtonTintBlackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayerDetailInfo)];
    [_shotHeaderView.playerImageView addGestureRecognizer:tap];
    
    [_shotHeaderView.playerNameButton addTarget:self action:@selector(showPlayerDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [_likeView.likeButton addTarget:self action:@selector(changeLikeState) forControlEvents:UIControlEventTouchUpInside];
    [_likeView.buketButton addTarget:self action:@selector(addShotToBukets) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showPlayerDetailInfo
{
    [self.delegate shotsTableViewCell:self playerButtonOrAvatarDidClickedWithUserId:_model.user.userId];
}
- (void)changeLikeState
{
    _likeView.likeButton.isLoading = YES;
    [self.delegate shotsTableViewCell:self likeButtonDidClickedWithShotId:_model.shotId likeState:_likeView.likeButton.isLike];
}
- (void)addShotToBukets
{
    [self.delegate shotsTableViewCell:self buketsButtonDidClickedWithShot:_model shotImage:_shotImageView.image];
}

- (void)setModel:(DRShot *)model
{
    _model = model;
    if ([_model.images.normal hasSuffix:@".gif"]) {
        [_shotImageView sd_setImageWithURL:[NSURL URLWithString:_model.images.normal] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _shotImageView.image = [YLGIFImage imageWithData:UIImagePNGRepresentation(image)];
        }];
    }else{
        [_shotImageView loadImageWithUrlString:_model.images.normal];
    }
    
    
    
    _shotHeaderView.timeLabel.text = [YPFactory timeStatusWithCreateTime:_model.updatedAt];
    [_shotHeaderView.playerNameButton setTitle:model.user.username forState:UIControlStateNormal];
    _shotHeaderView.shotTitleLabel.text = model.title;
    [_shotHeaderView.playerImageView loadImageWithUrlString:_model.user.avatarUrl];
    _gifImageView.hidden = ![self isContainGif];
    _likeView.likeButton.shotId = model.shotId;
    _likeView.likeCountLabel.text = [NSString stringWithFormat:@"%@",_model.likesCount];
}

/** 判断是否是gif图片 */

- (BOOL) isContainGif
{
    if ([_model.images.normal containsString:@".gif"]) {
        return YES;
    }
    if ([_model.images.normal containsString:@".gif"]) {
        return YES;
    }
    return NO;
}

- (void)scrollViewInTableView:(UITableView *)tableView inView:(UIView *)view
{
    // 1.找出cell在ViewController的view中的位置。将cell相对于tableView的frame转换成相对于view的frame
    CGRect inSuperRect = [tableView convertRect:self.frame toView:view];
    
    // 2.计算出cell的起始位置相对于 View的中线的差值
    CGFloat dis = CGRectGetMidY(view.frame) - CGRectGetMinY(inSuperRect);
    
    // 2.5 计算出imageView的高度和cell的高度差
    CGFloat dif = CGRectGetHeight(self.shotImageView.frame) - CGRectGetHeight(self.frame) + 130;
    
    // 3.计算出imageView应该移动的距离。
    CGFloat moveDis = dis / CGRectGetHeight(view.frame) * dif;
    
    // 4.让image移动
    CGRect imgRect = self.shotImageView.frame;
    imgRect.origin.y = - 0.8 * dif + moveDis;
    self.shotImageView.frame = imgRect;
}


- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 4;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
