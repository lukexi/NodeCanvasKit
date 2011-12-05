    //
//  FFCanvas.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeCanvasView.h"
#import "NKOutNodeView.h"
#import "NKNodeOutlet.h"

@interface NKNodeCanvasView ()

- (void)commonInit;

- (void)connectOutlet:(NKNodeOutlet *)outlet toInlet:(NKNodeInlet *)inlet atAmp:(CGFloat)amp;
- (void)disconnectWire:(NKWireView *)wire;

- (void)addNode:(NKNodeView *)node atCenterPoint:(CGPoint)centerPoint;
- (void)removeNode:(NKNodeView *)node;

@property (nonatomic, strong) NSMutableDictionary *nodesByID;
@property (nonatomic, strong) NSMutableSet *wires;

@property (nonatomic, strong) NKWireView *draggingWire;
@property (nonatomic, strong) NKWireView *selectedWire;
@property (nonatomic, strong) NKNodeView *selectedNode;
@property (nonatomic, strong) UIPopoverController *currentPopoverController;

- (void)showPopover:(UIPopoverController *)popoverController fromRect:(CGRect)rect;
- (void)dismissCurrentPopover;

@end


@implementation NKNodeCanvasView
@synthesize nodesByID;
@synthesize wires;
@synthesize draggingWire, selectedWire;
@synthesize selectedNode;
@synthesize delegate;
@synthesize currentPopoverController;
@synthesize dataSource;

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
	self.nodesByID = [NSMutableDictionary dictionary];
    self.wires = [NSMutableSet set];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                  action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:recognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    // Dismiss delete menu if tapping off the selected node
    
    if ([[UIMenuController sharedMenuController] isMenuVisible] && !CGRectContainsPoint(self.selectedNode.frame, 
                                                                                        [recognizer locationInView:self])) 
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO 
                                                       animated:YES];
    }
}

- (NKNodeView *)nodeViewWithID:(NSString *)nodeID
{
    return [self.nodesByID objectForKey:nodeID];
}

- (void)addNodeInCenterWithID:(NSString *)nodeID
                     animated:(BOOL)animated;
{
    CGPoint nodeCenter = CGPointMake(self.bounds.size.width / 2, 
                                     self.bounds.size.height / 2);
    [self addNodeWithID:nodeID
                atPoint:nodeCenter 
               animated:animated];
}

- (void)addNodeWithID:(NSString *)nodeID
              atPoint:(CGPoint)point
             animated:(BOOL)animated
{
    NKNodeView *node = [self.dataSource nodeCanvas:self nodeViewForNodeWithID:nodeID];
    
    [self addNode:node atCenterPoint:point];
    
    if (animated) 
    {
        node.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 animations:^(void) {
            node.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^(void) {
                node.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)connectOutletNamed:(NSString *)outletName
              ofNodeWithID:(NSString *)outletParentNodeID
              toInletNamed:(NSString *)inletName
              ofNodeWithID:(NSString *)inletParentNodeID
                     atAmp:(CGFloat)amp;
{
    NKNodeView *outletParentNode = [self nodeViewWithID:outletParentNodeID];
    NKNodeView *inletParentNode = [self nodeViewWithID:inletParentNodeID];
    
    [self connectOutlet:[outletParentNode outletNamed:outletName] 
                toInlet:[inletParentNode inletNamed:inletName]
                  atAmp:amp];
}

- (void)addNode:(NKNodeView *)node atCenterPoint:(CGPoint)centerPoint
{
    node.center = centerPoint;
    [self.nodesByID setObject:node forKey:node.nodeID];
    node.delegate = self;
    [self addSubview:node];
}

- (void)nodeWasTapped:(NKNodeView *)node
{
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:node.frame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    self.selectedNode = node;
    self.selectedWire = nil;
}

- (void)node:(NKNodeView *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    // Constrain to screen edges
    CGPoint location = [gestureRecognizer locationInView:self];
    location.x = MAX(0, MIN(location.x, self.bounds.size.width));
    location.y = MAX(0, MIN(location.y, self.bounds.size.height));
    
    [node moveToTouchAdjustedPoint:[gestureRecognizer locationInView:self]];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) 
    {
        [self.delegate nodeCanvas:self 
                  movedNodeWithID:node.nodeID 
                          toPoint:node.center];
    }
}

- (void)outlet:(NKNodeOutlet *)outlet didDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInView = [gestureRecognizer locationInView:self];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.draggingWire = [NKWireView wireFrom:outlet to:nil atAmp:0 delegate:self];
            [self addSubview:self.draggingWire];
        case UIGestureRecognizerStateChanged:
            self.draggingWire.endPoint = locationInView;
            [self.draggingWire update];
            break;
        case UIGestureRecognizerStateEnded:
            for (NKNodeView *nodeViewController in [self.nodesByID allValues]) 
            {
                NKNodeInlet *foundInlet = [nodeViewController inletForPointInSuperview:locationInView];
                if (foundInlet)
                {
                    if (nodeViewController == outlet.parentNode) 
                    {
                        NSLog(@"Self-feedback connections are not yet supported.");
                    }
                    [self connectOutlet:outlet toInlet:foundInlet atAmp:1];
                    
                    [self.delegate nodeCanvas:self 
                         connectedOutletNamed:outlet.name
                                 ofNodeWithID:outlet.parentNode.nodeID 
                                 toInletNamed:foundInlet.name 
                                 ofNodeWithID:foundInlet.parentNode.nodeID];
                }
            }
        case UIGestureRecognizerStateCancelled:
            [self.draggingWire removeFromSuperview];
            self.draggingWire = nil;
        default:
            break;
    }
}

