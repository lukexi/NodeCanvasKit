    //
//  FFNode.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NKNodeViewController
@synthesize delegate;
@synthesize inConnections;
@synthesize outConnections;
@synthesize outletView;


+ (NKNodeViewController *)node
{
    return [[[self alloc] initWithNibName:@"NKNodeViewController" bundle:nil] autorelease];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.inConnections = [NSMutableArray arrayWithCapacity:10];
    self.outConnections = [NSMutableArray arrayWithCapacity:10];
    
    self.view.layer.cornerRadius = 20;
    self.view.layer.masksToBounds = YES;
    self.view.layer.borderWidth = 2;
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UILongPressGestureRecognizer *dragRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                  action:@selector(handleDrag:)] autorelease];
    dragRecognizer.minimumPressDuration = 0;
    [self.view addGestureRecognizer:dragRecognizer];
    
    UILongPressGestureRecognizer *outletRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                    action:@selector(handleOutletDrag:)] autorelease];
    outletRecognizer.minimumPressDuration = 0;
    [self.outletView addGestureRecognizer:outletRecognizer];
}

- (void)handleOutletDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([delegate respondsToSelector:@selector(node:didDragFromOutlet:)]) 
    {
        [delegate node:self didDragFromOutlet:gestureRecognizer];
    }
}

- (void)handleDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.inConnections makeObjectsPerformSelector:@selector(update)];
    [self.outConnections makeObjectsPerformSelector:@selector(update)];
    
    if ([delegate respondsToSelector:@selector(node:didDrag:)])
    {
    	[delegate node:self didDrag:gestureRecognizer];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [self setOutletView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    self.inConnections = nil;
    self.outConnections = nil;

    [outletView release];
    [super dealloc];
}


@end
