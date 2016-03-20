//
//  YPShotCommentCell.m
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPShotCommentCell.h"
#import "YPCommentBodyView.h"
#import <DRComment.h>
#import <DRUser.h>


@interface YPShotCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;

@end
@implementation YPShotCommentCell


- (void)setModel:(DRComment *)model
{
    _model = model;
    DRUser *user = model.user;
    [_playerImageView loadImageWithUrlString:user.avatarUrl];
    _playerNameLabel.text = user.name;
    _commentBodyView.comment = _model.body;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
