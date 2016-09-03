//
//  YPMenuViewController.h
//  iDesign
//
//  Created by Yinpan on 16/3/9.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YPSelectedBlock)(BOOL);
@interface YPMenuViewController : UIViewController

@property (nonatomic, copy) YPSelectedBlock selectedBlock;
@property (nonatomic, assign) BOOL isSort;

@end
