//
//  YPMenuTableViewCell.h
//  iDesign
//
//  Created by 千锋 on 16/3/9.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, assign) BOOL isSelected;
@end
