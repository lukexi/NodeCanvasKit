//
//  FFNode.h
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKNodeViewController;
@protocol NKNodeViewControllerDelegate <NSObject>

- (void)node:(NKNodeViewController *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)node:(NKNodeViewController *)node didDragFromOutlet:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@interface NKNodeViewController : UIViewController

+ (NKNodeViewController *)node;
+ (NKNodeViewController *)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames;
+ (NKNodeViewController *)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames;

@property (nonatomic, retain) NSMutableArray *inConnections;
@property (nonatomic, retain) NSMutableArray *outConnections;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *inletNames;
@property (nonatomic, retain) NSArray *outletNames;

#pragma mark IBOutlets
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *inletsView;
@property (nonatomic, retain) IBOutlet UIView *outletsView;

+ (NKNodeViewController *)node;

@property (nonatomic, assign) id <NKNodeViewControllerDelegate> delegate;

- (void)moveToTouchAdjustedPoint:(CGPoint)point;

@end
