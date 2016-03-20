//
//  YPParamModel.m
//  iDesign
//
//  Created by 千锋 on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPParamManager.h"

@implementation YPParamManager

- (instancetype)init
{
    if (self = [super init]) {
        _currentPage = 1;
        _perPageNumber = 50;
    }
    return self;
}

- (instancetype)initWithStartPage:(NSInteger)page perPageNumber:(NSInteger)number
{
    if (self = [super init]){
        _currentPage = page;
        _perPageNumber = number;
    }
    return self;
}

// 重置
- (void) reset
{
    _currentPage = 1;
}

- (NSDictionary *)nowParams
{
    return @{@"page":@(_currentPage),@"per_page":@(_perPageNumber)};
}

- (void) next
{
    _currentPage +=1;
}





@end
