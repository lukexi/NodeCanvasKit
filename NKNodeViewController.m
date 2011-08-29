    //
//  FFNode.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeViewController.h"
#import "NKNodeInletView.h"
#import "NKNodeOutletView.h"

#define kNKNodeXLetHeight 44

@interface NKNodeViewController ()

@property (nonatomic) CGPoint movingOffset;

@property (nonatomic, retain) NSMutableArray *inletViews;
@property (nonatomic, retain) NSMutableArray *outletViews;

- (void)setupInlets;
- (void)setupOutlets;

@end

@implementation NKNodeViewController
@synthesize name, inletNames, outletNames;
@synthesize inletViews, outletViews;
@synthesize movingOffset;

@synthesize delegate;
@synthesize inConnections;
@synthesize outConnections;

// IBOutlets
@synthesize headerView;
@synthesize nameLabel;
@synthesize inletsView;
@synthesize outletsView;

- (void)dealloc 
{
    [inConnections release];
    [outConnections release];
    [inletNames release];
    [outletNames release];
    [name release];
    [inletViews release];
    [outletViews release];
    [headerView release];
    [nameLabel release];
    [inletsView release];
    [outletsView release];
    [super dealloc];
}

+ (NKNodeViewController *)node
{
    return [self nodeWithName:nil inletNames:nil];
}

+ (NKNodeViewController *)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames
{
    return [self nodeWithName:name inletNames:inletNames outletNames:[NSArray arrayWithObject:@"Out"]];
}

+ (NKNodeViewController *)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames
{
    NKNodeViewController *nodeViewController = [[[self alloc] initWithNibName:@"NKNodeViewController" bundle:nil] autorelease];
    nodeViewController.name = name;
    nodeViewController.inletNames = inletNames;
    nodeViewController.outletNames = outletNames;
    return nodeViewController;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.inConnections = [NSMutableArray arrayWithCapacity:10];
    self.outConnections = [NSMutableArray arrayWithCapacity:10];
    
    self.inletViews = [NSMutableArray array];
    self.outletViews = [NSMutableArray array];
    
    UILongPressGestureRecognizer *moveRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                  action:@selector(handleMove:)] autorelease];
    moveRecognizer.minimumPressDuration = 0;
    [self.view addGestureRecognizer:moveRecognizer];
    
    self.nameLabel.text = self.name;
    
    [self setupInlets];
    [self setupOutlets];
}

- (void)setupInlets
{
    [self.inletViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger index = 0;
    for (NSString *inletName in self.inletNames) 
    {
        NKNodeInletView *inletView = [[[NKNodeInletView alloc] initWithFrame:CGRectMake(0, 
                                                                                        index * kNKNodeXLetHeight, 
                                                                                        self.inletsView.bounds.size.width, 
                                                                                        kNKNodeXLetHeight)] autorelease];
        inletView.label.text = inletName;
        [self.inletsView addSubview:inletView];
        [self.inletViews addObject:inletView];
        index++;
    }
}

- (void)setupOutlets
{
    [self.outletViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger index = 0;
    for (NSString *outletName in self.outletNames) 
    {
        NKNodeOutletView *outletView = [[[NKNodeOutletView alloc] initWithFrame:CGRectMake(0, 
                                                                                           index * kNKNodeXLetHeight, 
                                                                                           self.outletsView.bounds.size.width, 
                                                                                           kNKNodeXLetHeight)] autorelease];
        [self.outletsView addSubview:outletView];
        [self.outletViews addObject:outletView];
        
        UILongPressGestureRecognizer *outletRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                        action:@selector(handleOutletDrag:)] autorelease];
        outletRecognizer.minimumPressDuration = 0;
        [outletView addGestureRecognizer:outletRecognizer];
        index++;
    }
}

- (void)handleOutletDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.delegate node:self didDragFromOutlet:gestureRecognizer];
}

- (void)handleMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) 
    {
        CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
        CGPoint localCenter = [self.view convertPoint:self.view.center fromView:self.view.superview];
        self.movingOffset = CGPointMake(localCenter.x - touchLocation.x, localCenter.y - touchLocation.y);
    }
    
    [self.inConnections makeObjectsPerformSelector:@selector(update)];
    [self.outConnections makeObjectsPerformSelector:@selector(update)];
    
    [self.delegate node:self didMove:gestureRecognizer];
}

- (void)moveToTouchAdjustedPoint:(CGPoint)point
{
    self.view.center = CGPointMake(point.x + self.movingOffset.x, point.y + self.movingOffset.y);
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
    [self setHeaderView:nil];
    [self setNameLabel:nil];
    [self setInletsView:nil];
    [self setOutletsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
