//
//  NodeCanvasDemoAppDelegate.h
//  NodeCanvasDemo
//
//  Created by Luke Iannini on 8/23/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NodeCanvasDemoViewController;

@interface NodeCanvasDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet NodeCanvasDemoViewController *viewController;

@end
