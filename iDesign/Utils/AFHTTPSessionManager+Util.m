//
//  AFHTTPSessionManager+Util.m
//  MyLimitFree
//
//  Created by 千锋 on 16/2/15.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"


static const NSUInteger kDefalutTimeoutInterval = 10;
@implementation AFHTTPSessionManager (Util)

+ (instancetype)designManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kDefalutTimeoutInterval;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    return manager;
}

- (void)requestWithType:(AFHTTPSessionManagerRequestType)type URLString:(NSString *)urlStr parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObj))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", nil];
    if (type == AFHTTPSessionManagerRequestTypeGet) {
        [manager GET:urlStr parameters:parameters success:^ void(NSURLSessionDataTask * t, id resp) {
            success(t,resp);
        } failure:^ void(NSURLSessionDataTask *t , NSError * err) {
            failure(t,err);
        }];
    }else  if(type == AFHTTPSessionManagerRequestTypePost){
        [manager POST:urlStr parameters:parameters success:^ void(NSURLSessionDataTask * t, id resp) {
            success(t,resp);
        } failure:^ void(NSURLSessionDataTask *t , NSError * err) {
            failure(t,err);
        }];
    }
}


@end
