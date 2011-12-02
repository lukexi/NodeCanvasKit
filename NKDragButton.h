//
//  NKDragButton.h
//  NodeCanvasKit
//
//  Created by Luke Iannini on 11/28/11.
//  Copyright (c) 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^NKDragButtonValueFormatterBlock)(CGFloat value);

@interface NKDragButton : UIButton

@property (nonatomic) BOOL isHighPrecisionEnabled;
@property (nonatomic) CGFloat value;
@property (nonatomic, copy) NKDragButtonValueFormatterBlock formatter;

@end