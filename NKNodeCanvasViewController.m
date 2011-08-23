    //
//  FFCanvas.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeCanvasViewController.h"

@interface NKNodeCanvasViewController ()

- (void)commonInit;

@property (nonatomic, retain) NKWireView *draggingWire;
@property (nonatomic, retain) NKWireView *selectedWire;

@end


@implementation NKNodeCanvasViewController
@synthesize nodeViewControllers;
@synthesize wires;
@synthesize connectingNode, draggingWire, selectedWire;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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
	self.nodeViewControllers = [NSMutableSet setWithCapacity:100];
    self.wires = [NSMutableSet setWithCapacity:100];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (IBAction)addNode:(id)sender
{
    NKNodeViewController *node = [[[self class] nodeClass] node];
    [self.nodeViewControllers addObject:node];
    node.delegate = self;
    
    node.view.backgroundColor = [UIColor colorWithHue:((arc4random() % 100) / 100.0) 
                                           saturation:0.9 
                                           brightness:0.9 
                                                alpha:1.0];
    
    
    node.view.center = CGPointMake([self canvasView].bounds.size.width / 2, 
                                   [self canvasView].bounds.size.height / 2);
    
    [[self canvasView] addSubview:node.view];
}

- (void)node:(NKNodeViewController *)node didDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            if (!self.connectingNode)
            {
                self.connectingNode = node;
                node.view.layer.borderColor = [UIColor orangeColor].CGColor;
            }
            else
            {
                if (![[self.connectingNode.outConnections valueForKey:@"outNode"] containsObject:node])
                {
                    node.view.layer.borderColor = [UIColor blueColor].CGColor;
                    [self connectNode:self.connectingNode toNode:node];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (node == connectingNode)
            {
                self.connectingNode = nil;
            }
            node.view.layer.borderColor = [UIColor whiteColor].CGColor;
            break;

        default:
            break;
    }
    gestureRecognizer.view.center = [gestureRecognizer locationInView:[self canvasView]];
}

- (void)node:(NKNodeViewController *)node didDragFromOutlet:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInView = [gestureRecognizer locationInView:[self canvasView]];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.draggingWire = [NKWireView wireWithDelegate:nil];
            self.draggingWire.inNode = node;
            [[self canvasView] addSubview:self.draggingWire];
        case UIGestureRecognizerStateChanged:
            self.draggingWire.endPoint = locationInView;
            [self.draggingWire update];
            break;
        case UIGestureRecognizerStateEnded:
            for (NKNodeViewController *nodeViewController in self.nodeViewControllers) 
            {
                if (CGRectContainsPoint(nodeViewController.view.frame, locationInView)) 
                {
                    [self connectNode:node toNode:nodeViewController];
                }
            }
        case UIGestureRecognizerStateCancelled:
            [self.draggingWire removeFromSuperview];
            self.draggingWire = nil;
        default:
            break;
    }
}

- (void)connectNode:(NKNodeViewController *)fromNode toNode:(NKNodeViewController *)toNode
{
    NKWireView *wire = [NKWireView wireFrom:fromNode to:toNode delegate:self];
    [self.wires addObject:wire];
    [[self canvasView] addSubview:wire];
}

- (void)disconnectWire:(NKWireView *)wire
{
    [[wire retain] autorelease];
    [wire.inNode.outConnections removeObject:wire];
    [wire.outNode.inConnections removeObject:wire];
    [self.wires removeObject:wire];
    [UIView animateWithDuration:0.5 animations:^(void) {
        wire.alpha = 0;
        wire.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [wire removeFromSuperview];
    }];
}

- (void)wireViewTapped:(NKWireView *)aWireView
{
    [self becomeFirstResponder];
    CGRect frame = aWireView.frame;
    CGFloat halfHeight = frame.size.height / 2;
    frame.origin.y += halfHeight;
    frame.size.height = halfHeight;
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:[self canvasView]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    self.selectedWire = nil;
    for (NKWireView *wire in self.wires) 
    {
        if (wire == aWireView) 
        {
            self.selectedWire = wire;
        }
    }
}

- (void)delete:(id)sender
{
    [self disconnectWire:self.selectedWire];
    self.selectedWire = nil;
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(delete:)) {
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


- (void)dealloc 
{
    [draggingWire release];
    [connectingNode release];
    [nodeViewControllers release];
    [wires release];
    [super dealloc];
}


@end
