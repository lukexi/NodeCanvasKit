//
//  NKDragButton.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 11/28/11.
//  Copyright (c) 2011 Eeoo. All rights reserved.
//

#import "NKDragButton.h"

@interface NKDragButton () 
{
    CGFloat valueAtStartOfPan;
}
@end

@implementation NKDragButton
@synthesize isHighPrecisionEnabled;
@synthesize value;
@synthesize formatter;

- (void)commonInit
{
    self.isHighPrecisionEnabled = NO;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                                                 action:@selector(handlePanRecognizer:)];
    [self addGestureRecognizer:recognizer];
    recognizer.cancelsTouchesInView = NO;
    
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setIsHighPrecisionEnabled:(BOOL)flag
{
    isHighPrecisionEnabled = flag;
    [self setTitleColor:isHighPrecisionEnabled ? [UIColor orangeColor] : [UIColor darkGrayColor]
               forState:UIControlStateNormal];
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) 
    {
        valueAtStartOfPan = self.value;
    }
    CGPoint translation = [recognizer translationInView:self];
    CGFloat add = -translation.y;
    add = isHighPrecisionEnabled ? add / 10 : add;
    self.value = valueAtStartOfPan + add;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setValue:(CGFloat)aValue
{
    value = aValue;
    NSString *formattedValue = nil;
    if (self.formatter) 
    {
        formattedValue = self.formatter(value);
    }
    else
    {
        formattedValue = [NSString stringWithFormat:@"%.2f", self.value];
    }
    [self setTitle:formattedValue forState:UIControlStateNormal];
}

- (IBAction)buttonAction:(id)sender
{
    self.isHighPrecisionEnabled = !isHighPrecisionEnabled;
}

@end