//
//  FFWire.h
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NKNodeViewController.h"
#import "NKNodeInlet.h"
#import "NKNodeOutlet.h"

@class NKWireView;
@protocol NKWireViewDelegate <NSObject>

- (void)wireViewTapped:(NKWireView *)aWireView;

@end

@interface NKWireView : UIView

+ (NKWireView *)wireWithDelegate:(UIViewController <NKWireViewDelegate> *)delegate;
+ (NKWireView *)wireFrom:(NKNodeOutlet *)fromOutlet 
                      to:(NKNodeInlet *)toInlet 
                delegate:(UIViewController <NKWireViewDelegate> *)delegate;

@property (nonatomic, assign) UIViewController <NKWireViewDelegate> *delegate;
@property (nonatomic, retain) NKNodeOutlet *fromOutlet;
@property (nonatomic, retain) NKNodeInlet *toInlet;
@property (nonatomic) CGPoint endPoint;

- (void)update;
- (void)disconnect;

@end