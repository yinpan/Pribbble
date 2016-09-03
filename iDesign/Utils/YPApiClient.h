//
//  YPApiClient.h
//  iDesign
//
//  Created by Yinpan on 16/3/6.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <DribbbleSDK/DribbbleSDK.h>

@interface YPApiClient : DRApiClient

/** 加载shot */
- (void)yp_requestShotsWithparams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler;

/** 加载流行shot */
- (void)yp_requestPopularWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler;
/** 加载所有的shot */
- (void)yp_requestEveryoneWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler;
/** 加载新手第一次shot */
- (void)yp_requestDebutsWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler;
/** 加载其它shot */
- (void)yp_requestOtherWithUrl:(NSString *)urlStr Params:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler;



@end
