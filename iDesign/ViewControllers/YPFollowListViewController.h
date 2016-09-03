//
//  YPFollowListViewController.h
//  iDesign
//
//  Created by Yinpan on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPFollowListViewController : UIViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, assign) BOOL isFollowers;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSNumber *followCount;

@end
