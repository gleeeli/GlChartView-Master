//
//  GlPopViewConfig.h
//  YKCharts
//
//  Created by luoluo on 2018/8/25.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GlArrowDirectionNone,//没有箭头
    GlArrowDirectionTop,// 箭头朝上
    GlArrowDirectionLeft,// 箭头朝左
    GlArrowDirectionRight,// 箭头朝右
    GlArrowDirectionBottom,// 箭头朝下
} GlArrowDirection;

typedef enum : NSUInteger {
    GlArrowAlignmentLeft,
    GlArrowAlignmentCenter,
    GlArrowAlignmentRight,
} GlArrowAlignment;

@interface GlPopViewConfig : NSObject
@property (nonatomic, assign) CGFloat widthArrow;
@property (nonatomic, assign) CGFloat heightArrow;
@property (nonatomic, assign) CGFloat radiusArrow;//0则不需要圆角
@property (nonatomic, assign) GlArrowDirection directionArrow;//箭头方向

@property (nonatomic, assign) GlArrowAlignment alignmentArrow;//箭头位置
@property (nonatomic, assign) CGFloat paddingDirectionArrow;//间距 可调节箭头位置
@property (nonatomic, assign) CGFloat offsetopHorizontalArrow;//箭头顶部水平方向偏移值
@end
