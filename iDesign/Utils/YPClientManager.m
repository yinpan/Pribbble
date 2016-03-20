//
//  YPClientManager.m
//  iDesign
//
//  Created by 千锋 on 16/2/26.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPClientManager.h"



@implementation YPClientManager

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Error" reason:@"YPClientManager不能用此方法初始化" userInfo:nil];
}

- (instancetype)initWithSettings:(DRApiClientSettings *)settings
{
    @throw [NSException exceptionWithName:@"Error" reason:@"YPClientManager不能用此方法初始化" userInfo:nil];
}

- (instancetype)initPrivateWithSettings:(DRApiClientSettings *)settings
{
    return [super initWithSettings:settings];
}

+ (YPClientManager *)managerWithSetting:(DRApiClientSettings *)settings
{
    static YPClientManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (client == nil) {
            client = [[YPClientManager alloc] initPrivateWithSettings:settings];
        }
    });
    return client;
}



@end
