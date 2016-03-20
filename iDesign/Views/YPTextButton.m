//
//  YPTextButton.m
//  iDesign
//
//  Created by 千锋 on 16/2/27.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPTextButton.h"

@implementation YPTextButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.highlighted = NO;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontStandard];
        [self setTitleColor:[UIColor themeFontGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor themeBarTinColor] forState:UIControlStateSelected];
    }
    return self;
}






@end
