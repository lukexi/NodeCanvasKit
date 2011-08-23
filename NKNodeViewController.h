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

- (void)node:(NKNodeViewController *)node didDrag:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)node:(NKNodeViewController *)node didDragFromOutlet:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@interface NKNodeViewController : UIViewController 

@property (nonatomic, retain) NSMutableArray *inConnections;
@property (nonatomic, retain) NSMutableArray *outConnections;
@property (nonatomic, retain) IBOutlet UIView *outletView;

+ (NKNodeViewController *)node;

@property (nonatomic, assign) id <NKNodeViewControllerDelegate> delegate;

@end
