//
//  AFHTTPSessionManager+Util.h
//  MyLimitFree
//
//  Created by Yinpan on 16/2/15.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger, AFHTTPSessionManagerRequestType) {
    AFHTTPSessionManagerRequestTypeGet = 1,
    AFHTTPSessionManagerRequestTypePost
};
@interface AFHTTPSessionManager (Util)

+ (instancetype) designManager;

- (void)requestWithType:(AFHTTPSessionManagerRequestType)type
              URLString:(NSString *)urlStr
             parameters:(id)parameters
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
