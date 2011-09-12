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

- (Class)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
  classOfInletNamed:(NSString *)inletName
      forNodeWithID:(NSString *)nodeID;

// Things to factor out
- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
        inletNamed:(NSString *)inletName 
      ofNodeWithID:(NSString *)nodeID
  didChangeValueTo:(CGFloat)value;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
        inletNamed:(NSString *)inletName 
      ofNodeWithID:(NSString *)nodeID
  didChangeRangeTo:(CGFloat)range;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
connectionOfOutletNamed:(NSString *)outletName
      ofNodeWithID:(NSString *)outletParentNodeID
      toInletNamed:(NSString *)inlet
      ofNodeWithID:(NSString *)inletParentNodeID
    didChangeAmpTo:(CGFloat)amp;

@end

@interface NKNodeCanvasView : NKGridView <NKNodeViewControllerDelegate, NKWireViewDelegate, NKWireEditorViewControllerDelegate>

+ (Class)nodeClass;

@property (nonatomic, assign) IBOutlet id <NKNodeCanvasViewDelegate> delegate;

- (void)removeAllNodes;

- (void)addOutNode;
- (void)addNodeWithID:(NSString *)nodeID
                named:(NSString *)nodeName
           withInlets:(NSArray *)inletNames
              atPoint:(CGPoint)point
             animated:(BOOL)animated;

// Add to center
- (void)addNodeWithID:(NSString *)nodeID
                named:(NSString *)nodeName
           withInlets:(NSArray *)inletNames
             animated:(BOOL)animated;

- (void)connectOutletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)inletParentNodeID
              toInletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)outletParentNodeID
                     atAmp:(CGFloat)amp;

- (void)setValueOfInletNamed:(NSString *)inletName 
                ofNodeWithID:(NSString *)nodeID 
                          to:(CGFloat)value;

- (void)setRangeOfInletNamed:(NSString *)inletName 
                ofNodeWithID:(NSString *)nodeID 
                          to:(CGFloat)range;

@end
