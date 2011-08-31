//
//  NodeCanvasDemoViewController.m
//  NodeCanvasDemo
//
//  Created by Luke Iannini on 8/23/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NodeCanvasDemoViewController.h"

@interface NodeCanvasDemoViewController ()

@property (nonatomic) BOOL outAdded;

@end

@implementation NodeCanvasDemoViewController
@synthesize nodeCanvasView;
@synthesize outAdded;

- (void)dealloc 
{
    [nodeCanvasView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.outAdded) 
    {// workaround for viewDidLoad being called twice due to bug in xcode4
        [self.nodeCanvasView addOutNode];
        self.outAdded = YES;
    }
    
}

- (IBAction)addNode:(id)sender
{
    [self.nodeCanvasView addNodeNamed:@"SinOsc" 
                           withInlets:[NSArray arrayWithObjects:@"Freq", @"Phase", @"Width", nil] 
                             animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
