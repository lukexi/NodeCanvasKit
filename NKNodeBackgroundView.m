//
//  NKNodeBackgroundView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeBackgroundView.h"

#define kNKNodeBackgroundViewBottomGradientColor [UIColor colorWithRed:0.161 green:0.173 blue:0.224 alpha:1.000]
#define kNKNodeBackgroundViewTopGradientColor [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.790]
#define KNKNodeBackgroundViewHeaderColor [UIColor colorWithRed:0.693 green:0.680 blue:1.000 alpha:0.300]
#define KNKNodeBackgroundViewHeaderHeight 40.0f
#define kNKNodeBackgroundViewTriangleWidth 20.0f
#define kNKNodeBackgroundViewTriangleHeight 15.0f

@interface NKNodeBackgroundView ()

+ (UIBezierPath *)roundedRectPathForRect:(CGRect)rect;
+ (CGGradientRef)backgroundGradient;
+ (UIBezierPath *)decorativeTrianglePath;

- (void)commonInit;

@end

@implementation NKNodeBackgroundView

- (void)dealloc 
{
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.shadowPath = [[self class] roundedRectPathForRect:self.bounds].CGPath;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = 0.5;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *backgroundPath = [[self class] roundedRectPathForRect:self.bounds];
    [backgroundPath addClip];
    
    [[UIColor blackColor] set];
    [backgroundPath stroke];
    
    CGFloat halfWidth = floor(self.bounds.size.width/2.0);
    CGContextDrawLinearGradient(context, [[self class] backgroundGradient], 
                                CGPointMake(halfWidth, 0), 
                                CGPointMake(halfWidth, self.bounds.size.height), 
                                kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    
    [KNKNodeBackgroundViewHeaderColor set];
    
    CGFloat triangleYStart = KNKNodeBackgroundViewHeaderHeight - (kNKNodeBackgroundViewTriangleHeight/2) - 0.5;
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, triangleYStart));
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, triangleYStart);
    [[[self class] decorativeTrianglePath] fill];
    NSUInteger numTriangles = ceil(self.bounds.size.width / kNKNodeBackgroundViewTriangleWidth);
    for (NSUInteger i = 0; i < numTriangles; i++) 
    {
        CGContextTranslateCTM(context, kNKNodeBackgroundViewTriangleWidth, 0);
        [[[self class] decorativeTrianglePath] fill];
    }
    CGContextRestoreGState(context);
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

+ (UIBezierPath *)decorativeTrianglePath
{
    static UIBezierPath *decorativeTrianglePath = nil;
    if (!decorativeTrianglePath) 
    {
        decorativeTrianglePath = [[UIBezierPath bezierPath] retain];
        [decorativeTrianglePath moveToPoint:CGPointMake(0, 0)];
        [decorativeTrianglePath addLineToPoint:CGPointMake(kNKNodeBackgroundViewTriangleWidth, 0)];
        [decorativeTrianglePath addLineToPoint:CGPointMake(kNKNodeBackgroundViewTriangleWidth/2, 
                                                           kNKNodeBackgroundViewTriangleHeight)];
        [decorativeTrianglePath closePath];
    }
    return decorativeTrianglePath;
}

+ (CGGradientRef)backgroundGradient
{
    static CGGradientRef gradientRef = NULL;
    if (!gradientRef)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)kNKNodeBackgroundViewTopGradientColor.CGColor, 
                           (id)kNKNodeBackgroundViewBottomGradientColor.CGColor,
                           nil];
        gradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    return gradientRef;
}

@end
