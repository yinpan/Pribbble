//
//  YPMenuButton.m
//  iDesign
//
//  Created by Yinpan on 16/3/9.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPMenuButton.h"

@interface YPMenuButton ()

@end

@implementation YPMenuButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        self.imageView.image = [UIImage imageNamed:@"right"];
        self.imageView.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.imageView.image = [UIImage imageNamed:@"right"];
        self.imageView.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    self.selected = selected;
    self.imageView.hidden = !selected;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.y = (contentRect.size.height - 20) / 2.0;
    contentRect.origin.x = contentRect.size.width - 20 - 15;
    contentRect.size.height = 20;
    contentRect.size.width = 20;
    return contentRect;
}



@end
