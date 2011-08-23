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

@class NKWireView;
@protocol NKWireViewDelegate <NSObject>

- (void)wireViewTapped:(NKWireView *)aWireView;

@end

@interface NKWireView : UIView

+ (NKWireView *)wireWithDelegate:(id <NKWireViewDelegate>)delegate;
+ (NKWireView *)wireFrom:(NKNodeViewController *)fromNode to:(NKNodeViewController *)toNode delegate:(id <NKWireViewDelegate>)delegate;

@property (nonatomic, assign) id <NKWireViewDelegate> delegate;
@property (nonatomic, retain) NKNodeViewController *inNode;
@property (nonatomic, retain) NKNodeViewController *outNode;
@property (nonatomic) CGPoint endPoint;

- (void)update;

@end