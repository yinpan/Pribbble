//
//  YPShotCommentCell.h
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPCommentBodyView;
@interface YPShotCommentCell : UITableViewCell

@property (nonatomic, strong) DRComment *model;

@property (weak, nonatomic) IBOutlet YPCommentBodyView *commentBodyView;

@end
