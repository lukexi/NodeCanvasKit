//
//  NKWireEditorViewController.m
//  NodeCanvasKit
//
//  Created by Luke Iannini on 9/2/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKWireEditorViewController.h"
#import "NKDragButton.h"

@interface NKWireEditorViewController ()

@end

@implementation NKWireEditorViewController
@synthesize delegate;
@synthesize ampButton;
@synthesize value;

+ (id)wireEditorViewControllerWithDelegate:(id <NKWireEditorViewControllerDelegate>)delegate 
                                     value:(CGFloat)value 
                           inNavController:(BOOL)inNavController
{
    NKWireEditorViewController *editor = [[self alloc] initWithNibName:@"NKWireEditorViewController" bundle:nil];
    editor.delegate = delegate;
    editor.value = value;
    
    editor.contentSizeForViewInPopover = CGSizeMake(142, 62);
    
    if (inNavController) 
    {
        return [[UINavigationController alloc] initWithRootViewController:editor];
    }
    
    return editor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Amp";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
                                                                                            target:self 
                                                                                            action:@selector(deleteAction:)];
    
    self.ampButton.value = self.value;
}

- (IBAction)deleteAction:(id)sender
{
    [self.delegate wireEditorTappedDelete:self];
}

- (IBAction)buttonValueChanged:(id)sender 
{
    self.value = self.ampButton.value;
    [self.delegate wireEditor:self changedAmpTo:self.value];
}

- (void)viewDidUnload 
{
    [self setAmpButton:nil];
    [super viewDidUnload];
}
@end
