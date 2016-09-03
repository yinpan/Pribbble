//
//  YPFollowTableViewCell.m
//  iDesign
//
//  Created by Yinpan on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPFollowTableViewCell.h"

#import <DRTransactionModel.h>
#import <DRUser.h>
#import <DRAuthority.h>
@implementation YPFollowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DRTransactionModel *)model
{
    _model = model;
    DRAuthority *authority = _model.followee?_model.followee:_model.follower;
    [_userHeaderImageView loadImageWithUrlString:authority.avatarUrl];
    _usernameLable.text = authority.username?authority.username:@"";
    _nameLabel.text = authority.location;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
