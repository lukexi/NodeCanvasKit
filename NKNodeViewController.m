    //
//  FFNode.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeViewController.h"
#import "NKNodeInlet.h"
#import "NKNodeOutlet.h"
#import "NKWireView.h"

@interface NKNodeViewController ()

@property (nonatomic) CGPoint movingOffset;

@property (nonatomic, retain) NSMutableArray *inletViews;
@property (nonatomic, retain) NSMutableArray *outletViews;
@property (nonatomic, retain) NSMutableArray *XLets;

- (void)setupXLets;
- (void)updateXLetContainerSizes;
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

+ (id)node
{
    return [self nodeWithName:nil inletNames:nil];
}

+ (id)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames
{
    return [self nodeWithName:name inletNames:inletNames outletNames:[NSArray arrayWithObject:@"Out"]];
}

+ (id)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames
{
    NKNodeViewController *nodeViewController = [[[self alloc] initWithNibName:nil bundle:nil] autorelease];
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
    moveRecognizer.delegate = self;
    [self.view addGestureRecognizer:moveRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                     action:@selector(handleTap:)] autorelease];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    [moveRecognizer requireGestureRecognizerToFail:tapRecognizer];
    
    self.nameLabel.text = self.name;
    
    [self setupXLets];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Not sure if this is the best way to do this...
    if ([[touch view] isKindOfClass:[UIControl class]]) 
    {
        return NO;
    }
    return YES;
}

- (void)setupXLets
{
    // must inform any connected members that these XLets are going away, so this can only be called at startup right now!
    [self.XLets makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.XLets removeAllObjects];
    [self updateXLetContainerSizes];
    [self setupInlets];
    [self setupOutlets];
}

- (void)updateXLetContainerSizes
{
    NSUInteger maxXLets = MAX([self.inletNames count], [self.outletNames count]);
    CGFloat XLetHeight = maxXLets * [[self class] nodeXLetHeight];
    
    CGRect inletsFrame = self.inletsView.frame;
    inletsFrame.size.height = XLetHeight;
    self.inletsView.frame = inletsFrame;
    
    CGRect outletsFrame = self.outletsView.frame;
    outletsFrame.size.height = XLetHeight;
    self.outletsView.frame = outletsFrame;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.headerView.frame.size.height + XLetHeight;
    self.view.frame = viewFrame;
}

- (void)setupInlets
{
    [self.inletViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inletViews removeAllObjects];
    NSUInteger index = 0;
    for (NSString *inletName in self.inletNames) 
    {
        CGRect inletRect = CGRectMake(0, index * [[self class] nodeXLetHeight], 
                                      self.inletsView.bounds.size.width, [[self class] nodeXLetHeight]);
        NKNodeInlet *inletView = [[[self class] inletViewClass] XLetForNode:self withFrame:inletRect];
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
    
    CGFloat totalOutletHeight = [self.outletNames count] * [[self class] nodeXLetHeight];
    CGFloat yCenteringOffset = floor((self.outletsView.frame.size.height - totalOutletHeight) / 2);
    
    NSUInteger index = 0;
    for (NSString *outletName in self.outletNames) 
    {
        CGRect outletRect = CGRectMake(0, index * [[self class] nodeXLetHeight] + yCenteringOffset, 
                                       self.outletsView.bounds.size.width, [[self class] nodeXLetHeight]);
        NKNodeOutlet *outletView = [[[self class] outletViewClass] XLetForNode:self withFrame:outletRect];
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

+ (Class)inletViewClass
{
    return [NKNodeInlet class];
}

+ (Class)outletViewClass
{
    return [NKNodeOutlet class];
}

+ (CGFloat)nodeXLetHeight
{
    return 44;
}

- (void)handleOutletDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NKNodeOutlet *outlet = (NKNodeOutlet *)[gestureRecognizer view];
    [self.delegate outlet:outlet didDrag:gestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate node:self wasTapped:gestureRecognizer];
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

- (NKNodeInlet *)inletForPointInSuperview:(CGPoint)point
{
    CGPoint localPoint = [self.inletsView convertPoint:point fromView:self.view.superview];
    for (NKNodeInlet *inlet in self.inletViews) 
    {
        if (CGRectContainsPoint(inlet.frame, localPoint)) 
        {
            return inlet;
        }
    }
    return nil;
}

- (void)disconnectAllXLets
{
    for (NKNodeXLet *XLet in self.XLets) 
    {
        [XLet disconnectAllConnections];
    }
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
