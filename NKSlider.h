//
//  HSNodeSlider.h
//  Hypersurface
//
//  Created by Luke Iannini on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKSlider;
@protocol NKSliderDelegate <NSObject>

- (void)sliderValueChanged:(NKSlider *)aSlider;
- (void)sliderRangeChanged:(NKSlider *)aSlider;

@end

@interface NKSlider : UIControl

@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIView *thumbView;
@property (strong, nonatomic) IBOutlet UIView *rangeView;

- (IBAction)handlePinch:(id)sender;
- (IBAction)handleLongPress:(id)sender;

@property (nonatomic) CGFloat value;
@property (nonatomic) CGFloat range;

@property (nonatomic, unsafe_unretained) id <NKSliderDelegate> delegate;

@end

@interface NKSliderThumbView : UIView 

+ (UIBezierPath *)gripPathWithHeight:(CGFloat)height;
+ (UIBezierPath *)thumbPathWithSize:(CGFloat)size;
+ (CGGradientRef)backgroundGradient;

@end

@interface NKSliderTrackView : UIView 

+ (CGGradientRef)backgroundGradient;

@end

@interface NKSliderRangeView : UIView



@end