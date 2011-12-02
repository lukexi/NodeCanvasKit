    //
//  NKWireView.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKWireView.h"

@interface NKWireView ()

+ (UIBezierPath *)arrowPath;
+ (UIBezierPath *)dotPath;

@property (nonatomic, strong) UIBezierPath *dotPath;
@property (nonatomic, strong) UIBezierPath *wirePath;
@property (nonatomic, strong) UIBezierPath *arrowPath;

- (CGRect)centeredRectOfSize:(CGFloat)size;

@end

#define KNKWireArrowSize 24.0f
#define KNKWireWidth 4.0f
#define KNKWireDotSize 20.0f

@implementation NKWireView
@synthesize representedObject;
@synthesize fromOutlet;
@synthesize toInlet;
@synthesize endPoint;
@synthesize wirePath, arrowPath, dotPath;
@synthesize delegate;
@synthesize amp;

+ (NKWireView *)wireWithDelegate:(UIView <NKWireViewDelegate> *)delegate;
{
    NKWireView *wire = [[self alloc] initWithFrame:CGRectZero];
    wire.delegate = delegate;
    return wire;
}

+ (NKWireView *)wireFrom:(NKNodeOutlet *)fromOutlet 
                      to:(NKNodeInlet *)toInlet 
                   atAmp:(CGFloat)amp
                delegate:(UIView <NKWireViewDelegate> *)delegate;
{
    NKWireView *wire = [self wireWithDelegate:delegate];
    
    if (fromOutlet) 
    {
        wire.fromOutlet = fromOutlet;
        [fromOutlet addConnection:wire];
    }

    if (toInlet) 
    {
        wire.toInlet = toInlet;
        [toInlet addConnection:wire];
    }
    wire.amp = amp;
    
    [wire update];
    
    return wire;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(wireTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        // For debugging:
        //self.view.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)wireTapped:(UITapGestureRecognizer *)recognizer
{
    [self.delegate wireViewTapped:self];
}

- (void)update
{
    CGPoint inCenter = [self.fromOutlet connectionPointInView:self.delegate];
    CGPoint outCenter = [self.toInlet connectionPointInView:self.delegate];
    if (!self.toInlet)
    {
        outCenter = self.endPoint;
    }
    
    CGFloat frameInset = KNKWireWidth + KNKWireArrowSize;
    CGRect centersFrame = CGRectMake(MIN(inCenter.x, outCenter.x), MIN(inCenter.y, outCenter.y), 
                                     ABS(inCenter.x - outCenter.x), ABS(inCenter.y - outCenter.y));
    self.frame = CGRectInset(centersFrame, -frameInset, -frameInset);
    
    CGPoint inPosition = CGPointMake(inCenter.x < outCenter.x ? frameInset : (self.bounds.size.width - frameInset),
                                     inCenter.y < outCenter.y ? frameInset : (self.bounds.size.height - frameInset));
    
    CGPoint outPosition = CGPointMake(inCenter.x < outCenter.x ? (self.bounds.size.width - frameInset) : frameInset,
                                      inCenter.y < outCenter.y ? (self.bounds.size.height - frameInset) : frameInset);
    
    self.wirePath = [UIBezierPath bezierPath];
    self.wirePath.lineWidth = KNKWireWidth;
    self.wirePath.lineCapStyle = kCGLineCapRound;
    
    [self.wirePath moveToPoint:inPosition];
    [self.wirePath addLineToPoint:outPosition];
    
    self.arrowPath = [[self class] arrowPath];
    CGFloat angle = -atan2(outPosition.x - inPosition.x, outPosition.y - inPosition.y);
    [self.arrowPath applyTransform:CGAffineTransformMakeRotation(angle)];
    [self.arrowPath applyTransform:CGAffineTransformMakeTranslation(outPosition.x, outPosition.y)];
    
    self.dotPath = [[self class] dotPath];
    CGRect dotRect = [self centeredRectOfSize:KNKWireDotSize];
    [self.dotPath applyTransform:CGAffineTransformMakeTranslation(dotRect.origin.x, dotRect.origin.y)];
}

- (CGRect)centeredRectOfSize:(CGFloat)size
{
    CGFloat halfSize = size / 2.0;
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    return CGRectMake(midX - halfSize, midY - halfSize, size, size);
}

- (void)disconnect
{
    [self.fromOutlet removeConnection:self];
    [self.toInlet removeConnection:self];
}

+ (UIBezierPath *)arrowPath
{
    static UIBezierPath *cachedArrowPath = nil;
    if (!cachedArrowPath) 
    {
        CGFloat halfArrowSize = KNKWireArrowSize / 2;
        cachedArrowPath = [UIBezierPath bezierPath];
        [cachedArrowPath moveToPoint:CGPointMake(-halfArrowSize, -KNKWireArrowSize)];
        [cachedArrowPath addLineToPoint:CGPointMake(halfArrowSize, -KNKWireArrowSize)];
        [cachedArrowPath addLineToPoint:CGPointMake(0, 0)];
        [cachedArrowPath closePath];
    }
    return [cachedArrowPath copy];
}

+ (UIBezierPath *)dotPath
{
    static UIBezierPath *dotPath = nil;
    if (!dotPath) 
    {
        dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, KNKWireDotSize, KNKWireDotSize)];
    }
    return [dotPath copy];
}


- (void)setWirePath:(UIBezierPath *)aPath
{
    if (wirePath != aPath) 
    {
        wirePath = aPath;
        [self setNeedsDisplay];
    }
}

- (void)setArrowPath:(UIBezierPath *)aPath
{
    if (arrowPath != aPath) 
    {
        arrowPath = aPath;
        [self setNeedsDisplay];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint([self centeredRectOfSize:44], point);
}


- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];
    self.wirePath.lineWidth = 6;
    [self.wirePath stroke];
    self.wirePath.lineWidth = 4;
    [self.arrowPath stroke];
    [[UIColor purpleColor] set];
    [self.wirePath stroke];
    [self.arrowPath fill];
    
    [self.dotPath stroke];
    [self.dotPath fill];
}

@end