    //
//  NKWireView.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKWireView.h"

@interface NKWireView ()

+ (UIBezierPath *)cachedArrowPath;

@property (nonatomic, retain) UIBezierPath *wirePath;
@property (nonatomic, retain) UIBezierPath *arrowPath;
@property (nonatomic) CGPathRef hitPath;

- (void)updateHitPath;

@end

#define KNKWireArrowSize 24.0f
#define KNKWireWidth 4.0f

@implementation NKWireView
@synthesize representedObject;
@synthesize fromOutlet;
@synthesize toInlet;
@synthesize endPoint;
@synthesize wirePath, arrowPath;
@synthesize hitPath;
@synthesize delegate;
@synthesize amp;

+ (NKWireView *)wireWithDelegate:(UIView <NKWireViewDelegate> *)delegate;
{
    NKWireView *wire = [[[self alloc] initWithFrame:CGRectZero] autorelease];
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
        UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(wireTapped:)] autorelease];
        [self addGestureRecognizer:tapRecognizer];
        
        // For debugging:
        //self.view.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.5];
        
//        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        editButton.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//        [self addSubview:editButton];
//        editButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
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
    
    CGFloat frameOutset = KNKWireWidth + KNKWireArrowSize;
    CGRect centersFrame = CGRectMake(MIN(inCenter.x, outCenter.x), MIN(inCenter.y, outCenter.y), 
                                     ABS(inCenter.x - outCenter.x), ABS(inCenter.y - outCenter.y));
    self.frame = CGRectInset(centersFrame, -frameOutset, -frameOutset);
    
    CGPoint inPosition = CGPointMake(inCenter.x < outCenter.x ? frameOutset : (self.bounds.size.width - frameOutset),
                                     inCenter.y < outCenter.y ? frameOutset : (self.bounds.size.height - frameOutset));
    
    CGPoint outPosition = CGPointMake(inCenter.x < outCenter.x ? (self.bounds.size.width - frameOutset) : frameOutset,
                                      inCenter.y < outCenter.y ? (self.bounds.size.height - frameOutset) : frameOutset);
    
    self.wirePath = [UIBezierPath bezierPath];
    self.wirePath.lineWidth = KNKWireWidth;
    self.wirePath.lineCapStyle = kCGLineCapRound;
    
    [self.wirePath moveToPoint:inPosition];
    [self.wirePath addLineToPoint:outPosition];
    
    self.arrowPath = [[self class] cachedArrowPath];
    CGFloat angle = -atan2(outPosition.x - inPosition.x, outPosition.y - inPosition.y);
    [self.arrowPath applyTransform:CGAffineTransformMakeRotation(angle)];
    [self.arrowPath applyTransform:CGAffineTransformMakeTranslation(outPosition.x, outPosition.y)];
}

- (void)disconnect
{
    [self.fromOutlet removeConnection:self];
    [self.toInlet removeConnection:self];
}

+ (UIBezierPath *)cachedArrowPath
{
    static UIBezierPath *cachedArrowPath = nil;
    if (!cachedArrowPath) 
    {
        CGFloat halfArrowSize = KNKWireArrowSize / 2;
        cachedArrowPath = [[UIBezierPath bezierPath] retain];
        [cachedArrowPath moveToPoint:CGPointMake(-halfArrowSize, -KNKWireArrowSize)];
        [cachedArrowPath addLineToPoint:CGPointMake(halfArrowSize, -KNKWireArrowSize)];
        [cachedArrowPath addLineToPoint:CGPointMake(0, 0)];
        [cachedArrowPath closePath];
    }
    return [[cachedArrowPath copy] autorelease];
}

- (void)dealloc 
{
    CGPathRelease(hitPath);
    [representedObject release];
    [wirePath release];
    [arrowPath release];
    [fromOutlet release];
    [toInlet release];
    [super dealloc];
}

- (void)setWirePath:(UIBezierPath *)aPath
{
    if (wirePath != aPath) 
    {
        [wirePath autorelease];
        wirePath = [aPath retain];
        [self setNeedsDisplay];
    }
}

- (void)setArrowPath:(UIBezierPath *)aPath
{
    if (arrowPath != aPath) 
    {
        [arrowPath autorelease];
        arrowPath = [aPath retain];
        [self setNeedsDisplay];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGPathContainsPoint(hitPath, NULL, point, NO);
}

// Must be called from within drawRect so there's a context to use...
- (void)updateHitPath
{
    CGPathRef pathRef = self.wirePath.CGPath;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, pathRef);
    CGContextSetLineWidth(context, 30);
    CGContextReplacePathWithStrokedPath(context);
    
    CGPathRelease(hitPath);
    hitPath = CGContextCopyPath(context);
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
    
    [self updateHitPath];
}

@end