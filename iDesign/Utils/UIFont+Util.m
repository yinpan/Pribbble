//
//  UIFont+Util.m
//  iDesign
//
//  Created by 千锋 on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "UIFont+Util.h"

@implementation UIFont (Util)

/** 用户名字体 */
+ (UIFont *)fontUserName
{
    return [UIFont systemFontOfSize:20];
}
/** 小号字体 */
+ (UIFont *)fontSmall
{
    return [UIFont systemFontOfSize:10];
}

/** 标题字体 */
+ (UIFont *)fontTitle
{
    return [UIFont systemFontOfSize:16];
}

/** 标准字体字体 */
+ (UIFont *)fontStandard
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)fontminiStandard
{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)fontFollowButton
{
    return [UIFont systemFontOfSize:11];
}

+ (UIFont *)fontComment
{
    return [UIFont systemFontOfSize:13];
}


@end
