//
//  YPVCManager.h
//  iDesign
//
//  Created by Yinpan on 16/3/7.
//  Copyright © 2016年 yinpans. All rights reserved.
//


#import <UIKit/UIKit.h>



@interface YPVCManager : NSObject


/**
 *  切换根视图
 *
 *  @param class 目标视图控制器
 */
+ (void)changeRootViewController:(Class)class;


@end
