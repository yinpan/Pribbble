//
//  YPBuketsTableViewCell.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPBuketsTableViewCell.h"



@implementation YPBuketsTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
