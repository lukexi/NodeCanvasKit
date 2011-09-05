//
//  NKWireEditorViewController.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 9/2/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKWireEditorViewController.h"

@interface NKWireEditorViewController ()

- (void)updateMultiplierFromTextField;
- (void)informDelegateOfNewValue;

@end

@implementation NKWireEditorViewController
@synthesize delegate;
@synthesize multiplierField;
@synthesize ampSlider;
@synthesize value, multiplier;

+ (id)wireEditorViewControllerWithDelegate:(id <NKWireEditorViewControllerDelegate>)delegate 
                                     value:(CGFloat)value 
                                multiplier:(CGFloat)multiplier
                           inNavController:(BOOL)inNavController
{
    NKWireEditorViewController *editor = [[[self alloc] initWithNibName:@"NKWireEditorViewController" bundle:nil] autorelease];
    editor.delegate = delegate;
    editor.value = value;
    editor.multiplier = multiplier;
    
    editor.contentSizeForViewInPopover = CGSizeMake(323, 62);
    
    if (inNavController) 
    {
        return [[[UINavigationController alloc] initWithRootViewController:editor] autorelease];
    }
    
    return editor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Amp";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAction:)] autorelease];
    
    self.ampSlider.value = self.value;
    self.multiplierField.text = [NSString stringWithFormat:@"%01f", self.multiplier];
}

- (IBAction)deleteAction:(id)sender
{
    [self.delegate wireEditorTappedDelete:self];
}

- (IBAction)sliderValueChanged:(id)sender 
{
    self.value = self.ampSlider.value;
    [self informDelegateOfNewValue];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateMultiplierFromTextField];
}

- (void)updateMultiplierFromTextField
{
    self.multiplier = [self.multiplierField.text floatValue];
    [self informDelegateOfNewValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updateMultiplierFromTextField];
    return YES;
}

- (void)informDelegateOfNewValue
{
    [self.delegate wireEditor:self changedAmpTo:self.value * self.multiplier];
}

- (void)dealloc {
    [multiplierField release];
    [ampSlider release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMultiplierField:nil];
    [self setAmpSlider:nil];
    [super viewDidUnload];
}
@end
