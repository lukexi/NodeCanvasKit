//
//  NKNodeInletView.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/29/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKNodeXLet.h"

@interface NKNodeInlet : NKNodeXLet

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *label;

- (void)setupControls;

@end
