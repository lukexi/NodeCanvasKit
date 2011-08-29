//
//  NKNodeXLetView.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKNodeViewController;
@class NKWireView;
@interface NKNodeXLet : UIView

+ (id)XLetForNode:(NKNodeViewController *)node withFrame:(CGRect)frame;

@property (nonatomic, assign, readonly) NKNodeViewController *parentNode;
@property (nonatomic, readonly) NSArray *connections;

- (void)addConnection:(NKWireView *)connection;
- (void)removeConnection:(NKWireView *)connection;
- (void)disconnectAllConnections;

- (void)updateConnections;

// Override to move the connection point — defaults to the center of the XLet
- (CGPoint)connectionPointInView:(UIView *)aView;

@end