- (void)connectOutlet:(NKNodeOutlet *)outlet toInlet:(NKNodeInlet *)inlet atAmp:(CGFloat)amp
{
    NKWireView *wire = [NKWireView wireFrom:outlet to:inlet atAmp:amp delegate:self];
    [self.wires addObject:wire];
    [self addSubview:wire];
}

- (void)disconnectWire:(NKWireView *)wire
{
    [wire disconnect];
    [self.wires removeObject:wire];
    [UIView animateWithDuration:0.5 animations:^(void) {
        wire.alpha = 0;
        wire.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [wire removeFromSuperview];
    }];
}

- (void)removeNode:(NKNodeView *)node
{
    [node disconnectAllXLets];
    [self.nodesByID removeObjectForKey:node.nodeID];
    [UIView animateWithDuration:0.5 animations:^(void) {
        node.alpha = 0;
        node.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [node removeFromSuperview];
    }];
}

- (void)removeAllNodes
{
    for (NKNodeView *node in [[[self nodesByID] allValues] copy])
    {
        [self removeNode:node];
    }
}

- (void)wireViewTapped:(NKWireView *)aWireView
{
    CGRect frame = aWireView.frame;
    CGFloat halfHeight = frame.size.height / 2;
    frame.origin.y += halfHeight;
    frame.size.height = halfHeight;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:
                                    [NKWireEditorViewController wireEditorViewControllerWithDelegate:self 
                                                                                               value:aWireView.amp 
                                                                                     inNavController:YES]];
    
    [self showPopover:popover fromRect:frame];
    
//    [self becomeFirstResponder];
//    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self];
//    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    self.selectedNode = nil;
    self.selectedWire = aWireView;
}

- (void)showPopover:(UIPopoverController *)popoverController fromRect:(CGRect)rect
{
    [self.currentPopoverController dismissPopoverAnimated:YES];
    
    [popoverController presentPopoverFromRect:rect 
                                       inView:self 
                     permittedArrowDirections:UIPopoverArrowDirectionAny 
                                     animated:YES];
    self.currentPopoverController = popoverController;
}

- (void)dismissCurrentPopover
{
    [self.currentPopoverController dismissPopoverAnimated:YES];
    self.currentPopoverController = nil;
}

- (void)delete:(id)sender
{
    if (self.selectedWire) 
    {
        [self disconnectWire:self.selectedWire];
        [self.delegate nodeCanvas:self 
          disconnectedOutletNamed:self.selectedWire.fromOutlet.name 
                     ofNodeWithID:self.selectedWire.fromOutlet.parentNode.nodeID 
                   fromInletNamed:self.selectedWire.toInlet.name 
                     ofNodeWithID:self.selectedWire.toInlet.parentNode.nodeID];
        self.selectedWire = nil;
    }
    else if (self.selectedNode)
    {
        [self removeNode:self.selectedNode];
        [self.delegate nodeCanvas:self removedNodeWidthID:self.selectedNode.nodeID];
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

#pragma mark - NKWireEditorViewControllerDelegate
- (void)wireEditorTappedDelete:(NKWireEditorViewController *)editor
{
    [self dismissCurrentPopover];
    [self delete:editor];
}

- (void)wireEditor:(NKWireEditorViewController *)editor changedAmpTo:(CGFloat)amp
{
    self.selectedWire.amp = amp;
    
    [self.delegate nodeCanvas:self 
      connectionOfOutletNamed:self.selectedWire.fromOutlet.name 
                 ofNodeWithID:self.selectedWire.fromOutlet.parentNode.nodeID 
                 toInletNamed:self.selectedWire.toInlet.name 
                 ofNodeWithID:self.selectedWire.toInlet.parentNode.nodeID 
               didChangeAmpTo:amp];
}

@end
