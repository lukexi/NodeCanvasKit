//
//  NKNodeViewController.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKSliderNodeInlet.h"

@class NKNodeView;
@class NKNodeOutlet;
@class NKNodeInlet;

@protocol NKNodeViewControllerDelegate <NSObject>


- (void)node:(NKNodeView *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)nodeWasTapped:(NKNodeView *)node;
- (void)outlet:(NKNodeOutlet *)outlet didDrag:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@protocol NKNodeViewDataSource <NSObject>

- (NKNodeInlet *)nodeView:(NKNodeView *)nodeView inletForInletNamed:(NSString *)inletName ofNodeWithID:(NSString *)nodeID;

- (CGSize)nodeViewSizeForInlets:(NKNodeView *)nodeView;

// Provide a default implementation that just uses NKNodeOutlet
@optional
- (NKNodeOutlet *)nodeView:(NKNodeView *)nodeView outletForOutletNamed:(NSString *)outletName ofNodeWithID:(NSString *)nodeID;

- (CGSize)nodeViewSizeForOutlets:(NKNodeView *)nodeView;

@end

@interface NKNodeView : UIView <UIGestureRecognizerDelegate>
{
    CGPoint nodeDragBeginningPoint;
}
+ (id)nodeWithID:(NSString *)nodeID dataSource:(id <NKNodeViewDataSource>)dataSource;
+ (id)nodeWithID:(NSString *)nodeID name:(NSString *)name inletNames:(NSArray *)inletNames dataSource:(id <NKNodeViewDataSource>)dataSource;
+ (id)nodeWithID:(NSString *)nodeID name:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames dataSource:(id <NKNodeViewDataSource>)dataSource;

@property (nonatomic, strong) id representedObject;
@property (nonatomic, strong) NSString *nodeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *inletNames;
@property (nonatomic, strong) NSArray *outletNames;

#pragma mark IBOutlets
@property (nonatomic, strong) IBOutlet UIView *backgroundView;    
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIView *inletsView;
@property (nonatomic, strong) IBOutlet UIView *outletsView;

@property (nonatomic, weak) id <NKNodeViewControllerDelegate> delegate;
@property (nonatomic, weak) id <NKNodeViewDataSource> dataSource;

- (void)moveToTouchAdjustedPoint:(CGPoint)point;
- (NKNodeInlet *)inletForPointInSuperview:(CGPoint)point;

- (void)disconnectAllXLets;

- (NKNodeInlet *)inletNamed:(NSString *)inletName;
- (NKNodeOutlet *)outletNamed:(NSString *)outletName;

@end
