//
//  FFCanvas.h
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NKNodeView.h"
#import "NKWireView.h"
#import "NKGridView.h"
#import "NKWireEditorViewController.h"

@class NKNodeCanvasView;
@protocol NKNodeCanvasViewDelegate <NSObject>

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
connectedOutletNamed:(NSString *)outletName
      ofNodeWithID:(NSString *)outletParentNodeID
      toInletNamed:(NSString *)inlet
      ofNodeWithID:(NSString *)inletParentNodeID;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
disconnectedOutletNamed:(NSString *)outletName
      ofNodeWithID:(NSString *)outletParentNodeID
    fromInletNamed:(NSString *)inlet
      ofNodeWithID:(NSString *)inletParentNodeID;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
removedNodeWidthID:(NSString *)nodeID;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
   movedNodeWithID:(NSString *)nodeID
           toPoint:(CGPoint)point;

// Things to factor out

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
connectionOfOutletNamed:(NSString *)outletName
      ofNodeWithID:(NSString *)outletParentNodeID
      toInletNamed:(NSString *)inlet
      ofNodeWithID:(NSString *)inletParentNodeID
    didChangeAmpTo:(CGFloat)amp;

@end

@protocol NKNodeCanvasViewDataSource <NKNodeViewDataSource>

- (NKNodeView *)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
     nodeViewForNodeWithID:(NSString *)nodeID;

/*
// Lets our dataSource configure its own NKWireView subclass, such as one with an amplitude and delegate, etc.
- (NKWireView *)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
wireForConnectionFromOutletNamed:(NSString *)outletName
              ofNodeWithID:(NSString *)inletParentNodeID
              toInletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)outletParentNodeID;
*/

@end

@interface NKNodeCanvasView : NKGridView <NKNodeViewControllerDelegate, NKWireViewDelegate, NKWireEditorViewControllerDelegate>

@property (nonatomic, weak) IBOutlet id <NKNodeCanvasViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <NKNodeCanvasViewDataSource> dataSource;

- (NKNodeView *)nodeViewWithID:(NSString *)nodeID;
- (void)removeAllNodes;

- (void)addNodeInCenterWithID:(NSString *)nodeID
                     animated:(BOOL)animated;

- (void)addNodeWithID:(NSString *)nodeID
              atPoint:(CGPoint)point
             animated:(BOOL)animated;



- (void)connectOutletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)inletParentNodeID
              toInletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)outletParentNodeID
                     atAmp:(CGFloat)amp;

@end
