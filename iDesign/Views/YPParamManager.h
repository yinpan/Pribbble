//
//  YPParamModel.h
//  iDesign
//
//  Created by 千锋 on 16/3/1.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPParamManager : NSObject

@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger perPageNumber;

// 重置
- (void) reset;

- (NSDictionary *)nowParams;

- (void) next;

- (instancetype)initWithStartPage:(NSInteger)page perPageNumber:(NSInteger)number;

@end
