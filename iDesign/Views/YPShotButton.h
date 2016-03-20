//
//  YPShotButton.h
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YPShotButtonType) {
    YPShotButtonTypeView = 1,
    YPShotButtonTypeComment,
    YPShotButtonTypeLike
};

@class YPShotButton;
@protocol YPShotButtonDelegate <NSObject>

@optional

- (void) shotButton:(YPShotButton *)shotButton likeStateChange:(BOOL)isLike;

@end

@interface YPShotButton : UIButton

@property (nonatomic, assign)YPShotButtonType type;
@property (nonatomic, assign)BOOL isLike;
@property (nonatomic, weak) id<YPShotButtonDelegate> delegate;

@property (nonatomic, strong) UILabel *countLabel;


@end
