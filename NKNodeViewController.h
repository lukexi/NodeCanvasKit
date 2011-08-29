//
//  FFNode.h
//  Flowerfield
//
//  Created by Luke Iannini on 10/26/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKNodeViewController;
@class NKNodeOutlet;
@class NKNodeInlet;

@protocol NKNodeViewControllerDelegate <NSObject>

- (void)node:(NKNodeViewController *)node wasTapped:(UITapGestureRecognizer *)gestureRecognizer;
- (void)node:(NKNodeViewController *)node didMove:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)outlet:(NKNodeOutlet *)outlet didDrag:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@interface NKNodeViewController : UIViewController <UIGestureRecognizerDelegate>

+ (id)node;
+ (id)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames;
+ (id)nodeWithName:(NSString *)name inletNames:(NSArray *)inletNames outletNames:(NSArray *)outletNames;

// Override if desired
+ (CGFloat)nodeXLetHeight;
+ (Class)inletViewClass;
+ (Class)outletViewClass;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *inletNames;
@property (nonatomic, retain) NSArray *outletNames;

#pragma mark IBOutlets
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *inletsView;
@property (nonatomic, retain) IBOutlet UIView *outletsView;

@property (nonatomic, assign) id <NKNodeViewControllerDelegate> delegate;

- (void)moveToTouchAdjustedPoint:(CGPoint)point;
- (NKNodeInlet *)inletForPointInSuperview:(CGPoint)point;

- (void)disconnectAllXLets;

@end
