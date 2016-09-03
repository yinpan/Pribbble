//
//  YPDrawView.m
//  iDesign
//
//  Created by Yinpan on 16/3/5.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPDrawView.h"

@implementation YPDrawView

- (void)drawRect:(CGRect)rect
{
    [self drawProgress:1.0 color:[[UIColor themeWhiteColor] colorWithAlphaComponent:0.7]];
    [self drawProgress:self.value color:[UIColor themeWhiteColor]];
}

- (void)drawProgress:(CGFloat)value color:(UIColor *)color
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.width * 0.5 - 5;
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = - M_PI_2 + value * M_PI * 2;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CGContextSetLineWidth(ctx, 6);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [color setStroke];
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
//    CGContextRelease(ctx);
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    [self setNeedsDisplay];
    if (value >= 1) {
        [self removeFromSuperview];
    }
}

@end
