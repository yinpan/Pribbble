//
//  UIImageView+Util.h
//  MyLimitFree
//
//  Created by Yinpan on 16/2/16.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

- (void) clipToRound:(BOOL) round;
- (void) loadImageWithUrlString:(NSString *)urlStr;
- (void) loadImageWithUrlString:(NSString *)urlStr withPlaceHolderImageName:(NSString *)imageName;
@end
