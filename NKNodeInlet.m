//
//  NKNodeInletView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeInlet.h"

#define kNKNodeInletColor [UIColor colorWithRed:0.000 green:0.286 blue:0.647 alpha:1.000]

@interface NKNodeInlet ()

- (void)commonInit;

@end

@implementation NKNodeInlet

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
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect insetRect = CGRectInset(self.bounds, 5, 5);
    [kNKNodeInletColor set];
    CGContextFillEllipseInRect(context, insetRect);
    [[UIColor blackColor] set];
    CGContextSetLineWidth(context, 2);
    CGContextStrokeEllipseInRect(context, insetRect);
}

@end
