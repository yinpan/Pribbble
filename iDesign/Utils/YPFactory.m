//
//  YPFactory.m
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPFactory.h"
#import <NSDate+DateTools.h>
#import "AppDelegate.h"

@implementation YPFactory

+ (UIBarButtonItem *)createAvatarBarButtonItemWithTarget:(id)target action:(SEL)selector
{
    AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
    if ([self userDefaultsObjectForKey:KEY_USER_AVATAR] && [delegate.client isUserAuthorized]) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageWithData:[self userDefaultsObjectForKey:KEY_USER_AVATAR]] forState:UIControlStateNormal];
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        return item;
    }
    return [self createBarButtonItemWithImageName:@"user" target:target action:selector];
}

+ (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)selector
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:target action:selector];
}

+ (id)userDefaultsObjectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)userDefaultsSetObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)userDefaultsRemoveObjectWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (void)removeUserPeferences
{
    if ([self userDefaultsObjectForKey:KEY_USER_AVATAR]) {
        [self userDefaultsRemoveObjectWithKey:KEY_USER_AVATAR];
    }
    if ([self userDefaultsObjectForKey:KEY_USERID]) {
        [self userDefaultsRemoveObjectWithKey:KEY_USERID];
    }
    if ([self userDefaultsObjectForKey:KEY_ACCESSTOKEN]) {
        [self userDefaultsObjectForKey:KEY_ACCESSTOKEN];
    }
}

+ (NSString *)timeStatusWithCreateTime:(NSString *)time
{
    // 定义一个时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    dateFormatter.locale = [NSLocale systemLocale];
    
    // 获取创建时间
    NSDate *createDate = [dateFormatter dateFromString:time];
    
    return createDate.shortTimeAgoSinceNow;
}

+ (NSArray *)shotMenuSortSelectedIndexPath
{
    int timeIndex = 0,popularIndex=0;
    if ([self userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX]) {
        popularIndex = [[YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX] intValue];
    }
    if ([self userDefaultsObjectForKey:KEY_MENU_SORT_TIME_SELECTEDINDEX]) {
        timeIndex = [[self userDefaultsObjectForKey:KEY_MENU_SORT_TIME_SELECTEDINDEX] intValue];
    }
    return @[[NSIndexPath indexPathForItem:popularIndex inSection:0],[NSIndexPath indexPathForItem:timeIndex inSection:1]];
}

+ (NSArray *)shotMenuTypeSelectedIndexPath
{
    int typeIndex = 0;
    if ([self userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX]) {
        typeIndex = [[self userDefaultsObjectForKey:KEY_MENU_TYPE_SELECTEDINDEX] intValue];
    }
    return @[[NSIndexPath indexPathForItem:typeIndex inSection:0]];
}

+ (void)networkActivityIndicatorShow
{
    //设置状态栏转动
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)networkActivityIndicatorClose
{
    //设置状态栏转动
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


+ (UIImage *)createBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];//设置模糊度
    
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:inputImage.extent];
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return blurImage;
}

+ (YPApiClient *)shareApiClient
{
    AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
    return delegate.client;
}


@end
