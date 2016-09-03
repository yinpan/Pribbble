//
//  YPShotsCollectionViewCell.h
//  iDesign
//
//  Created by Yinpan on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLImageView.h>

@class DRShot;
@interface YPShotsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DRShot *model;
@property (weak, nonatomic) IBOutlet YLImageView *shotImageView;

@end
