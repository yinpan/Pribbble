//
//  YPCollectionViewCell.h
//  iDesign
//
//  Created by Yinpan on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) id model;
@property (nonatomic, assign) BOOL isShot;

@end
