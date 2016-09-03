//
//  YPShotHeaderView.h
//  iDesign
//
//  Created by Yinpan on 16/3/11.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPShotHeaderView;
@protocol YPShotHeaderViewDelegate <NSObject>

- (void)shotHeaderView:(YPShotHeaderView *)shotHeaderView showPlayerWithShotId:(NSNumber *)shotId;

@end
@interface YPShotHeaderView : UIView

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *playerImageView;
@property (nonatomic, strong) UIButton *playerNameButton;
@property (nonatomic, strong) UILabel *shotTitleLabel;
@property (nonatomic, weak)id<YPShotHeaderViewDelegate> delegate;

@end
