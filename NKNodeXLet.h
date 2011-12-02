//
//  NKNodeXLetView.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKNodeView;
@class NKWireView;
@interface NKNodeXLet : UIView

@property (weak, nonatomic, readonly) NKNodeView *parentNode;
@property (weak, nonatomic, readonly) NSArray *connections;
@property (nonatomic, strong) NSString *name;

+ (id)XLetForNode:(NKNodeView *)node;

- (void)addConnection:(NKWireView *)connection;
- (void)removeConnection:(NKWireView *)connection;
- (void)disconnectAllConnections;

- (void)updateConnections;

// Override to move the connection point — defaults to the center of the XLet
- (CGPoint)connectionPointInView:(UIView *)aView;

+ (CGSize)XLetSize;

@end
