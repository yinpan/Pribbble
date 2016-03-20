//
//  YPLikeView.m
//  iDesign
//
//  Created by 千锋 on 16/3/11.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPLikeView.h"

@interface YPLikeView ()<YPLikeButtonDelegate>

@end
@implementation YPLikeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _likeButton = [[YPLikeButton alloc] initWithFrame:CGRectMake(15, 15, 60, 25)];
        _likeButton.delegate = self;
        [self addSubview:_likeButton];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 15, 30, 25)];
        imageView.image = [UIImage imageNamed:@"like_count_bg"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 50, 25)];
        _likeCountLabel.font = [UIFont fontminiStandard];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
        _likeCountLabel.textColor = [UIColor themeFontGrayColor];
        [self addSubview:_likeCountLabel];
        
        _buketButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 70 - 15, 15, 70, 25)];
        [self addSubview:_buketButton];
        [_buketButton setTitle:@"+ Bukets" forState:UIControlStateNormal];
        _buketButton.titleLabel.font = [UIFont fontminiStandard];
        [_buketButton setTitleColor:[UIColor colorWithRed:0 green:0.38 blue:0.51 alpha:1] forState:UIControlStateNormal];
        _buketButton.layer.cornerRadius = 3;
        _buketButton.layer.borderColor = [UIColor colorWithRed:0 green:0.38 blue:0.51 alpha:1].CGColor;
        _buketButton.layer.borderWidth = 1;
        
        
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
        layer.backgroundColor = [UIColor themeCellGrayBackground].CGColor;
        [self.layer addSublayer:layer];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        _likeButton = [[YPLikeButton alloc] initWithFrame:CGRectMake(15, 15, 60, 25)];
        [self addSubview:_likeButton];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 15, 40, 25)];
        imageView.image = [UIImage imageNamed:@"like_count_bg"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 60, 25)];
        _likeCountLabel.font = [UIFont fontminiStandard];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
        _likeCountLabel.textColor = [UIColor themeFontGrayColor];
        _likeCountLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_likeCountLabel];
        
        _buketButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 70 - 15, 15, 70, 25)];
        [self addSubview:_buketButton];
        [_buketButton setTitle:@"+ Bukets" forState:UIControlStateNormal];
        _buketButton.titleLabel.font = [UIFont fontminiStandard];
        [_buketButton setTitleColor:[UIColor colorWithRed:0 green:0.38 blue:0.51 alpha:1] forState:UIControlStateNormal];
        _buketButton.layer.cornerRadius = 5;
        _buketButton.layer.borderColor = [UIColor colorWithRed:0 green:0.38 blue:0.51 alpha:1].CGColor;
        _buketButton.layer.borderWidth = 1;
        
        
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
        layer.backgroundColor = [UIColor themeCellGrayBackground].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}

- (void)likeButton:(YPLikeButton *)likeButton likeState:(BOOL)like
{
    int count = [_likeCountLabel.text intValue];
    if (like) {
        count += 1;
    }else{
        count -= 1;
    }
    _likeCountLabel.text = [NSString stringWithFormat:@"%d",count];
}




@end
