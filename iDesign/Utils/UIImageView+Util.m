//
//  UIImageView+Util.m
//  MyLimitFree
//
//  Created by Yinpan on 16/2/16.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "UIImageView+Util.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Util)


- (void) clipToRound:(BOOL)round
{
    CGFloat diameter = self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height;
    self.layer.cornerRadius = diameter / 2.0;
    self.layer.masksToBounds = round;
    
}


- (void) loadImageWithUrlString:(NSString *)urlStr
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)loadImageWithUrlString:(NSString *)urlStr withPlaceHolderImageName:(NSString *)imageName
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:imageName]];
}

@end
