//
//  YPUserAdressManager.m
//  iDesign
//
//  Created by 千锋 on 16/3/3.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPUserAdressManager.h"
#import "YPUserModel.h"

static NSInteger location = 0;
@implementation YPUserAdressManager


- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        [self analysisWithString:string];
    }
    return self;
}
- (void)analysisWithString:(NSString *)string
{
    // 去掉两边的<p></p><br />
    NSArray *removeArray = @[@"<br />",@"<p>",@"</p>"];
    
    for (NSString *removeStr in removeArray) {
        string = [self removeString:removeStr fromString:string];
    }
    location = 0;
    [self addModelWithString:string];
}

/** 去掉字符串中的指定的字符串 */
- (NSString *)removeString:(NSString *)removeStr fromString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:removeStr];
    NSMutableString *newString = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        [newString appendString:array[i]];
    }
    return newString;
}


/** 拆分带连接的文本 */
- (NSString *)addModelWithString:(NSString *)string
{
    NSString *prexStr = @"<a href=\"";
    NSString *midleStr = @"\">";
    NSString *lastStr = @"</a>";
    NSString *urlStr = @"https://dribbble.com/";
    NSRange range1 = [string rangeOfString:prexStr];
    if (range1.location != NSNotFound) {
        YPUserModel *model = [[YPUserModel alloc] init];
        NSRange range2 = [string rangeOfString:midleStr];
        if (range2.location != NSNotFound) {
            NSRange range3 = {range1.location + range1.length,range2.location - range1.location - range1.length};
            model.url = [string substringWithRange:range3];
            model.url = [[model.url componentsSeparatedByString:@"\" "] firstObject];
            NSString *idString = [[model.url componentsSeparatedByString:urlStr] lastObject];
            model.userId = [NSNumber numberWithInt:[idString intValue]];
            NSRange range4 = {range2.location + range2.length, string.length - range2.length - range2.location};
            string = [string substringWithRange:range4];
            NSRange range5 = [string rangeOfString:lastStr];
            if (range5.location != NSNotFound) {
                NSRange range6 = {range1.location + location,range5.location};
                model.range = range6;
                NSRange range7 = {0,range5.location};
                model.text = [string substringWithRange:range7];
                [_dataArray addObject:model];
                NSRange range8 = {range5.length + range5.location,string.length - range5.length - range5.location};
                location += range7.length;
                NSString *lastString = [string substringWithRange:range8];
                if (![lastString isEqualToString:@""]&&lastString) {
                    [self addModelWithString:lastString];
                }
            }
            
        }
    }
    return nil;
}



@end
