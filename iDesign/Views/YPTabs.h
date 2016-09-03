//
//  YPTabs.h
//  iDesign
//
//  Created by Yinpan on 16/3/8.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPTabs : UIView

@property (nonatomic, assign, readonly) NSUInteger selectedIndex;
@property (nonatomic, strong) UIColor *tinColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *lineColor;

- (void)insertTitle:(NSString *)title atIndex:(NSUInteger)index;

@end
