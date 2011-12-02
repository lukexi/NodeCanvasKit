//
//  HSNodeSlider.m
//  Hypersurface
//
//  Created by Luke Iannini on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NKSlider.h"

@interface NKSlider ()

- (void)commonInit;

- (CGFloat)valueForXPosition:(CGFloat)xPosition;
- (CGFloat)rangeViewWidthForRange:(CGFloat)aRange;
- (CGFloat)thumbViewXPositionForValue:(CGFloat)aValue;

@end

@implementation NKSlider
@synthesize sliderView;
@synthesize thumbView;
@synthesize rangeView;
@synthesize value, range;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self commonInit];
    }
    return self;
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

- (void)commonInit
{
    UINib *nib = [UINib nibWithNibName:@"NKSlider" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    
    self.sliderView.frame = self.bounds;
    [self addSubview:self.sliderView];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self 
                                                                                           action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                       action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0;
    [self addGestureRecognizer:longPressRecognizer];
    
    self.value = 0.5;
    self.range = 0.5;
}

- (IBAction)handleLongPress:(id)sender 
{
    UILongPressGestureRecognizer *longPressRecognizer = sender;
    
    switch (longPressRecognizer.state) 
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:            
            self.value = [self valueForXPosition:[longPressRecognizer locationInView:self.sliderView].x];
            break;
        default:
            break;
    }
    [self.delegate sliderValueChanged:self];
}

- (IBAction)handlePinch:(id)sender 
{
    UIPinchGestureRecognizer *pinchRecognizer = sender;
    
    switch (pinchRecognizer.state) 
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            self.range = pinchRecognizer.scale;
            break;
        default:
            break;
    }
    
    [self.delegate sliderRangeChanged:self];
}

- (CGFloat)valueForXPosition:(CGFloat)xPosition
{
    CGFloat thumbWidth = self.thumbView.frame.size.width;
    return (xPosition - thumbWidth) / (self.bounds.size.width - thumbWidth);
}

- (CGFloat)rangeViewWidthForRange:(CGFloat)aRange
{
    return range * self.bounds.size.width;
}

- (CGFloat)thumbViewXPositionForValue:(CGFloat)aValue
{
    CGFloat thumbWidth = self.thumbView.frame.size.width;
    return (self.bounds.size.width - thumbWidth) * aValue;
}

- (void)setValue:(CGFloat)aValue
{
    aValue = MIN(aValue, 1);
    aValue = MAX(aValue, 0);
    value = aValue;
    CGRect thumbRect = self.thumbView.frame;
    thumbRect.origin.x = [self thumbViewXPositionForValue:aValue];
    self.thumbView.frame = thumbRect;
    self.rangeView.center = self.thumbView.center;
}

- (void)setRange:(CGFloat)aRange
{
    aRange = MIN(aRange, 1);
    aRange = MAX(aRange, 0);
    range = aRange;
    CGRect rangeRect = self.rangeView.frame;
    rangeRect.size.width = [self rangeViewWidthForRange:aRange];
    self.rangeView.frame = rangeRect;
    self.rangeView.center = self.thumbView.center;
}

@end

@implementation NKSliderThumbView

+ (UIBezierPath *)thumbPathWithSize:(CGFloat)size
{
    static UIBezierPath *thumbPath = nil;
    if (!thumbPath) 
    {
        thumbPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size, size) 
                                                cornerRadius:5];
    }
    return thumbPath;
}

+ (UIBezierPath *)gripPathWithHeight:(CGFloat)height
{
    static UIBezierPath *gripPath = nil;
    if (!gripPath) 
    {
        gripPath = [UIBezierPath bezierPath];
        [gripPath moveToPoint:CGPointMake(0, 0)];
        [gripPath addLineToPoint:CGPointMake(0, height)];
        //gripPath.lineCapStyle = kCGLineCapRound;
        gripPath.lineWidth = 2;
    }
    return gripPath;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *thumbPath = [[self class] thumbPathWithSize:self.bounds.size.width];
    [thumbPath addClip];
    
    // Background gradient
    CGFloat halfWidth = self.bounds.size.width/2;
    CGContextDrawLinearGradient(context, 
                                [[self class] backgroundGradient], 
                                CGPointMake(halfWidth, 0), 
                                CGPointMake(halfWidth, self.bounds.size.height), 
                                kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsBeforeStartLocation);
    // Outline
    [[UIColor blackColor] set];
    [thumbPath stroke];
    
    // Grips
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];
    CGFloat gripXSpacing = floor(self.bounds.size.width / 4);
    CGFloat gripYStart = self.bounds.size.height * 0.2;
    CGFloat gripHeight = self.bounds.size.height * 0.6;
    CGContextTranslateCTM(context, 0, gripYStart);
    for (NSUInteger i = 0; i < 3; i++) 
    {
        CGContextTranslateCTM(context, gripXSpacing, 0);
        [[[self class] gripPathWithHeight:gripHeight] stroke];
    }
}

#define kNKSliderThumbTopGradientColor [UIColor colorWithRed:0.696 green:0.399 blue:0.071 alpha:1.000]
#define kNKSliderThumbBottomGradientColor [UIColor colorWithRed:1.000 green:0.748 blue:0.126 alpha:1.000]

+ (CGGradientRef)backgroundGradient
{
    static CGGradientRef gradientRef = NULL;
    if (!gradientRef)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)kNKSliderThumbTopGradientColor.CGColor, 
                           (id)kNKSliderThumbBottomGradientColor.CGColor,
                           nil];
        gradientRef = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    return gradientRef;
}

@end

@implementation NKSliderTrackView

+ (UIBezierPath *)trackPathWithWidth:(CGFloat)width
{
    static UIBezierPath *trackPath = nil;
    static CGFloat lastWidth = 0;
    if (!trackPath || lastWidth != width) 
    {
        trackPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, 10) 
                                                cornerRadius:10];
    }
    return trackPath;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *trackPath = [[self class] trackPathWithWidth:self.bounds.size.width];
    [trackPath addClip];
    CGFloat halfWidth = self.bounds.size.width/2;
    CGContextDrawLinearGradient(context, 
                                [[self class] backgroundGradient], 
                                CGPointMake(halfWidth, 0), 
                                CGPointMake(halfWidth, self.bounds.size.height), 
                                kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsBeforeStartLocation);
}

#define kNKSliderTrackTopGradientColor [UIColor colorWithRed:0.000 green:0.286 blue:0.647 alpha:1.000]
#define kNKSliderTrackBottomGradientColor [UIColor colorWithRed:0.000 green:0.736 blue:0.772 alpha:1.000]
+ (CGGradientRef)backgroundGradient
{
    static CGGradientRef gradientRef = NULL;
    if (!gradientRef)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)kNKSliderTrackTopGradientColor.CGColor, 
                           (id)kNKSliderTrackBottomGradientColor.CGColor,
                           nil];
        gradientRef = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    return gradientRef;
}

@end

@implementation NKSliderRangeView



@end
