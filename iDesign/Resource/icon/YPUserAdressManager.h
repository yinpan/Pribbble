//
//  YPUserAdressManager.h
//  iDesign
//
//  Created by 千锋 on 16/3/3.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPUserAdressManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype) initWithString:(NSString *)string;

@end
