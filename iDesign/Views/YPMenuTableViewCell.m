//
//  YPMenuTableViewCell.m
//  iDesign
//
//  Created by 千锋 on 16/3/9.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPMenuTableViewCell.h"

@interface YPMenuTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
@implementation YPMenuTableViewCell

- (void)awakeFromNib {
    self.isSelected = NO;
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _rightImageView.hidden = !_isSelected;
    _menuLabel.textColor = _isSelected?[UIColor themeColor]:[UIColor themeBackgroundBlack];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
