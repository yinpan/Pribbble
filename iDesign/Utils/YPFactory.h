//
//  YPFactory.h
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPApiClient;
@interface YPFactory : NSObject


/**
 *  创建带图片的BarButtonItem
 *
 *  @param imageName 图片名
 *  @param target    target
 *  @param selector  回调方法
 *
 *  @return UIBarButtonItem对象
 */
+ (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)selector;

/**
 *  沙盒存储
 *
 *  @param object 对象
 *  @param key    key
 */
+ (void)userDefaultsSetObject:(id)object forKey:(NSString *)key;


/**
 *  沙盒中用key获取对象
 *
 *  @param key key
 *
 *  @return 对象
 */
+ (id)userDefaultsObjectForKey:(NSString *)key;


+ (void)userDefaultsRemoveObjectWithKey:(NSString *)key;

+ (UIBarButtonItem *)createAvatarBarButtonItemWithTarget:(id)target action:(SEL)selector;

+ (void)removeUserPeferences;

+ (NSString *)timeStatusWithCreateTime:(NSString *)time;

+ (NSArray *)shotMenuSortSelectedIndexPath;

+ (NSArray *)shotMenuTypeSelectedIndexPath;

+ (void)networkActivityIndicatorShow;

+ (void)networkActivityIndicatorClose;

/** 生成模糊图片 */
+ (UIImage *)createBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius;

/** 获取授权对象 */
+ (YPApiClient *)shareApiClient;

@end
