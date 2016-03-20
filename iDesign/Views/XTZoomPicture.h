//
//  XTZoomPicture.h
//  XTZoomPicture
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#define MAX_ZOOM    2.0
#define MIN_ZOOM    1.0
#define FLEX_SIDE   5.0

#import <UIKit/UIKit.h>

@interface XTZoomPicture : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,strong) UIImage *backImage ;

- (id)initWithFrame:(CGRect)frame
          backImage:(UIImage *)backImage ;
- (id)initWithFrame:(CGRect)frame ;
- (void)resetToOrigin ;

@end
