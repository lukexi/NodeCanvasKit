//
//  NKNodeInletView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeInletView.h"

#define kNKNodeInletLeftMargin 5

@implementation NKNodeInletView
@synthesize slider;
@synthesize label;

- (void)dealloc 
{
    [slider release];
    [label release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        CGFloat thirds = floor((frame.size.width - kNKNodeInletLeftMargin) / 3);
        self.slider = [[[UISlider alloc] initWithFrame:CGRectMake(kNKNodeInletLeftMargin, 0, 2 * thirds, frame.size.height)] autorelease];
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(kNKNodeInletLeftMargin + 2 * thirds, 0, 1 * thirds, frame.size.height)] autorelease];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        
        [self addSubview:self.slider];
        [self addSubview:self.label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
