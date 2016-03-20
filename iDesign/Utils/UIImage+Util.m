//
//  UIImage+Util.m
//  iDesign
//
//  Created by 千锋 on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

+ (UIImage *)originImageWithName:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
