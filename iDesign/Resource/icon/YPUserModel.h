//
//  YPUserModel.h
//  iDesign
//
//  Created by 千锋 on 16/3/3.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPUserModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange range;


@end
