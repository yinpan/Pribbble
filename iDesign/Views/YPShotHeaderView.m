//
//  YPShotHeaderView.m
//  iDesign
//
//  Created by 千锋 on 16/3/11.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPShotHeaderView.h"



@implementation YPShotHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self addSubview:_playerImageView];
        _playerImageView.layer.cornerRadius = 20;
        _playerImageView.userInteractionEnabled = YES;
        _playerImageView.layer.masksToBounds = YES;
        [self addSubview:_playerImageView];
        
        _shotTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, WIDTH - 60 - 40, 25)];
        [self addSubview:_shotTitleLabel];
        _shotTitleLabel.font = [UIFont fontStandard];
        
        _playerNameButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 30, WIDTH - 60 - 15, 25)];
        
        [_playerNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _playerNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_playerNameButton setTitleColor:[UIColor themeBackgroundBlack] forState:UIControlStateHighlighted];
        [_playerNameButton setTitleColor:[UIColor colorWithRed:0 green:0.38 blue:0.51 alpha:1] forState:UIControlStateNormal];
        [self addSubview:_playerNameButton];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 30, 5, 25, 25)];
        _timeLabel.font = [UIFont fontminiStandard];
        _timeLabel.textColor = [UIColor themeFontGrayColor];
        [self addSubview:_timeLabel];
        
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
        layer.backgroundColor = [UIColor themeCellGrayBackground].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}


@end
