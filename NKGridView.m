//
//  NKGridView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKGridView.h"

#define kNKGridViewBackgroundColor [UIColor colorWithRed:0.196 green:0.196 blue:0.200 alpha:1.000]
#define kNKGridViewLineColor [UIColor colorWithRed:0.251 green:0.251 blue:0.255 alpha:1.000]

@interface NKGridView ()

+ (UIBezierPath *)bezierPathForWidth:(CGFloat)width;
+ (UIBezierPath *)bezierPathForHeight:(CGFloat)height;
- (void)commonInit;
@end

#define kNKGridSpacing 44

@implementation NKGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    self.backgroundColor = kNKGridViewBackgroundColor;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [kNKGridViewLineColor set];
    
    CGContextSaveGState(context);
    UIBezierPath *verticalPath = [[self class] bezierPathForHeight:self.bounds.size.height];
    NSUInteger numVerticalPaths = ceil(self.bounds.size.width / kNKGridSpacing);
    for (NSUInteger i = 0; i < numVerticalPaths; i++) 
    {
        CGContextTranslateCTM(context, kNKGridSpacing, 0);
        [verticalPath stroke];
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    UIBezierPath *horizontalPath = [[self class] bezierPathForWidth:self.bounds.size.width];
    NSUInteger numHorizontalPaths = ceil(self.bounds.size.height / kNKGridSpacing);
    for (NSUInteger i = 0; i < numHorizontalPaths; i++) 
    {
        CGContextTranslateCTM(context, 0, kNKGridSpacing);
        [horizontalPath stroke];
    }
    CGContextRestoreGState(context);
}


+ (UIBezierPath *)bezierPathForHeight:(CGFloat)height
{
    static UIBezierPath *bezierPath = nil;
    static CGFloat pathHeight = 0;
    if (!bezierPath || pathHeight != height)
    {
        bezierPath = [[UIBezierPath bezierPath] retain];
        [bezierPath moveToPoint:CGPointMake(0.5, 0)];
        [bezierPath addLineToPoint:CGPointMake(0.5, height)];
        bezierPath.lineWidth = 1;
        pathHeight = height;
    }
    return bezierPath;
}

+ (UIBezierPath *)bezierPathForWidth:(CGFloat)width
{
    static UIBezierPath *bezierPath = nil;
    static CGFloat pathWidth = 0;
    if (!bezierPath || pathWidth != width)
    {
        bezierPath = [[UIBezierPath bezierPath] retain];
        [bezierPath moveToPoint:CGPointMake(0, 0.5)];
        [bezierPath addLineToPoint:CGPointMake(width, 0.5)];
        bezierPath.lineWidth = 1;
        pathWidth = width;
    }
    return bezierPath;
}

@end
