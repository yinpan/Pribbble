//
//  YPCommentView.h
//  iDesign
//
//  Created by Yinpan on 16/3/4.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import <UIKit/UIKit.h>




@class YPCommentView;
typedef void(^CommentBlock)();
@protocol YPCommentViewDelegate <NSObject>

/** 发送消息,commentId为空时即是直接给作品评论 */
- (void)commentView:(YPCommentView *)commentView postCommentWithBody:(NSString *)string commentId:(NSNumber *)commentId;

/** 取消发送消息 */
- (void)commentViewCancelPostMsg;

@end
@interface YPCommentView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, weak) id<YPCommentViewDelegate> delegate;
@property (nonatomic, assign) BOOL isUp;

/** 升起视图 */
- (void)up;

- (void)down;

/** 收起视图 */
- (void)downAnimation:(CommentBlock)animation Finished:(CommentBlock)finishblock;


@end
