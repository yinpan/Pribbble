//
//  YPCommentBodyView.h
//  iDesign
//
//  Created by 千锋 on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPCommentBodyView;
@protocol YPCommentBodyViewDelegate <NSObject>

/** 协议：打开网页视图加载url */
- (void)commentBodyView:(YPCommentBodyView *)commentView showInfoWithURL:(NSURL *)url;

/** 协议：跳转至用户详情界面 */
- (void)commentBodyView:(YPCommentBodyView *)commentView showUserInfoWithUserId:(NSNumber *)userId;

@end
@interface YPCommentBodyView : UIView

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, weak) id<YPCommentBodyViewDelegate> delegate;

@end
