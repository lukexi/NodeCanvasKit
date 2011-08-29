//
//  NKOutletNodeBackgroundView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKSpiralView.h"

#define kNKSpiralBackgroundColor [UIColor colorWithRed:1.000 green:0.459 blue:1.000 alpha:1.000]
#define kNKSpiralStrokeColor [UIColor colorWithRed:0.273 green:0.002 blue:1.000 alpha:1.000]
#define kNKSpiralIterations 30
#define kNKSpiralAngleStep M_PI_4
#define kNKSpiralAnglePeriod 8
@implementation NKSpiralView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self startAnimating];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) 
    {
        [self startAnimating];
    }
    return self;
}

- (void)startAnimating
{
    CGFloat numRotations = 10000;
    CGFloat finalRotationAngle = -numRotations*2*M_PI;
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:0];
    spinAnimation.toValue = [NSNumber numberWithFloat:finalRotationAngle];
    
    spinAnimation.duration = numRotations * 4; //seconds per rotation
    
    [self.layer addAnimation:spinAnimation forKey:nil];
}

- (void)drawRect:(CGRect)rect
{
    [kNKSpiralBackgroundColor set];
    
    [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
    
    [kNKSpiralStrokeColor set];
    
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radiusStep = self.bounds.size.width / kNKSpiralIterations / 2;
    for (NSUInteger i = 0; i < kNKSpiralIterations; i++) 
    {
        CGFloat startAngle = (i%kNKSpiralAnglePeriod) * kNKSpiralAngleStep;
        CGFloat endAngle = ((i+1)%kNKSpiralAnglePeriod) * kNKSpiralAngleStep;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:boundsCenter 
                                                            radius:radiusStep * i 
                                                        startAngle:startAngle 
                                                          endAngle:endAngle 
                                                         clockwise:YES];
        path.lineWidth = 4;
        [path stroke];
    }
    
}


@end
