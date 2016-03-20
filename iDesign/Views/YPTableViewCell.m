//
//  YPTableViewCell.m
//  iDesign
//
//  Created by 千锋 on 16/3/8.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPTableViewCell.h"

@interface YPTableViewCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *attachmentsCollectionView;

@end
@implementation YPTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
