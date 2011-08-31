    //
//  FFCanvas.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeCanvasView.h"
#import "NKOutNodeViewController.h"
#import "NKNodeOutlet.h"

@interface NKNodeCanvasView ()

- (void)commonInit;

- (void)connectOutlet:(NKNodeOutlet *)outlet toInlet:(NKNodeInlet *)inlet;
- (void)disconnectWire:(NKWireView *)wire;

- (void)addNode:(NKNodeViewController *)node atCenterPoint:(CGPoint)centerPoint;
- (void)removeNode:(NKNodeViewController *)node;

@property (nonatomic, retain) NSMutableSet *nodeViewControllers;
@property (nonatomic, retain) NSMutableSet *wires;

@property (nonatomic, retain) NKWireView *draggingWire;
@property (nonatomic, retain) NKWireView *selectedWire;
@property (nonatomic, retain) NKNodeViewController *selectedNode;

@end


@implementation NKNodeCanvasView
@synthesize nodeViewControllers;
@synthesize wires;
@synthesize draggingWire, selectedWire;
@synthesize selectedNode;
@synthesize delegate;

- (void)dealloc 
{
    [selectedNode release];
    [selectedWire release];
    [draggingWire release];
    [nodeViewControllers release];
    [wires release];
    [super dealloc];
}

+ (Class)nodeClass
{
    return [NKNodeViewController class];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
	self.nodeViewControllers = [NSMutableSet set];
    self.wires = [NSMutableSet set];
}

- (void)addNodeNamed:(NSString *)nodeName withInlets:(NSArray *)inletNames animated:(BOOL)animated
{
    NKNodeViewController *node = [[[self class] nodeClass] nodeWithName:nodeName
                                                             inletNames:inletNames];
    
    CGPoint nodeCenter = CGPointMake(self.bounds.size.width / 2, 
                                     self.bounds.size.height / 2);
    
    [self addNode:node atCenterPoint:nodeCenter];
    
    if (animated) 
    {
        node.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 animations:^(void) {
            node.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^(void) {
                node.view.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)addNode:(NKNodeViewController *)node atCenterPoint:(CGPoint)centerPoint
{
    node.view.center = centerPoint;
    [self.nodeViewControllers addObject:node];
    node.delegate = self;
    [self addSubview:node.view];
}

- (void)addOutNode
{
    NKOutNodeViewController *outNode = [NKOutNodeViewController outNode];
    
    CGPoint outletCenter = CGPointMake(CGRectGetMidX(self.bounds), 
                                       self.bounds.size.height - (outNode.view.bounds.size.height/2) - 44);
    
    [self addNode:outNode atCenterPoint:outletCenter];
}

- (void)node:(NKNodeViewController *)node wasTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:node.view.frame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    self.selectedNode = node;
    self.selectedWire = nil;
}

- (void)node:(NKNodeViewController *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [node moveToTouchAdjustedPoint:[gestureRecognizer locationInView:self]];
}

- (void)outlet:(NKNodeOutlet *)outlet didDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInView = [gestureRecognizer locationInView:self];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.draggingWire = [NKWireView wireFrom:outlet to:nil delegate:self];
            [self addSubview:self.draggingWire];
        case UIGestureRecognizerStateChanged:
            self.draggingWire.endPoint = locationInView;
            [self.draggingWire update];
            break;
        case UIGestureRecognizerStateEnded:
            for (NKNodeViewController *nodeViewController in self.nodeViewControllers) 
            {
                NKNodeInlet *foundInlet = [nodeViewController inletForPointInSuperview:locationInView];
                if (foundInlet)
                {
                    if (nodeViewController == outlet.parentNode) 
                    {
                        NSLog(@"Self-feedback connections are not yet supported.");
                    }
                    [self connectOutlet:outlet toInlet:foundInlet];
                    
                    [self.delegate nodeCanvas:self 
                         connectedOutletNamed:outlet.name
                                  ofNodeNamed:outlet.parentNode.name 
                                 toInletNamed:foundInlet.name 
                                  ofNodeNamed:foundInlet.parentNode.name];
                }
            }
        case UIGestureRecognizerStateCancelled:
            [self.draggingWire removeFromSuperview];
            self.draggingWire = nil;
        default:
            break;
    }
}

- (void)inletDidChangeValue:(NKSliderNodeInlet *)inlet
{
    [self.delegate nodeCanvas:self 
                   inletNamed:inlet.name 
                  ofNodeNamed:inlet.parentNode.name
             didChangeValueTo:inlet.slider.value];
}

- (void)inletDidChangeRange:(NKSliderNodeInlet *)inlet
{
    [self.delegate nodeCanvas:self 
                   inletNamed:inlet.name 
                  ofNodeNamed:inlet.parentNode.name
             didChangeRangeTo:inlet.slider.range];
}

- (void)connectOutlet:(NKNodeOutlet *)outlet toInlet:(NKNodeInlet *)inlet
{
    NKWireView *wire = [NKWireView wireFrom:outlet to:inlet delegate:self];
    [self.wires addObject:wire];
    [self addSubview:wire];
}

- (void)disconnectWire:(NKWireView *)wire
{
    [[wire retain] autorelease];
    [wire disconnect];
    [self.wires removeObject:wire];
    [UIView animateWithDuration:0.5 animations:^(void) {
        wire.alpha = 0;
        wire.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [wire removeFromSuperview];
    }];
}

- (void)removeNode:(NKNodeViewController *)node
{
    [[node retain] autorelease];
    [node disconnectAllXLets];
    [self.nodeViewControllers removeObject:node];
    [UIView animateWithDuration:0.5 animations:^(void) {
        node.view.alpha = 0;
        node.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [node.view removeFromSuperview];
    }];
}

- (void)wireViewTapped:(NKWireView *)aWireView
{
    [self becomeFirstResponder];
    CGRect frame = aWireView.frame;
    CGFloat halfHeight = frame.size.height / 2;
    frame.origin.y += halfHeight;
    frame.size.height = halfHeight;
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    self.selectedNode = nil;
    self.selectedWire = aWireView;
}

- (void)delete:(id)sender
{
    if (self.selectedWire) 
    {
        [self disconnectWire:self.selectedWire];
        [self.delegate nodeCanvas:self 
          disconnectedOutletNamed:self.selectedWire.fromOutlet.name 
                      ofNodeNamed:self.selectedWire.fromOutlet.parentNode.name 
                   fromInletNamed:self.selectedWire.toInlet.name 
                      ofNodeNamed:self.selectedWire.toInlet.parentNode.name];
        self.selectedWire = nil;
    }
    else if (self.selectedNode)
    {
        [self removeNode:self.selectedNode];
        [self.delegate nodeCanvas:self removedNodeNamed:self.selectedNode.name];
        self.selectedNode = nil;
    }
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id) sender 
{
    if (selector == @selector(delete:)) 
    {
        return YES;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


@end
