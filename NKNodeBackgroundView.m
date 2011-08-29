//
//  NKNodeBackgroundView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeBackgroundView.h"

#define kNKNodeBackgroundViewBottomGradientColor [UIColor colorWithRed:0.161 green:0.173 blue:0.224 alpha:1.000]
#define kNKNodeBackgroundViewTopGradientColor [UIColor colorWithWhite:0.000 alpha:0.790]

@interface NKNodeBackgroundView ()

+ (UIBezierPath *)roundedRectPathForRect:(CGRect)rect;
+ (CGGradientRef)backgroundGradient;

@end

@implementation NKNodeBackgroundView

- (void)dealloc 
{
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *backgroundPath = [[self class] roundedRectPathForRect:self.bounds];
    [backgroundPath addClip];
    
    CGFloat halfWidth = floor(self.bounds.size.width/2.0);
    CGContextDrawLinearGradient(context, [[self class] backgroundGradient], 
                                CGPointMake(halfWidth, 0), 
                                CGPointMake(halfWidth, self.bounds.size.height), 
                                kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
}

+ (UIBezierPath *)roundedRectPathForRect:(CGRect)rect
{
    static UIBezierPath *backgroundPath = nil;
    if (!backgroundPath) 
    {
        backgroundPath = [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:15] retain];
    }
    return backgroundPath;
}

+ (CGGradientRef)backgroundGradient
{
    static CGGradientRef gradientRef = NULL;
    if (!gradientRef) 
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.0f, 1.0f};
        NSArray *colors = [NSArray arrayWithObjects:
                           kNKNodeBackgroundViewTopGradientColor, 
                           kNKNodeBackgroundViewBottomGradientColor,
                           nil];
        gradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
        CGColorSpaceRelease(colorSpace);
    }
    return gradientRef;
}

@end
