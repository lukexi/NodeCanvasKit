//
//  NKWireEditorViewController.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 9/2/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKDragButton;
@class NKWireEditorViewController;
@protocol NKWireEditorViewControllerDelegate <NSObject>

- (void)wireEditor:(NKWireEditorViewController *)editor changedAmpTo:(CGFloat)amp;
- (void)wireEditorTappedDelete:(NKWireEditorViewController *)editor;

@end

@interface NKWireEditorViewController : UIViewController <UITextFieldDelegate>

+ (id)wireEditorViewControllerWithDelegate:(id <NKWireEditorViewControllerDelegate>)delegate 
                                     value:(CGFloat)value 
                           inNavController:(BOOL)inNavController;

@property (nonatomic, weak) id <NKWireEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet NKDragButton *ampButton;

@property (nonatomic) CGFloat value;

@end
