//
//  YPShotImageView.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPShotCellView.h"

@interface YPShotCellView ()

@property (nonatomic, strong) UIImageView *shotImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *gifImageView;

@end

@implementation YPShotCellView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        CGRect frame = CGRectMake(0, 0, WIDTH * 0.5 , WIDTH * 0.5 * 3 /4.0);
        _shotImageView = [[UIImageView alloc] initWithFrame:frame];
        _shotImageView.hidden = YES;
        [self addSubview:_shotImageView];
        
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 30 - 10, 5, 30, 20)];
        
        [self addSubview:_gifImageView];
        
        _gifImageView.image = [UIImage imageNamed:@"gif"];
        _gifImageView.hidden = YES;
        
        
        
        _maskView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_maskView];
        _maskView.backgroundColor = [[UIColor themeCellGrayBackground] colorWithAlphaComponent:0.5];
        _maskView.hidden = YES;
        
//        [self addTarget:self action:@selector(showMask) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(hiddenMask) forControlEvents:UIControlEventTouchCancel];
        [self addTarget:self action:@selector(showShotView) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}




- (void)setModel:(DRShot *)model
{
    _model = model;
    
    if (_model) {
        _shotImageView.hidden = NO;
        [_shotImageView loadImageWithUrlString:_model.images.normal];
        if ([_model.images.normal hasSuffix:@".gif"]) {
            _gifImageView.hidden = NO;
        }else{
            _gifImageView.hidden = YES;
        }
    }else{
        _shotImageView.hidden = YES;
    }
    
}

- (void)showMask
{
    _maskView.hidden = NO;
    [self nextResponder];
}

- (void)hiddenMask
{
    _maskView.hidden = YES;
    [self nextResponder];
}

- (void)showShotView
{
    [self.delegate shotCellView:self didSelectedWithShot:_model shotImageView:_shotImageView.image];
}

@end
