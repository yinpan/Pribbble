//
//  UIImage+Util.h
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

/**
 *  获得一个原始的图片
 *
 *  @param imageName 图片名
 *
 *  @return image对象
 */
+ (UIImage *)originImageWithName:(NSString *)imageName;

@end
