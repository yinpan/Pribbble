//
//  YPBuketsTableViewCell.h
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPShotCellView.h"

@interface YPBuketsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YPShotCellView *leftView;

@property (weak, nonatomic) IBOutlet YPShotCellView *rightView;

@end
