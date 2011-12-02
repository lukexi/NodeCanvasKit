    //
//  FFNode.m
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "NKNodeView.h"
#import "NKNodeInlet.h"
#import "NKNodeOutlet.h"
#import "NKWireView.h"
#import "NKNodeBackgroundView.h"

@interface NKNodeView ()
{
    CGFloat inletsWidth;
    CGFloat outletsWidth;
}
@property (nonatomic) CGPoint movingOffset;

@property (nonatomic, strong) NSMutableDictionary *inletsByName;
@property (nonatomic, strong) NSMutableDictionary *outletsByName;
@property (nonatomic, strong) NSMutableArray *XLets;

- (void)setupXLets;
- (void)updateFrameForNumberOfXLets;
- (void)setupInlets;
- (void)setupOutlets;

- (id)initWithID:(NSString *)aNodeID 
            name:(NSString *)aName 
      inletNames:(NSArray *)theInletNames 
     outletNames:(NSArray *)theOutletNames
      dataSource:(id <NKNodeViewDataSource>)aDatasource;

@end

@implementation NKNodeView
@synthesize nodeID;
@synthesize name, inletNames, outletNames;
@synthesize inletsByName, outletsByName, XLets;
@synthesize movingOffset;
@synthesize delegate, dataSource;
@synthesize representedObject;
// IBOutlets
@synthesize headerView;
@synthesize nameLabel;
@synthesize inletsView;
@synthesize outletsView;
@synthesize backgroundView;

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    
}

+ (id)nodeWithID:(NSString *)nodeID 
      dataSource:(id <NKNodeViewDataSource>)dataSource
{
    return [self nodeWithID:nodeID 
                       name:nil 
                 inletNames:nil
                 dataSource:dataSource];
}

+ (id)nodeWithID:(NSString *)nodeID 
            name:(NSString *)name 
      inletNames:(NSArray *)inletNames 
      dataSource:(id <NKNodeViewDataSource>)dataSource
{
    return [self nodeWithID:nodeID 
                       name:name 
                 inletNames:inletNames 
                outletNames:[NSArray arrayWithObject:@"Out"]
                 dataSource:dataSource];
}

+ (id)nodeWithID:(NSString *)nodeID 
            name:(NSString *)name 
      inletNames:(NSArray *)inletNames 
     outletNames:(NSArray *)outletNames 
      dataSource:(id <NKNodeViewDataSource>)dataSource
{
    NKNodeView *node = [[self alloc] initWithID:nodeID 
                                           name:name 
                                     inletNames:inletNames 
                                    outletNames:outletNames 
                                     dataSource:dataSource];
    return node;
}

- (id)initWithID:(NSString *)aNodeID 
            name:(NSString *)aName 
      inletNames:(NSArray *)theInletNames 
     outletNames:(NSArray *)theOutletNames
      dataSource:(id <NKNodeViewDataSource>)aDataSource
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.nodeID = aNodeID;
        self.name = aName;
        self.inletNames = theInletNames;
        self.outletNames = theOutletNames;
        self.dataSource = aDataSource;
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        
        self.frame = backgroundView.frame;
        [self addSubview:backgroundView];
        
        inletsView.backgroundColor = [UIColor clearColor];
        outletsView.backgroundColor = [UIColor clearColor];
        headerView.backgroundColor = [UIColor clearColor];
        
        self.inletsByName = [NSMutableDictionary dictionary];
        self.outletsByName = [NSMutableDictionary dictionary];
        self.XLets = [NSMutableArray array];
        
        UILongPressGestureRecognizer *moveRecognizer = 
            [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                          action:@selector(handleMove:)];
        moveRecognizer.minimumPressDuration = 0;
        moveRecognizer.delegate = self;
        [self addGestureRecognizer:moveRecognizer];
        moveRecognizer.cancelsTouchesInView = NO;
        
        self.nameLabel.text = self.name;
        self.nameLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        [self setupXLets];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Make sure our move and tap recognizers don't interfere with the controls or wire dragging recognizers
    // Not sure if this is the best way to do this...
    if ([[touch view] isKindOfClass:[UIControl class]] || [[touch view] isKindOfClass:[NKNodeXLet class]]) 
    {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setupXLets
{
    // must inform any connected members that these XLets are going away, so this can only be called at startup right now!
    [self.XLets makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.XLets removeAllObjects];
    [self setupInlets];
    [self setupOutlets];
    [self updateFrameForNumberOfXLets];
}

- (void)updateFrameForNumberOfXLets
{    
    CGRect viewFrame = self.frame;
    viewFrame.size.width = self.headerView.frame.size.width + MAX(inletsWidth, outletsWidth);
    self.frame = viewFrame;
}

- (void)setupInlets
{
    [[self.inletsByName allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inletsByName removeAllObjects];
    inletsWidth = 0;
    for (NSString *inletName in self.inletNames) 
    {
        NKNodeInlet *inlet = [self.dataSource nodeView:self inletForInletNamed:inletName ofNodeWithID:self.nodeID];
        CGRect inletFrame = inlet.frame;
        inletFrame.origin.x = inletsWidth;
        inlet.frame = inletFrame;
        inlet.name = inletName;
        [self.inletsView addSubview:inlet];
        [self.inletsByName setObject:inlet forKey:inletName];
        [self.XLets addObject:inlet];
        inletsWidth += inlet.frame.size.width;
    }
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
    
    outletsWidth = 0;
    for (NSString *outletName in self.outletNames) 
    {
        NKNodeOutlet *outlet = [self.dataSource nodeView:self outletForOutletNamed:outletName ofNodeWithID:self.nodeID];
        CGRect outletFrame = outlet.frame;
        outletFrame.origin.x = outletsWidth;
        outlet.frame = outletFrame;
        [self.outletsView addSubview:outlet];
        [self.outletsByName setObject:outlet forKey:outletName];
        [self.XLets addObject:outlet];
        
        UILongPressGestureRecognizer *outletRecognizer = 
            [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                          action:@selector(handleOutletDrag:)];
        outletRecognizer.minimumPressDuration = 0;
        [outlet addGestureRecognizer:outletRecognizer];
        outletsWidth += outlet.frame.size.width;
    }
}

- (void)handleOutletDrag:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NKNodeOutlet *outlet = (NKNodeOutlet *)[gestureRecognizer view];
    [self.delegate outlet:outlet didDrag:gestureRecognizer];
}

- (void)handleMove:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInSuperview = [gestureRecognizer locationInView:self.superview];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) 
    {
        CGPoint touchLocation = [gestureRecognizer locationInView:self];
        CGPoint localCenter = [self convertPoint:self.center fromView:self.superview];
        self.movingOffset = CGPointMake(localCenter.x - touchLocation.x, localCenter.y - touchLocation.y);
        nodeDragBeginningPoint = locationInSuperview;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGFloat xMovement = ABS(nodeDragBeginningPoint.x - locationInSuperview.x);
        CGFloat yMovement = ABS(nodeDragBeginningPoint.y - locationInSuperview.y);
        if (xMovement < 10 || yMovement < 10) 
        {
            [self.delegate nodeWasTapped:self];
        }
    }
    
    [self.delegate node:self didMove:gestureRecognizer];
    [self.XLets makeObjectsPerformSelector:@selector(updateConnections)];
}

- (void)moveToTouchAdjustedPoint:(CGPoint)point
{
    self.center = CGPointMake(point.x + self.movingOffset.x, point.y + self.movingOffset.y);
}

- (NKNodeInlet *)inletForPointInSuperview:(CGPoint)point
{
    CGPoint localPoint = [self.inletsView convertPoint:point fromView:self.superview];
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

@end
