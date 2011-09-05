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
    CGFloat inletSize = self.bounds.size.height - 10;
    CGRect inletRect = CGRectMake(5, 5, inletSize, inletSize);
    [kNKNodeInletColor set];
    CGContextFillEllipseInRect(context, inletRect);
    [[UIColor blackColor] set];
    CGContextSetLineWidth(context, 2);
    CGContextStrokeEllipseInRect(context, inletRect);
}

@end
