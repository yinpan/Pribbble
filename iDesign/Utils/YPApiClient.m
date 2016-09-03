//
//  YPApiClient.m
//  iDesign
//
//  Created by Yinpan on 16/3/6.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPApiClient.h"


static NSString * const kRequestUrlForPopular = @"popular";
static NSString * const kRequestUrlForDebuts = @"debuts";
static NSString * const kRequestUrlForRecent = @"recent";
static NSString * const kRequestBaseUrl = @"shots";

@implementation YPApiClient

- (void)yp_requestShotsWithparams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler
{
    [self runRequestWithMethod:kRequestBaseUrl requestType:@"GET" modelClass:[DRShot class] params:params responseHandler:responseHandler];
}

/** 加载流行shot */
- (void)yp_requestPopularWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:kRequestUrlForPopular forKey:@"sort"];
    [self runRequestWithMethod:kRequestBaseUrl requestType:@"GET" modelClass:[DRShot class] params:dict responseHandler:responseHandler];
}

/** 加载所有的shot */
- (void)yp_requestEveryoneWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:kRequestUrlForRecent forKey:@"sort"];
    [self runRequestWithMethod:kRequestBaseUrl requestType:@"GET" modelClass:[DRShot class] params:dict responseHandler:responseHandler];
}
/** 加载新手第一次shot */
- (void)yp_requestDebutsWithParams:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:kRequestUrlForDebuts forKey:@"list"];
    [self runRequestWithMethod:kRequestBaseUrl requestType:@"GET" modelClass:[DRShot class] params:dict responseHandler:responseHandler];
}

/** 加载其它shot */
- (void)yp_requestOtherWithUrl:(NSString *)urlStr Params:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setValue:OAuth2_CLIENT_ACCESS_TOKEN forKey:@"access_token"];
}



- (void)runRequestWithMethod:(NSString *)method requestType:(NSString *)requestType modelClass:(Class)modelClass params:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler {
    [[self createRequestWithMethod:method requestType:requestType modelClass:modelClass params:params responseHandler:responseHandler] start];
}

- (AFHTTPRequestOperation *)createRequestWithMethod:(NSString *)method requestType:(NSString *)requestType modelClass:(Class)modelClass params:(NSDictionary *)params responseHandler:(DRResponseHandler)responseHandler {
    __weak typeof(self)weakSelf = self;
    NSMutableURLRequest *request = [self.apiManager.requestSerializer requestWithMethod:requestType URLString:[[NSURL URLWithString:method relativeToURL:self.apiManager.baseURL] absoluteString] parameters:params error:nil];
    
    AFHTTPRequestOperation *operation = [self.apiManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.response statusCode] == kHttpAuthErrorCode || [operation.response statusCode] == kHttpRateLimitErrorCode) {
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:[operation.response statusCode] userInfo:nil];
            if (weakSelf.defaultErrorHandler) weakSelf.defaultErrorHandler(error);
        }
        if (responseHandler) {
            responseHandler([weakSelf mappedDataFromResponseObject:responseObject modelClass:modelClass]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode] == kHttpNotFoundErrorCode) {
            NSError *dribbbleFalseError = [NSError errorWithDomain:error.domain code:kHttpNotFoundErrorCode userInfo:error.userInfo];
            error = dribbbleFalseError;
        }
        if (weakSelf.defaultErrorHandler) weakSelf.defaultErrorHandler(error);
        if (responseHandler) responseHandler([DRApiResponse responseWithError:error]);
    }];
    return operation;
}

- (id)mappedDataFromResponseObject:(id)object modelClass:(Class)modelClass {
    if (modelClass == [NSNull class]) { // then bypass parsing
        return [DRApiResponse responseWithObject:object];
    }
    id mappedObject = nil;
    if ([object isKindOfClass:[NSArray class]]) {
        mappedObject = [(NSArray *)object bk_map:^id(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                return [[modelClass alloc] initWithDictionary:obj error:nil];
            } else {
                return [NSNull null];
            }
        }];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        mappedObject = [[modelClass alloc] initWithDictionary:object error:nil];
    }
    return [DRApiResponse responseWithObject:mappedObject];
}




@end
