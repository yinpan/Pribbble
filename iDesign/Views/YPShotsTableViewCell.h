//
//  YPShotsTableViewCell.h
//  iDesign
//
//  Created by Yinpan on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPLikeView.h"



@class DRShot,YPShotsTableViewCell,YPShotHeaderView,YLImageView;

@protocol YPShotsTableViewCellDelegate <NSObject>

/** 喜欢按钮点击事件 */
- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell likeButtonDidClickedWithShotId:(NSNumber *)shotId likeState:(BOOL)like;

/** 收藏按钮点击事件 */
- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell buketsButtonDidClickedWithShot:(DRShot *)shot shotImage:(UIImage *)image;

/** 用户按钮或头像点击事件 */
- (void)shotsTableViewCell:(YPShotsTableViewCell *)shotsTabCell playerButtonOrAvatarDidClickedWithUserId:(NSNumber *)userId;


@end
@interface YPShotsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YLImageView *shotImageView;
@property (nonatomic, strong) DRShot *model;
@property (nonatomic, weak) id<YPShotsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet YPLikeView *likeView;
@property (weak, nonatomic) IBOutlet YPShotHeaderView *shotHeaderView;

/** 让celldeimage在 tableView 中滑动 */
- (void)scrollViewInTableView:(UITableView *)tableView inView:(UIView *)view;

@end
