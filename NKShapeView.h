//
//  NKShapeView.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 11/28/11.
//  Copyright (c) 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKShapeView : UIView

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

@end
