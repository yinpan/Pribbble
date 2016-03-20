//
//  YPVCManager.m
//  iDesign
//
//  Created by 千锋 on 16/3/7.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPVCManager.h"

@implementation YPVCManager

+ (void)changeRootViewController:(Class)class
{
    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window]
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [[[UIApplication sharedApplication].delegate window] setRootViewController:[class new]];
                        [UIView setAnimationsEnabled:oldState];
                        [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
                    }completion:nil];
}

@end
