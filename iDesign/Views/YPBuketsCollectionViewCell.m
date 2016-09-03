//
//  YPBuketsCollectionViewCell.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPBuketsCollectionViewCell.h"


@interface YPBuketsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;
@property (weak, nonatomic) IBOutlet UILabel *buketTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buketsCountLabel;


@end
@implementation YPBuketsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DRBucket *)model
{
    _model = model;
    _buketsCountLabel.text = [NSString stringWithFormat:@"%@ Shots",_model.shotsCount];
    _buketTitleLabel.text = _model.name;
    _shotImageView.image = [UIImage imageNamed:@"placeholder"];
    [[YPFactory shareApiClient] loadBucketShots:_model.bucketId          params:@{@"page":@(1),@"per_page":@(1)}
        responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                NSArray *array = response.object;
                if (array.count) {
                    DRShot *shot = response.object[0];
                    [_shotImageView loadImageWithUrlString:shot.images.normal];
                }
            }
    }];
    
    
    
}

@end
