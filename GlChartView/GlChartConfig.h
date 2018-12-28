//
//  GlChartConfig.h
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlChartConfig : NSObject
//y轴
@property (nonatomic,retain) UIFont *yDescFront ;
@property (nonatomic,retain) UIColor *yDescColor;
@property (nonatomic,retain) UIColor *ylineColor;

//x轴
@property (nonatomic,retain) UIFont *xDescFront ;
@property (nonatomic,retain) UIColor *xDescColor;
@property (nonatomic,retain) UIColor *xlineColor;

//折线
@property (nonatomic,assign) CGFloat lineWidth ;
@property (nonatomic,retain) UIColor *lineColor;
@property (nonatomic,assign) CGFloat circleWidth;
@property (nonatomic, strong) NSArray<UIColor *> *lineColors;

//选中节点是否显示某个竖线
@property (nonatomic, assign) BOOL selectedLineViewIsShow;
//是否缩减x轴的显示
@property (nonatomic, assign) BOOL iscurtailX;

//精度
@property (nonatomic, assign) NSInteger decimalNum;
//动画速度每秒多少像素
@property (nonatomic, assign) CGFloat speed;//default 40/s

+ (GlChartConfig *)getCommConfig;
@end
