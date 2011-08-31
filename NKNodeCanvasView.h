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

@class NKNodeCanvasView;
@protocol NKNodeCanvasViewDelegate <NSObject>

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
connectedOutletNamed:(NSString *)outletName
       ofNodeNamed:(NSString *)outletParentNodeName
      toInletNamed:(NSString *)inlet
       ofNodeNamed:(NSString *)inletParentNodeName;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas 
disconnectedOutletNamed:(NSString *)outletName
       ofNodeNamed:(NSString *)outletParentNodeName
    fromInletNamed:(NSString *)inlet
       ofNodeNamed:(NSString *)inletParentNodeName;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
  removedNodeNamed:(NSString *)nodeName;

// Things to move to subclasses
- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
        inletNamed:(NSString *)inletName 
       ofNodeNamed:(NSString *)nodeName
  didChangeValueTo:(CGFloat)value;

- (void)nodeCanvas:(NKNodeCanvasView *)aNodeCanvas
        inletNamed:(NSString *)inletName 
       ofNodeNamed:(NSString *)nodeName
  didChangeRangeTo:(CGFloat)range;

@end

@interface NKNodeCanvasView : NKGridView <NKNodeViewControllerDelegate, NKWireViewDelegate>

+ (Class)nodeClass;

@property (nonatomic, assign) IBOutlet id <NKNodeCanvasViewDelegate> delegate;

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
              ofNodeWithID:(NSString *)outletParentNodeID;

- (void)setValueOfInletNamed:(NSString *)inletName 
                ofNodeWithID:(NSString *)nodeID 
                          to:(CGFloat)value;

- (void)setRangeOfInletNamed:(NSString *)inletName 
                ofNodeWithID:(NSString *)nodeID 
                          to:(CGFloat)range;

@end
