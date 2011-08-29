//
//  FFCanvas.h
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NKNodeViewController.h"
#import "NKWireView.h"

@class NKNodeCanvasViewController;
@protocol NKNodeCanvasViewControllerDelegate <NSObject>

- (void)nodeCanvas:(NKNodeCanvasViewController *)aNodeCanvas 
   connectedOutlet:(NKNodeOutlet *)outlet 
           toInlet:(NKNodeInlet *)inlet;

- (void)nodeCanvas:(NKNodeCanvasViewController *)aNodeCanvas 
disconnectedOutlet:(NKNodeOutlet *)outlet 
         fromInlet:(NKNodeInlet *)inlet;

@end

@interface NKNodeCanvasViewController : UIViewController <NKNodeViewControllerDelegate, NKWireViewDelegate>

+ (Class)nodeClass;

@property (nonatomic, readonly) UIView *canvasView;

- (IBAction)addNode:(id)sender;

- (void)connectOutlet:(NKNodeOutlet *)outlet toInlet:(NKNodeInlet *)inlet;
- (void)disconnectWire:(NKWireView *)wire;

- (void)addNode:(NKNodeViewController *)node atCenterPoint:(CGPoint)centerPoint;
- (void)removeNode:(NKNodeViewController *)node;

@property (nonatomic, retain) NSMutableSet *nodeViewControllers;
@property (nonatomic, retain) NSMutableSet *wires;

@end
