//
//  YPUrlButton.m
//  iDesign
//
//  Created by 千锋 on 16/2/27.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPUrlButton.h"


@interface YPUrlButton ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation YPUrlButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) * 0.2, CGRectGetHeight(frame))];
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.textColor = [UIColor themeFontGrayColor];
        _typeLabel.font = [UIFont fontminiStandard];
        [self addSubview:_typeLabel];
        
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_typeLabel.frame) + 15, 0, CGRectGetWidth(frame) * 0.6, CGRectGetHeight(frame))];
        _urlLabel.textColor = [UIColor themeBarTinColor];
        _urlLabel.font = [UIFont fontminiStandard];
        [self  addSubview:_urlLabel];
        
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 40, (CGRectGetHeight(frame) - 20) * 0.5, 20, 20)];
        [self addSubview:_logoImageView];
        
        [self addTarget:self action:@selector(loadWeb) forControlEvents:UIControlEventTouchDragInside];
        
    }
    return self;
}


- (void)setUrl:(NSString *)url
{
    _url = url;
    self.hidden = NO;
    _urlLabel.text = url;
}

- (void)setLogoImageName:(NSString *)logoImageName
{
    _logoImageName = logoImageName;
    _logoImageView.image = [UIImage imageNamed:logoImageName];
}

- (void)setType:(NSString *)type
{
    _type = type;
    _typeLabel.text  = type;
}


- (void)loadWeb
{
    if (_url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
