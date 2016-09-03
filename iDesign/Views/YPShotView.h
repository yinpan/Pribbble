//
//  YPShotView.h
//  iDesign
//
//  Created by Yinpan on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRShot,YPShotButton,YLImageView,YPLikeView;

@protocol YPShotViewDelegate <NSObject>

/** shotView点击事件 */
- (void)shotImageViewDidTap:(UIImageView *)shotImageView;
- (void)shotAttachmentImageViewWithURL:(NSString *)url;
- (void)addBuketEvent;

@end
@interface YPShotView : UIView

@property (nonatomic, strong) DRShot *model;
@property (nonatomic, strong) YLImageView *imageView;
@property (nonatomic, assign) CGFloat addHeith;
@property (nonatomic, weak) id<YPShotViewDelegate> delegate;
@property (nonatomic, assign) BOOL isHaveAttament;
@property (nonatomic, assign) CGFloat baseViewHeight;
@property (nonatomic, strong) YPLikeView *likeView;


@end
