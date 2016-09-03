//
//  YPCommentView.m
//  iDesign
//
//  Created by Yinpan on 16/3/4.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPCommentView.h"

@interface YPCommentView ()

@property (nonatomic, strong) UIView *maskView;



@end
@implementation YPCommentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelComment:)];
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:tap];
        [self addSubview:_maskView];
        
        
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), WIDTH, 60)];
        _baseView.backgroundColor = [[UIColor themeWhiteColor] colorWithAlphaComponent:0.97];
        [self addSubview:_baseView];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 15, 30, 30)];
        _avatarImageView.layer.cornerRadius = 12.5f;
        _avatarImageView.clipsToBounds = YES;
        [_baseView addSubview:_avatarImageView];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_avatarImageView.frame) +  10, CGRectGetMinY(_avatarImageView.frame), CGRectGetWidth(self.frame) - CGRectGetMaxX(_avatarImageView.frame) - 100, CGRectGetHeight(_avatarImageView.frame))];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"comment";
        [_baseView addSubview:_textField];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textField.frame) + 10, CGRectGetMinY(_textField.frame), 70, CGRectGetHeight(_textField.frame))];
        button.layer.cornerRadius = 4;
        button.layer.borderColor = [UIColor themeBackgroundBlack].CGColor;
        button.layer.borderWidth = 2;
        [button setTitle:@"Post" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor themeBackgroundBlack] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
    }
    return self;
}

- (void)setUserAccount:(NSString *)userAccount
{
    _userAccount = userAccount;
    _textField.placeholder = [NSString stringWithFormat:@"@%@",_userAccount];
}

- (void)up
{
    self.isUp = YES;
    CGRect rect = _baseView.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        _baseView.frame = rect;
    }];
}

- (void)downAnimation:(CommentBlock)animation Finished:(CommentBlock)finishblock
{
    CGRect rect = _baseView.frame;
    rect.origin.y += rect.size.height;
    self.isUp = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _baseView.frame = rect;
        if (animation) {
            animation();
        }
    } completion:^(BOOL finished) {
        if (finishblock) {
            finishblock();
        }
    }];
}

- (void)down{
    self.isUp = NO;
    [self downAnimation:nil Finished:nil];
}

- (void)cancelComment:(UITapGestureRecognizer *)sender
{
    [self.delegate commentViewCancelPostMsg];
}

- (void)sendComment
{
    [self.delegate commentView:self postCommentWithBody:_textField.text commentId:_commentId];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
