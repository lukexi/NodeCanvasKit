//
//  NKNodeXLetView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeXLet.h"
#import "NKNodeView.h"
#import "NKWireView.h"

@interface NKNodeXLet ()

@property (nonatomic, strong) NSMutableArray *mutableConnections;
@property (nonatomic, assign, readwrite) NKNodeView *parentNode;

@end

@implementation NKNodeXLet
@synthesize mutableConnections;
@synthesize parentNode;
@synthesize name;

+ (id)XLetForNode:(NKNodeView *)node
{
    CGSize XLetSize = [[self class] XLetSize];
    NKNodeXLet *XLet = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, XLetSize.width, XLetSize.height)];
    XLet.parentNode = node;
    return XLet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.mutableConnections = [NSMutableArray array];
    }
    return self;
}

- (CGPoint)connectionPointInView:(UIView *)aView
{
    return [aView convertPoint:self.center fromView:self.superview];
}

- (void)addConnection:(NKWireView *)connection
{
    [self.mutableConnections addObject:connection];
}

- (void)removeConnection:(NKWireView *)connection
{
    [self.mutableConnections removeObject:connection];
}

- (void)disconnectAllConnections
{
    // Use a copy, because we'll be mutating the array by disconnecting wires
    NSArray *connectionsCopy = [self.mutableConnections copy];
    for (NKWireView *connection in connectionsCopy) 
    {
        [connection disconnect];
        [connection removeFromSuperview];
    }
    [self.mutableConnections removeAllObjects];
}

- (NSArray *)connections
{
    return [self.mutableConnections copy];
}

- (void)updateConnections
{
    [self.connections makeObjectsPerformSelector:@selector(update)];
}

+ (CGSize)XLetSize
{
    return CGSizeMake(44, 44);
}

@end
