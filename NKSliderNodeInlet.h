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

@property (nonatomic, unsafe_unretained) id <NKSliderNodeInletDelegate> delegate;
@property (nonatomic, strong) NKSlider *slider;
@property (nonatomic, strong) UILabel *label;

@end
