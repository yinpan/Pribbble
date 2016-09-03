//
//  YPUserInfoViewController.h
//  iDesign
//
//  Created by Yinpan on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPApiClient;
@interface YPUserInfoViewController : UIViewController

@property (nonatomic, strong)NSNumber *userID;
@property (nonatomic, assign)BOOL isSelf;

@end
