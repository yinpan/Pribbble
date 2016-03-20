//
//  YPFollowView.m
//  iDesign
//
//  Created by 千锋 on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPFollowButton.h"

static const CGFloat kDefalutViewSpace = 8.0;

@interface YPFollowButton ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation YPFollowButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor themeButtonBlackColor];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/6.0, (CGRectGetHeight(frame) - 16)*0.5 , 16, 16)];
        _imgView.image = [UIImage imageNamed:@"group"];
        [self addSubview:_imgView];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame) + kDefalutViewSpace , (CGRectGetHeight(frame) - 25) * 0.5, 20, 25)];
        _numberLabel.textColor = [UIColor themeBarTinColor];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.text = @"0";
        _numberLabel.font = [UIFont fontTitle];
        _numberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_numberLabel];
        
        _followLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numberLabel.frame) + 4.0, CGRectGetMinY(_numberLabel.frame) + 5, 65, 20)];
        _followLabel.textColor = [UIColor themeFontGrayColor];
        _followLabel.font = [UIFont fontFollowButton];
        [self addSubview:_followLabel];
        
    }
    return self;
}

// 赋值count并重新计算frame
- (void)setNumber:(NSNumber *)number
{
    _number = number;
    if ([number longValue] > 999999) {
        _numberLabel.text = @"999,999+";
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%@",number];
    }
    
    CGRect rect = _numberLabel.frame;

    CGFloat w = [_numberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontStandard]}].width + 5;
    if (w < 20) {
        w = 20;
    }
    CGFloat maxX = CGRectGetWidth(_followLabel.frame) + w + CGRectGetMinX(rect);
    if (maxX + 10 >= CGRectGetWidth(self.frame)) {
        w = CGRectGetWidth(self.frame) - CGRectGetMinX(rect) - 10 - 4.0 - CGRectGetWidth(_followLabel.frame);
    }
    rect.size.width = w;
    _numberLabel.frame = rect;
    
    rect = _followLabel.frame;
    rect.origin.x = CGRectGetMaxX(_numberLabel.frame) + 4.0;
    _followLabel.frame = rect;
    
}


- (void)setIsFollowing:(BOOL)isFollowing
{
    _isFollowing = isFollowing;
    if (isFollowing) {
        _followLabel.text = @"Following";
    }else{
        _followLabel.text = @"Followers";
    }
}


@end
