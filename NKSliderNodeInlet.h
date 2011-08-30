//
//  NKSliderNodeInlet.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 8/30/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "NKNodeInlet.h"
#import "NKSlider.h"

@class NKSliderNodeInlet;
@protocol NKSliderNodeInletDelegate <NSObject>

- (void)sliderInletDidChangeValue:(NKSliderNodeInlet *)aSliderNodeInlet;
- (void)sliderInletDidChangeRange:(NKSliderNodeInlet *)aSliderNodeInlet;

@end

@interface NKSliderNodeInlet : NKNodeInlet <NKSliderDelegate>

@property (nonatomic, assign) id <NKSliderNodeInletDelegate> delegate;
@property (nonatomic, retain) NKSlider *slider;
@property (nonatomic, retain) UILabel *label;

@end
