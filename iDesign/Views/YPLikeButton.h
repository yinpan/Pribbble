//
//  YPLikeButton.h
//  iDesign
//
//  Created by 千锋 on 16/3/10.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPLikeButton;
@protocol  YPLikeButtonDelegate <NSObject>

- (void)likeButton:(YPLikeButton *)likeButton likeState:(BOOL)like;

@end
@interface YPLikeButton : UIButton

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSNumber *shotId;
@property (nonatomic, weak) id<YPLikeButtonDelegate> delegate;

- (void)checkIsLike;
@end
