//
//  YPShotButton.m
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPShotButton.h"



@interface YPShotButton ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YPShotButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(frame) * 0.5 - 8, 16, 16)];
        [self addSubview:_iconImageView];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 2, CGRectGetHeight(frame) * 0.5 - 10, CGRectGetWidth(frame) * 0.26, 20)];
        _countLabel.font = [UIFont fontSmall];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor themeWhiteColor];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_countLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_countLabel.frame), CGRectGetMinY(_countLabel.frame), CGRectGetWidth(frame) - CGRectGetMaxX(_countLabel.frame), 20)];
        _textLabel.textColor = [UIColor themeCellGrayBackground];
        _textLabel.font = [UIFont fontminiStandard];
        [self addSubview:_textLabel];
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)setType:(YPShotButtonType)type
{
    switch (type) {
        case YPShotButtonTypeView:{
            _iconImageView.image = [UIImage imageNamed:@"view"];
            _textLabel.text = @"Views";
            break;
        }
        case YPShotButtonTypeComment:{
            _iconImageView.image = [UIImage imageNamed:@"comment"];
            _textLabel.text = @"Comments";
            CGRect rect = _countLabel.frame;
            rect.size.width -= 5;
            _countLabel.frame = rect;
            CGRect textRect = _textLabel.frame;
            textRect.origin.x -= 5;
            textRect.size.width +=5;
            _textLabel.frame = textRect;
            break;
        }
        case YPShotButtonTypeLike:{
            if (_isLike) {
                _iconImageView.image = [UIImage imageNamed:@"like"];
            }else{
                _iconImageView.image = [UIImage imageNamed:@"ulike"];
            }
            _textLabel.text = @"Likes";
            self.backgroundColor = [UIColor themeFontGrayColor];
            [self addTarget:self action:@selector(changeLikeState) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            break;
    }
}

- (void)setIsLike:(BOOL)isLike
{
    _isLike = isLike;
    _iconImageView.image = [UIImage imageNamed:@"filled_like"];
}

- (void)changeLikeState
{
    _isLike = !_isLike;
    if (_isLike) {
        _countLabel.text = [NSString stringWithFormat:@"%d",[_countLabel.text intValue] + 1];
        _iconImageView.image = [UIImage imageNamed:@"filled_like"];
        [UIView animateWithDuration:0.4 animations:^{
            _iconImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView animateWithDuration:0.6 animations:^{
            _iconImageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else{
        _iconImageView.image = [UIImage imageNamed:@"like_outline"];
        _countLabel.text = [NSString stringWithFormat:@"%d",[_countLabel.text intValue] - 1];
    }
    [_delegate shotButton:self likeStateChange:_isLike];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
