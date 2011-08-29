    //
//  FFCanvas.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeCanvasViewController.h"
#import "NKOutNodeViewController.h"
#import "NKNodeOutletView.h"

@interface NKNodeCanvasViewController ()

- (void)commonInit;

@property (nonatomic, retain) NKWireView *draggingWire;
@property (nonatomic, retain) NKWireView *selectedWire;
@property (nonatomic, retain) NKNodeViewController *selectedNode;

@end


@implementation NKNodeCanvasViewController
@synthesize nodeViewControllers;
@synthesize wires;
@synthesize draggingWire, selectedWire;
@synthesize selectedNode;

- (void)dealloc 
{
    [selectedNode release];
    [selectedWire release];
    [draggingWire release];
    [nodeViewControllers release];
    [wires release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        [self commonInit];
    }
    return self;
}

+ (Class)nodeClass
{
    return [NKNodeViewController class];
}

- (UIView *)canvasView
{
    return self.view;
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

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (IBAction)addNode:(id)sender
{
    NKNodeViewController *node = [[[self class] nodeClass] nodeWithName:@"SinOsc" 
                                                             inletNames:[NSArray arrayWithObjects:@"Freq", @"Phase", @"Width", nil]];
    
    CGPoint nodeCenter = CGPointMake(self.canvasView.bounds.size.width / 2, 
                                     self.canvasView.bounds.size.height / 2);
    [self addNode:node atCenterPoint:nodeCenter];
}

- (void)addNode:(NKNodeViewController *)node atCenterPoint:(CGPoint)centerPoint
{
    node.view.center = centerPoint;
    [self.nodeViewControllers addObject:node];
    node.delegate = self;
    [self.canvasView addSubview:node.view];
}

- (void)node:(NKNodeViewController *)node wasTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:node.view.frame inView:self.canvasView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    self.selectedNode = node;
    self.selectedWire = nil;
}

- (void)node:(NKNodeViewController *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [node moveToTouchAdjustedPoint:[gestureRecognizer locationInView:[self canvasView]]];
}

- (void)outlet:(NKNodeOutletView *)outlet didDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInView = [gestureRecognizer locationInView:[self canvasView]];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.draggingWire = [NKWireView wireFrom:outlet to:nil delegate:self];
            [[self canvasView] addSubview:self.draggingWire];
        case UIGestureRecognizerStateChanged:
            self.draggingWire.endPoint = locationInView;
            [self.draggingWire update];
            break;
        case UIGestureRecognizerStateEnded:
            for (NKNodeViewController *nodeViewController in self.nodeViewControllers) 
            {
                NKNodeInletView *foundInlet = [nodeViewController inletForPointInSuperview:locationInView];
                if (foundInlet)
                {
                    if (nodeViewController == outlet.parentNode) 
                    {
                        NSLog(@"Self-feedback connections are not yet supported.");
                    }
                    [self connectOutlet:outlet toInlet:foundInlet];
                }
            }
        case UIGestureRecognizerStateCancelled:
            [self.draggingWire removeFromSuperview];
            self.draggingWire = nil;
        default:
            break;
    }
}

- (void)connectOutlet:(NKNodeOutletView *)outlet toInlet:(NKNodeInletView *)inlet
{
    NKWireView *wire = [NKWireView wireFrom:outlet to:inlet delegate:self];
    [self.wires addObject:wire];
    [[self canvasView] addSubview:wire];
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
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self.canvasView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    self.selectedNode = nil;
    self.selectedWire = aWireView;
//    for (NKWireView *wire in self.wires) 
//    {
//        if (wire == aWireView) 
//        {
//            self.selectedWire = wire;
//        }
//    }
}



- (void)delete:(id)sender
{
    if (self.selectedWire) 
    {
        [self disconnectWire:self.selectedWire];
        self.selectedWire = nil;
    }
    else if (self.selectedNode)
    {
        [self removeNode:self.selectedNode];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
