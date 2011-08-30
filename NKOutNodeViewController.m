//
//  NKOutletNodeViewController.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKOutNodeViewController.h"
#import "NKOutNodeInlet.h"
@implementation NKOutNodeViewController

+ (NKOutNodeViewController *)outNode
{
    return [super nodeWithName:@"Out" 
                    inletNames:[NSArray arrayWithObjects:@"a_in", nil] 
                   outletNames:nil];
}

+ (CGFloat)nodeXLetHeight
{
    return 160;
}

+ (Class)inletViewClass
{
    return [NKOutNodeInlet class];
}

- (void)configureInlet:(NKNodeInlet *)inlet withName:(NSString *)name
{
    // Don't do anything
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
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
