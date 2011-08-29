//
//  NKNodeXLetView.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeXLetView.h"
#import "NKNodeViewController.h"
#import "NKWireView.h"

@interface NKNodeXLetView ()

@property (nonatomic, retain) NSMutableArray *mutableConnections;
@property (nonatomic, assign, readwrite) NKNodeViewController *parentNode;

@end

@implementation NKNodeXLetView
@synthesize mutableConnections;
@synthesize parentNode;

- (void)dealloc 
{
    [mutableConnections release];
    [super dealloc];
}

+ (id)XLetForNode:(NKNodeViewController *)node withFrame:(CGRect)frame
{
    NKNodeXLetView *XLet = [[[[self class] alloc] initWithFrame:frame] autorelease];
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

- (void)removeAllConnections
{
    [self.mutableConnections removeAllObjects];
}

- (NSArray *)connections
{
    return self.mutableConnections;
}

- (void)updateConnections
{
    [self.connections makeObjectsPerformSelector:@selector(update)];
}

@end
