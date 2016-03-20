//
//  YPShotImageView.h
//  iDesign
//
//  Created by 千锋 on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRShot,YPShotCellView;

@protocol YPShotCellViewDelegate <NSObject>

- (void)shotCellView:(YPShotCellView *)shotCellView didSelectedWithShot:(DRShot *)shot shotImageView:(UIImage *)sImage;

@end
@interface YPShotCellView : UIButton

@property (nonatomic, strong) DRShot *model;
@property (nonatomic, weak) id<YPShotCellViewDelegate> delegate;

@end
