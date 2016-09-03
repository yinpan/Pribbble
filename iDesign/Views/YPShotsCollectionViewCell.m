//
//  YPShotsCollectionViewCell.m
//  iDesign
//
//  Created by Yinpan on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPShotsCollectionViewCell.h"
#import <DRShot.h>
#import <YLGIFImage.h>
#import <UIImageView+WebCache.h>


@interface YPShotsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;



@end
@implementation YPShotsCollectionViewCell

- (void)awakeFromNib {
    _gifImageView.hidden = YES;
}


- (void)setModel:(DRShot *)model
{
    _model = model;
    if ([_model.images.normal hasSuffix:@".gif"]) {
        [_shotImageView sd_setImageWithURL:[NSURL URLWithString:_model.images.normal] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
        _gifImageView.hidden = NO;
    }else{
        [_shotImageView loadImageWithUrlString:_model.images.normal];
        _gifImageView.hidden = YES;
    }
    
}

@end
