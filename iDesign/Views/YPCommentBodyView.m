//
//  YPCommentBodyView.m
//  iDesign
//
//  Created by Yinpan on 16/3/2.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPCommentBodyView.h"
#import <TTTAttributedLabel.h>
#import "YPUserAdressManager.h"
#import "YPUserModel.h"

@interface YPCommentBodyView ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) YPUserAdressManager *adressManager;

@end
@implementation YPCommentBodyView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:self.bounds];
        [self addSubview:_contentLabel];
        _contentLabel.font = [UIFont fontComment];
        _contentLabel.numberOfLines = 0;
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setValue:(__bridge id)[UIColor themeRedColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        _contentLabel.linkAttributes = linkAttributes;
        _contentLabel.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:self.bounds];
        [self addSubview:_contentLabel];
        _contentLabel.font = [UIFont fontComment];
        _contentLabel.numberOfLines = 0;
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setValue:(__bridge id)[UIColor themeRedColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        _contentLabel.linkAttributes = linkAttributes;
        _contentLabel.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setComment:(NSString *)comment
{
    _comment = comment;
    _adressManager = [[YPUserAdressManager alloc] initWithString:[_comment copy]];
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[_comment dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    _contentLabel.text = string.string;
   
    // 重新计算label大小
    CGSize size = [string.string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontComment]} context:nil].size;
    // 修正label的宽度变化，所以此处还是取self的宽度
    _contentLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), size.height);
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
    [self adjustRangeWithString:string.string];
    
    for (int i = 0; i < _adressManager.dataArray.count; i++) {
        YPUserModel *model = _adressManager.dataArray[i];
        [_contentLabel addLinkToURL:[NSURL URLWithString:model.url] withRange:model.range];
    }
    
}

/** 容差计算范围 */
- (void)adjustRangeWithString:(NSString *)string
{
    NSArray *array = _adressManager.dataArray;
    for (int i = 0; i < array.count; i++) {
        YPUserModel *model = array[i];
        NSString *copyString = [string copy];
        if (model.range.location + model.range.length > copyString.length) {
            NSRange range = [copyString rangeOfString:model.text];
            if (range.location == NSNotFound) {
                [_adressManager.dataArray removeObject:model];
                i -= 1;
            }else{
                int a = (int)range.location;
                int b = (int)model.range.location;
                if (ABS(a - b) < model.text.length) {
                    model.range = range;
                    [_adressManager.dataArray replaceObjectAtIndex:i withObject:model];
                }
                return;
            }
        }
        if (![[copyString substringWithRange:model.range] isEqualToString:model.text]) {
            NSRange range = [copyString rangeOfString:model.text];
            if (range.location == NSNotFound) {
                [_adressManager.dataArray removeObject:model];
                i -= 1;
            }else{
                int a = (int)range.location;
                int b = (int)model.range.location;
                if (ABS(a - b) < model.text.length) {
                    model.range = range;
                    [_adressManager.dataArray replaceObjectAtIndex:i withObject:model];
                }
            }
        }
    }
}




- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *string = url.absoluteString;
    NSString *dribbbleStr = @"https://dribbble.com/";
    if ([self dealWithUrl:url]) {
        NSString *userIdString = [[string componentsSeparatedByString:dribbbleStr] lastObject];
        NSNumber *userId = [NSNumber numberWithLong:[userIdString intValue]];
        [_delegate commentBodyView:self showUserInfoWithUserId:userId];
    }else{
        [_delegate commentBodyView:self showInfoWithURL:url];
    }
}

/** 判断是否为用户地址 */
- (BOOL)dealWithUrl:(NSURL *)url
{
    NSString *urlStr = url.absoluteString;
    NSString *dribbbleStr = @"https://dribbble.com/";
    if ([urlStr containsString:dribbbleStr]) {
        NSString *userId = [[urlStr componentsSeparatedByString:dribbbleStr] lastObject];
        for (int i = 0; i < userId.length; i++) {
            char c = [userId characterAtIndex:i];
            if ((('A'<=c&&c<='Z')||('a'<=c&&c<='z'))) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
