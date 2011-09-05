//
//  NKWireEditorViewController.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 9/2/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKWireEditorViewController;
@protocol NKWireEditorViewControllerDelegate <NSObject>

- (void)wireEditor:(NKWireEditorViewController *)editor changedAmpTo:(CGFloat)amp;
- (void)wireEditorTappedDelete:(NKWireEditorViewController *)editor;

@end

@interface NKWireEditorViewController : UIViewController <UITextFieldDelegate> {
    UITextField *multiplierField;
    UISlider *ampSlider;
}


+ (id)wireEditorViewControllerWithDelegate:(id <NKWireEditorViewControllerDelegate>)delegate 
                                     value:(CGFloat)value 
                                multiplier:(CGFloat)multiplier
                           inNavController:(BOOL)inNavController;

@property (nonatomic, assign) id <NKWireEditorViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *multiplierField;
@property (nonatomic, retain) IBOutlet UISlider *ampSlider;

@property (nonatomic) CGFloat value;
@property (nonatomic) CGFloat multiplier;

@end
