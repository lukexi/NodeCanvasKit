//
//  NKNodeInletView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeInletView.h"

#define kNKNodeInletLeftMargin 5
#define kNKNodeInletLabelColor [UIColor colorWithRed:0.822 green:1.000 blue:0.020 alpha:1.000]
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
        [self setupControls];
    }
    return self;
}

- (void)setupControls
{
    CGFloat thirds = floor((self.frame.size.width - kNKNodeInletLeftMargin) / 3);
    self.slider = [[[UISlider alloc] initWithFrame:CGRectMake(kNKNodeInletLeftMargin, 
                                                              0, 
                                                              2 * thirds, 
                                                              self.frame.size.height)] autorelease];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    self.label = [[[UILabel alloc] initWithFrame:CGRectMake(kNKNodeInletLeftMargin + 2 * thirds, 
                                                            0, 
                                                            1 * thirds, 
                                                            self.frame.size.height)] autorelease];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
    self.label.font = [UIFont boldSystemFontOfSize:11];
    self.label.textColor = kNKNodeInletLabelColor;
    self.label.shadowColor = [UIColor blackColor];
    self.label.shadowOffset = CGSizeMake(0, -1);
    
    [self addSubview:self.slider];
    [self addSubview:self.label];
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
