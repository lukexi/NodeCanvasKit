//
//  NKNodeOutletView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeOutlet.h"

@implementation NKNodeOutlet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect insetRect = CGRectInset(self.bounds, 5, 5);
    [[UIColor greenColor] set];
    CGContextFillEllipseInRect(context, insetRect);
    [[UIColor blackColor] set];
    CGContextSetLineWidth(context, 2);
    CGContextStrokeEllipseInRect(context, insetRect);
}


@end
