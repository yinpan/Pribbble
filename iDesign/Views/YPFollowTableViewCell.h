//
//  YPFollowTableViewCell.h
//  iDesign
//
//  Created by 千锋 on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRTransactionModel;
@interface YPFollowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) DRTransactionModel *model;

@end
