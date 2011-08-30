//
//  NKNodeInletView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeInlet.h"

#define kNKNodeInletColor [UIColor colorWithRed:0.000 green:0.286 blue:0.647 alpha:1.000]

@implementation NKNodeInlet

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
