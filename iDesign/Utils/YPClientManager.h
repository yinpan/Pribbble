//
//  YPClientManager.h
//  iDesign
//
//  Created by Yinpan on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <DribbbleSDK/DribbbleSDK.h>

@interface YPClientManager : DRApiClient

/**
 *  创建授权管理对象
 *
 *  @param settings 授权设置
 *
 *  @return YPClientManager单例对象
 */
+ (YPClientManager *)managerWithSetting:(DRApiClientSettings *)settings;

/**
 *  获取授权管理对象
 *
 *  @return 授权管理对象
 */
//+ (YPClientManager *)manager;

@end
