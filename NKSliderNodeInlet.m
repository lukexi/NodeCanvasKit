//
//  NKSliderNodeInlet.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/30/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKSliderNodeInlet.h"

#define kNKNodeInletLeftMargin 5
#define kNKNodeInletLabelColor [UIColor colorWithRed:0.903 green:0.571 blue:0.146 alpha:1.000]

@interface NKSliderNodeInlet () 

- (void)setupControls;

@end

@implementation NKSliderNodeInlet
@synthesize delegate;
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
    self.slider = [[[NKSlider alloc] initWithFrame:CGRectMake(kNKNodeInletLeftMargin, 
                                                              0, 
                                                              2 * thirds, 
                                                              self.frame.size.height)] autorelease];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    self.slider.delegate = self;
    
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

- (void)sliderValueChanged:(NKSlider *)aSlider
{
    [self.delegate sliderInletDidChangeValue:self];
}

- (void)sliderRangeChanged:(NKSlider *)aSlider
{
    [self.delegate sliderInletDidChangeRange:self];
}

@end
