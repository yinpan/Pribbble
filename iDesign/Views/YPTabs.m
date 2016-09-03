//
//  YPTabs.m
//  iDesign
//
//  Created by Yinpan on 16/3/8.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPTabs.h"



#define kDefalutSelectedTinColor [UIColor colorWithRed:1 green:0.29 blue:0.46 alpha:1]
#define kDefalutTinColor [UIColor colorWithRed:0.17 green:0.16 blue:0.18 alpha:1]

@interface YPTabs ()

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *buttonItem;

@end
@implementation YPTabs

#pragma mark -- 懒加载
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}


- (void)insertTitle:(NSString *)title atIndex:(NSUInteger)index
{
    [self.titleArray addObject:title];
}

- (void)createTitleButtonAtIndex:(NSUInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
}

- (void)configurePropertyForButton:(UIButton *)button
{
    if (_tinColor) {
        [button setTitleColor:_tinColor forState:UIControlStateNormal];
    }else{
        
    }
}

@end
