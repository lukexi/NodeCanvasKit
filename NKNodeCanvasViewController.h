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

@interface NKNodeCanvasViewController : UIViewController <NKNodeViewControllerDelegate, NKWireViewDelegate>
{
    
}

+ (Class)nodeClass;
- (UIView *)canvasView;

- (IBAction)addNode:(id)sender;
- (void)connectNode:(NKNodeViewController *)fromNode toNode:(NKNodeViewController *)toNode;
- (void)disconnectWire:(NKWireView *)wire;

@property (nonatomic, retain) NSMutableSet *nodeViewControllers;
@property (nonatomic, retain) NSMutableSet *wires;
@property (nonatomic, retain) NKNodeViewController *connectingNode;

@end
