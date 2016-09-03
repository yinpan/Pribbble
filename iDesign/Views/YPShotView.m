//
//  YPShotView.m
//  iDesign
//
//  Created by Yinpan on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPShotView.h"
#import "YPShotButton.h"
#import <UIImageView+WebCache.h>
#import "YPDrawView.h"
#import <YLImageView.h>
#import <YLGIFImage.h>
#import <UIImage+GIF.h>
#import "YPLikeView.h"
#import "YPImageButton.h"
#import "YPCommentBodyView.h"





@interface YPShotView ()


@property (nonatomic, strong) NSMutableArray *itemButtonArray;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) YPDrawView *drawView;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation YPShotView

- (NSMutableArray *)itemButtonArray
{
    if (!_itemButtonArray) {
        _itemButtonArray = [NSMutableArray array];
    }
    return _itemButtonArray;
}

- (YPDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[YPDrawView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.center = _imageView.center;
        [self addSubview:_drawView];
    }
    return _drawView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.originalFrame = frame;
    if (self) {
        _baseViewHeight = CGRectGetHeight(frame) - WIDTH * 0.75;
        _imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), WIDTH * 0.75)];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [_imageView addGestureRecognizer:tap];
        [self addSubview:_imageView];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(frame), _baseViewHeight)];
        [self addSubview:_baseView];
        
        _likeView = [[YPLikeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 60)];
        [_baseView addSubview:_likeView];
        [_likeView.buketButton addTarget:self action:@selector(addBuket) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
    }
    return self;
}



- (void)setModel:(DRShot *)model
{
    _model = model;
    __weak typeof(self) weakSelf = self;
    _likeView.likeButton.shotId = _model.shotId;
    if ([_model.attachmentsCount intValue]&&_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, WIDTH, 1);
        layer.backgroundColor = [UIColor themeCellGrayBackground].CGColor;
        [_scrollView.layer addSublayer:layer];
        _scrollView.backgroundColor = [[UIColor themeCellGrayBackground] colorWithAlphaComponent:0.5];
        [_baseView addSubview:_scrollView];

        CGRect rect = _likeView.frame;
        rect.origin.y += 90 ;
        _likeView.frame  = rect;
        

        [[YPFactory shareApiClient] loadAttachmentsWithShot:_model.shotId params:@{@"per_page":_model.attachmentsCount,@"page":@(1)} responseHandler:^(DRApiResponse *response) {
            if (response.object) {
                [weakSelf createAttament:response.object onView:_scrollView];
            }
        }];
    }

    _likeView.likeCountLabel.text  = [NSString stringWithFormat:@"%@", _model.likesCount];
    [_likeView.likeButton checkIsLike];
    
    if (_model.images.hidpi) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_model.images.hidpi] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            weakSelf.drawView.value = (CGFloat)receivedSize/(CGFloat)expectedSize;
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                _imageView.image = [YLGIFImage imageWithData:data];
            }
        }];
    }else{
        [_imageView loadImageWithUrlString:_model.images.normal];
    }
    
    
}





- (void)createAttament:(NSArray *)array onView:(UIScrollView *)view
{
    for (int i = 0 ; i < array.count; i++) {
        DRShotAttachment *atta = array[i];
        YPImageButton *button = [[YPImageButton alloc] initWithFrame:CGRectMake(20 + i*(80+20) , 15, 80, 60)];
        if (![atta isKindOfClass:[NSNull class]]){
            button.url = atta.url;
        }
        UIImageView *buttonImageView = [[UIImageView alloc] init];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:atta.thumbnailUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [button setImage:buttonImageView.image forState:UIControlStateNormal];
        }];
        [button addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    view.contentSize = CGSizeMake(array.count * 100 + 20, CGRectGetHeight(view.frame));
}

- (void)showImage:(YPImageButton *)sender
{
    [self.delegate shotAttachmentImageViewWithURL:sender.url];
}

- (void)setAddHeith:(CGFloat)addHeith
{
    _addHeith = addHeith;
    if (_addHeith >= 0) {
        self.frame = CGRectMake(0,-_addHeith, CGRectGetWidth(_originalFrame), CGRectGetHeight(_originalFrame) + _addHeith);
        CGRect imageViewRect = _imageView.frame;
        imageViewRect.size.height = CGRectGetHeight(self.frame) - _baseViewHeight;
        imageViewRect.size.width = imageViewRect.size.height * 4 / 3.0;
        imageViewRect.origin.x = -(imageViewRect.size.width - CGRectGetWidth(_originalFrame))/2.0;
        _imageView.frame = imageViewRect;
        CGRect baseViewRect = _baseView.frame;
        baseViewRect.origin.y = CGRectGetHeight(_imageView.frame);
        _baseView.frame = baseViewRect;
    }
}


- (void)addBuket
{
    [self.delegate addBuketEvent];
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    [self.delegate shotImageViewDidTap:_imageView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
