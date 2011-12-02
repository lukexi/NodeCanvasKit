//
//  NKShapeView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 11/28/11.
//  Copyright (c) 2011 Eeoo. All rights reserved.
//

#import "NKShapeView.h"

@implementation NKShapeView
@synthesize fillColor, strokeColor, path;

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)coder 
{    
    self = [super initWithCoder:coder];
    if (self) 
    {
        [self commonInit];
    }
    return self;
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

- (void)drawRect:(CGRect)rect
{
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [self.path fill];
    [self.path stroke];
}

@end
