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
#import "NKSliderNodeInlet.h"

@interface NKNodeViewController ()

@property (nonatomic) CGPoint movingOffset;

@property (nonatomic, retain) NSMutableDictionary *inletsByName;
@property (nonatomic, retain) NSMutableDictionary *outletsByName;
@property (nonatomic, retain) NSMutableArray *XLets;

- (void)setupXLets;
- (void)updateXLetContainerSizes;
- (void)setupInlets;
- (void)setupOutlets;

@end

@implementation NKNodeViewController
@synthesize nodeID;
@synthesize name, inletNames, outletNames;
@synthesize inletsByName, outletsByName, XLets;
@synthesize movingOffset;
@synthesize delegate;
@synthesize representedObject;
// IBOutlets
@synthesize headerView;
@synthesize nameLabel;
@synthesize inletsView;
@synthesize outletsView;

- (void)dealloc 
{
    [representedObject release];
    [nodeID release];
    [inletNames release];
    [outletNames release];
    [name release];
    [inletsByName release];
    [outletsByName release];
    [XLets release];
    [headerView release];
    [nameLabel release];
    [inletsView release];
    [outletsView release];
    [super dealloc];
}

+ (id)nodeWithID:(NSString *)nodeID
{
    return [self nodeWithID:nodeID name:nil inletNames:nil];
}

+ (id)nodeWithID:(NSString *)nodeID name:(NSString *)name inletNames:(NSArray *)inletNames
{
    return [self nodeWithID:nodeID name:name inletNames:inletNames outletNames:[NSArray arrayWithObject:@"Out"]];
}

+ (id)nodeWithID:(NSString *)nodeID name:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames
{
    NKNodeViewController *node = [[[self alloc] initWithNibName:nil bundle:nil] autorelease];
    node.nodeID = nodeID;
    node.name = name;
    node.inletNames = inletNames;
    node.outletNames = outletNames;
    return node;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.inletsByName = [NSMutableDictionary dictionary];
    self.outletsByName = [NSMutableDictionary dictionary];
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
    /* // stretching the view stretches these in the current implementation
    CGRect inletsFrame = self.inletsView.frame;
    inletsFrame.size.height = XLetHeight;
    self.inletsView.frame = inletsFrame;
    
    CGRect outletsFrame = self.outletsView.frame;
    outletsFrame.size.height = XLetHeight;
    self.outletsView.frame = outletsFrame;
     */
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.headerView.frame.size.height + XLetHeight;
    self.view.frame = viewFrame;
}

- (void)setupInlets
{
    [[self.inletsByName allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inletsByName removeAllObjects];
    NSUInteger index = 0;
    for (NSString *inletName in self.inletNames) 
    {
        CGRect inletRect = CGRectMake(0, index * [[self class] nodeXLetHeight], 
                                      self.inletsView.bounds.size.width, [[self class] nodeXLetHeight]);
        NKNodeInlet *inlet = [[[self class] inletViewClass] XLetForNode:self withFrame:inletRect];
        inlet.name = inletName;
        [self configureInlet:inlet];
        [self.inletsView addSubview:inlet];
        [self.inletsByName setObject:inlet forKey:inletName];
        [self.XLets addObject:inlet];
        index++;
    }
}

// Should be moved to subclass — shouldn't assume NKSliderNodeInlet
- (void)configureInlet:(NKNodeInlet *)inlet
{
    if ([inlet isKindOfClass:[NKSliderNodeInlet class]]) 
    {
        NKSliderNodeInlet *sliderInlet = (NKSliderNodeInlet *)inlet;
        sliderInlet.label.text = sliderInlet.name;
        sliderInlet.delegate = self;
    }
}

#pragma mark - NKSliderNodeInletDelegate
- (void)sliderInletDidChangeValue:(NKSliderNodeInlet *)aSliderNodeInlet
{
    [self.delegate inletDidChangeValue:aSliderNodeInlet];
}

- (void)sliderInletDidChangeRange:(NKSliderNodeInlet *)aSliderNodeInlet
{
    [self.delegate inletDidChangeRange:aSliderNodeInlet];
}

- (NKNodeInlet *)inletNamed:(NSString *)inletName
{
    return [self.inletsByName objectForKey:inletName];
}

- (NKNodeOutlet *)outletNamed:(NSString *)outletName
{
    return [self.outletsByName objectForKey:outletName];
}

- (void)setupOutlets
{
    [[self.outletsByName allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.outletsByName removeAllObjects];
    
    CGFloat totalOutletHeight = [self.outletNames count] * [[self class] nodeXLetHeight];
    CGFloat yCenteringOffset = floor((self.outletsView.frame.size.height - totalOutletHeight) / 2);
    
    NSUInteger index = 0;
    for (NSString *outletName in self.outletNames) 
    {
        CGRect outletRect = CGRectMake(0, index * [[self class] nodeXLetHeight] + yCenteringOffset, 
                                       self.outletsView.bounds.size.width, [[self class] nodeXLetHeight]);
        NKNodeOutlet *outletView = [[[self class] outletViewClass] XLetForNode:self withFrame:outletRect];
        [self.outletsView addSubview:outletView];
        [self.outletsByName setObject:outletView forKey:outletName];
        [self.XLets addObject:outletView];
        
        UILongPressGestureRecognizer *outletRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                        action:@selector(handleOutletDrag:)] autorelease];
        outletRecognizer.minimumPressDuration = 0;
        [outletView addGestureRecognizer:outletRecognizer];
        index++;
    }
}

// Should be moved to subclass — should use NKNodeInlet as the default
+ (Class)inletViewClass
{
    return [NKSliderNodeInlet class];
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
    for (NKNodeInlet *inlet in [self.inletsByName allValues]) 
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
