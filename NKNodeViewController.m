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
@property (nonatomic, retain) NSMutableArray *XLets;

- (void)setupXLets;
- (void)setupInlets;
- (void)setupOutlets;

@end

@implementation NKNodeViewController
@synthesize name, inletNames, outletNames;
@synthesize inletViews, outletViews, XLets;
@synthesize movingOffset;

@synthesize delegate;

// IBOutlets
@synthesize headerView;
@synthesize nameLabel;
@synthesize inletsView;
@synthesize outletsView;

- (void)dealloc 
{
    [inletNames release];
    [outletNames release];
    [name release];
    [inletViews release];
    [outletViews release];
    [XLets release];
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
    
    self.inletViews = [NSMutableArray array];
    self.outletViews = [NSMutableArray array];
    self.XLets = [NSMutableArray array];
    
    UILongPressGestureRecognizer *moveRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                  action:@selector(handleMove:)] autorelease];
    moveRecognizer.minimumPressDuration = 0;
    [self.view addGestureRecognizer:moveRecognizer];
    
    self.nameLabel.text = self.name;
    
    [self setupXLets];
}

- (void)setupXLets
{
    [self.XLets makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.XLets removeAllObjects];
    [self setupInlets];
    [self setupOutlets];
}

- (void)setupInlets
{
    [self.inletViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inletViews removeAllObjects];
    NSUInteger index = 0;
    for (NSString *inletName in self.inletNames) 
    {
        CGRect inletRect = CGRectMake(0, index * kNKNodeXLetHeight, 
                                      self.inletsView.bounds.size.width, kNKNodeXLetHeight);
        NKNodeInletView *inletView = [NKNodeInletView XLetForNode:self withFrame:inletRect];
        inletView.label.text = inletName;
        [self.inletsView addSubview:inletView];
        [self.inletViews addObject:inletView];
        [self.XLets addObject:inletView];
        index++;
    }
}

- (void)setupOutlets
{
    [self.outletViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.outletViews removeAllObjects];
    NSUInteger index = 0;
    for (NSString *outletName in self.outletNames) 
    {
        CGRect outletRect = CGRectMake(0, index * kNKNodeXLetHeight, 
                                       self.outletsView.bounds.size.width, kNKNodeXLetHeight);
        NKNodeOutletView *outletView = [NKNodeOutletView XLetForNode:self withFrame:outletRect];
        [self.outletsView addSubview:outletView];
        [self.outletViews addObject:outletView];
        [self.XLets addObject:outletView];
        
        UILongPressGestureRecognizer *outletRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                        action:@selector(handleOutletDrag:)] autorelease];
        outletRecognizer.minimumPressDuration = 0;
        [outletView addGestureRecognizer:outletRecognizer];
        index++;
    }
}

- (void)handleOutletDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NKNodeOutletView *outlet = (NKNodeOutletView *)[gestureRecognizer view];
    [self.delegate outlet:outlet didDrag:gestureRecognizer];
}

- (void)handleMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) 
    {
        CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
        CGPoint localCenter = [self.view convertPoint:self.view.center fromView:self.view.superview];
        self.movingOffset = CGPointMake(localCenter.x - touchLocation.x, localCenter.y - touchLocation.y);
    }
    
    [self.XLets makeObjectsPerformSelector:@selector(updateConnections)];
    
    [self.delegate node:self didMove:gestureRecognizer];
}

- (void)moveToTouchAdjustedPoint:(CGPoint)point
{
    self.view.center = CGPointMake(point.x + self.movingOffset.x, point.y + self.movingOffset.y);
}

- (NKNodeInletView *)inletForPointInSuperview:(CGPoint)point
{
    CGPoint localPoint = [self.inletsView convertPoint:point fromView:self.view.superview];
    for (NKNodeInletView *inlet in self.inletViews) 
    {
        if (CGRectContainsPoint(inlet.frame, localPoint)) 
        {
            return inlet;
        }
    }
    return nil;
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
