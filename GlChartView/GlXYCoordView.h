//
//  GlXYCoordView.h
//  YKCharts
//
//  Created by gleeeli on 2018/8/23.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GlDirectionX,
    GlDirectionY,
} GlDirectionType;
@interface GlXYCoordView : UIView
@property (nonatomic, assign) GlDirectionType directon;
@property (nonatomic, assign) CGFloat itemWith;//每格间距
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat lineWidth;//画线宽度
@property (nonatomic, assign) CGFloat subScriptLenght;//标线长度 默认5
@property (nonatomic, strong) UIColor *lineColor;//线颜色
@property (nonatomic, strong) UIColor *wordColor;//字体颜色
@property (nonatomic, strong) UIFont *wordFont;//字体
@property (nonatomic, assign) BOOL isNeedSubscriptLine;//是否需要下标线 小凸点
@property (nonatomic, assign) CGFloat wordInsert;//字与线的间距 默认5
@property (nonatomic, assign) CGFloat mainMaxWith;//主要内容宽度 不包括引导线y轴线的宽度
@property (nonatomic, assign) BOOL isNeedGuidLine;//是否需要引导线
@property (nonatomic, assign) CGFloat offsetSPaceXY;//尾部需要偏移值 不然字显示不全
@property (nonatomic, assign) BOOL iscurtailHiddenEmptyTitle;//是否隐藏空字符的下标 default NO
@end
