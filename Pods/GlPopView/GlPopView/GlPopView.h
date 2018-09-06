//
//  GlPopView.h
//  YKCharts
//
//  Created by luoluo on 2018/8/25.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlPopViewConfig.h"

@interface GlPopView : UIControl
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) UIColor *lineColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner rectCornerType;
@property (nonatomic, strong) GlPopViewConfig *congfig;

/**
 设置默认属性
 */
- (void)setDefaultView;
@end
