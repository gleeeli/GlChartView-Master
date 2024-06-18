//
//  GlChartConfig.h
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define ChartMulriple 1000.0 // 倍数

@interface GlChartConfig : NSObject
//y轴
@property (nonatomic,retain) UIFont *yDescFront ;
@property (nonatomic,retain) UIColor *yDescColor;
@property (nonatomic, retain) UIColor *ylineColor;
//单位
@property (nonatomic, retain) NSString *ySuffix;
//y轴精度,保留几位小数
@property (nonatomic, assign) NSInteger decimalNum;
//y轴分的段数
@property (nonatomic, assign) NSInteger linesCountY;

//x轴
@property (nonatomic,retain) UIFont *xDescFront ;
@property (nonatomic,retain) UIColor *xDescColor;
@property (nonatomic,retain) UIColor *xlineColor;
//是否缩减x轴的显示
@property (nonatomic, assign) BOOL iscurtailX;
//x轴的描述数组
@property (nonatomic, retain) NSArray *xDescriptionDataSource;

//折线
@property (nonatomic, assign) CGFloat lineWidth ;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, assign) CGFloat circleWidth;
@property (nonatomic, strong) NSArray<UIColor *> *lineColors;

//每个点的提示文本
@property (nonatomic, assign) BOOL disablePointText;//关闭每个点上的文本
@property (nonatomic, retain) UIFont *pointHintTextFront;
@property (nonatomic, retain) UIColor *pointHintTextColor;


//选中节点是否显示某个竖线
@property (nonatomic, assign) BOOL selectedLineViewIsShow;
//动画速度每秒多少像素,0则关闭动画
@property (nonatomic, assign) CGFloat speed;//default 40/s

//最大值，未缩放
@property (nonatomic,assign) NSInteger maxValue;
@property (nonatomic,assign) NSInteger minValue;

@property (nonatomic,assign, readonly) NSInteger max;
@property (nonatomic,assign, readonly) NSInteger min;
//每个点的提示数组
@property (nonatomic,retain) NSArray *popDataSource;
//原数据数组
@property (nonatomic,retain) NSArray<NSNumber *> *originNumbers;
//乘以1000倍后的数组
@property (nonatomic,retain) NSArray<NSNumber *> *scaleNumbers;

+ (GlChartConfig *)getCommConfig;
@end
