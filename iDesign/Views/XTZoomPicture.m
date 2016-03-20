//
//  XTZoomPicture.m
//  XTZoomPicture
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#define SIDE_ZOOMTORECT     80.0

#import "XTZoomPicture.h"

@interface XTZoomPicture ()
@property (nonatomic, strong) UIImageView *imageView ;
@end

@implementation XTZoomPicture

#pragma mark --
#pragma mark - Initial
- (id)initWithFrame:(CGRect)frame
          backImage:(UIImage *)backImage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup] ;
        self.backImage = backImage ;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (void)setup
{
    [self srollviewConfigure] ;
    [self imageView] ;
    [self setupGesture] ;
    self.delegate = self;
}

- (void)srollviewConfigure
{
    self.maximumZoomScale = MAX_ZOOM;
    self.minimumZoomScale = MIN_ZOOM;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.backgroundColor = [UIColor blackColor] ;
}

- (void)setupGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2 ;
    [self addGestureRecognizer:doubleTap] ;
    [tap requireGestureRecognizerToFail:doubleTap] ;
}

#pragma mark --
#pragma mark - Property
- (void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage ;
    
    self.imageView.image = backImage ;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init] ;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor blackColor] ;
        _imageView.frame = [self originFrame] ;
        
        if (![_imageView superview]) {
            [self addSubview:_imageView];
        }
    }
    
    return _imageView ;
}

#pragma mark --
- (void)resetToOrigin
{
    [self setZoomScale:1 animated:NO] ;
    self.imageView.frame = [self originFrame] ;
}

- (CGRect)originFrame
{
    CGRect myRect = self.bounds ;
    float flex = FLEX_SIDE ;
    return  CGRectMake(0 + flex, 0 + flex, myRect.size.width - flex * 2, myRect.size.height - flex * 2) ;
}

#pragma mark --
#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Touch Actions
- (void)tap:(UITapGestureRecognizer *)tapGetrue
{
    [self resetToOrigin] ;
    [self removeFromSuperview] ;
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.zoomScale >= MAX_ZOOM)
    {
        [self setZoomScale:1 animated:YES] ;
    }
    else
    {
        CGPoint point = [tapGesture locationInView:self] ;
        [self zoomToRect:CGRectMake(point.x - SIDE_ZOOMTORECT / 2, point.y - SIDE_ZOOMTORECT / 2, SIDE_ZOOMTORECT, SIDE_ZOOMTORECT) animated:YES] ;
    }
}

@end
