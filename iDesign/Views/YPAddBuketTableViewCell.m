//
//  YPAddBuketTableViewCell.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPAddBuketTableViewCell.h"

@interface YPAddBuketTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buketsCount;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end
@implementation YPAddBuketTableViewCell

- (UIActivityIndicatorView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.backgroundColor = [UIColor themeWhiteColor];
        [_chooseView addSubview:_loadingView];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _isAdd = NO;
}


- (void)setModel:(DRBucket *)model
{
    _model = model;
    self.nameLabel.text = model.name;
    self.buketsCount.text = [NSString stringWithFormat:@"%@ shots",_model.shotsCount];
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [[YPFactory shareApiClient] loadBucketShots:_model.bucketId          params:@{@"page":@(1),@"per_page":_model.shotsCount}
                                responseHandler:^(DRApiResponse *response) {
                                    if (!response.error) {
                                        NSArray *array = response.object;
                                        if (array.count) {
                                            DRShot *shot = array[0];
                                            [self.shotImageView loadImageWithUrlString:shot.images.normal];
                                            [self checkIsAddBuket:array];
                                        }
                                    }
                                    [self.loadingView stopAnimating];
                                    self.loadingView.hidden = YES;
                                }];

}

- (void)setIsAdd:(BOOL)isAdd{
    _isAdd = isAdd;
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
    if (_isAdd) {
        [[YPFactory shareApiClient] addShotToBucket:_model.bucketId params:@{@"shot_id":_shotId} responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                _chooseView.image = [UIImage imageNamed:@"choose"];
            }else{
                _chooseView.image = [UIImage imageNamed:@"unchoose"];
                _isAdd = !_isAdd;
            }
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
        }];
    }else{
        [[YPFactory shareApiClient] deleteShotFromBucket:_model.bucketId params:@{@"shots":_shotId} responseHandler:^(DRApiResponse *response) {
            if (!response.error) {
                _chooseView.image = [UIImage imageNamed:@"unchoose"];
            }else{
                _chooseView.image = [UIImage imageNamed:@"choose"];
                _isAdd = !_isAdd;
            }
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
        }];
    }
}

- (void)checkIsAddBuket:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(DRShot *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.shotId isEqualToNumber:_shotId]) {
            _chooseView.image = [UIImage imageNamed:@"choose"];
            _isAdd = YES;
        }
    }];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
