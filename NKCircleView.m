//
//  NKCircleView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 11/26/11.
//  Copyright (c) 2011 Eeoo. All rights reserved.
//

#import "NKCircleView.h"

@implementation NKCircleView

- (void)awakeFromNib
{
    // Use the background color from the xib as a conveniece for setting the fill color
    self.fillColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    self.strokeColor = [UIColor blackColor];
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 2, 2)];
}

@end
