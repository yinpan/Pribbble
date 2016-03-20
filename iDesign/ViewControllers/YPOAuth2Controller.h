//
//  YPOAuth2Controller.h
//  iDesign
//
//  Created by 千锋 on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YPOAuthFinishBlock)(BOOL);
@interface YPOAuth2Controller : UIViewController
@property (nonatomic, copy)YPOAuthFinishBlock finishBlock;

@end
