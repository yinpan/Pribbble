//
//  YPCollectionViewCell.m
//  iDesign
//
//  Created by 千锋 on 16/2/29.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPCollectionViewCell.h"
#import <DRTransactionModel.h>
#import <DRShot.h>

@implementation YPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView  = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

-(void)setModel:(id)model
{
    _model = model;
    if (_isShot) {
        DRShot *iModel = _model;
        [_imageView loadImageWithUrlString:iModel.images.teaser];
    }else{
        DRTransactionModel *iModel = _model;
        [_imageView loadImageWithUrlString:iModel.shot.images.teaser];
    }
}



@end
