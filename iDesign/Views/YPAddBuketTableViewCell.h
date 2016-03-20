//
//  YPAddBuketTableViewCell.h
//  iDesign
//
//  Created by 千锋 on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPAddBuketTableViewCell : UITableViewCell

@property (nonatomic, strong) DRBucket *model;
@property (nonatomic, strong) NSNumber *shotId;
@property (nonatomic, assign) BOOL isAdd ;

@end
