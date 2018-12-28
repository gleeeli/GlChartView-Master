//
//  GlChartDataModel.h
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ChartMulriple 1000.0 // 倍数

@interface GlChartDataModel : NSObject
@property (nonatomic,assign) NSInteger max;
@property (nonatomic,assign) NSInteger min;
@property (nonatomic,retain) NSString *ySuffix;
@property (nonatomic,retain) NSArray *xDescriptionDataSource;
@property (nonatomic,retain) NSArray *popDataSource;
@property (nonatomic,retain) NSArray<NSNumber *> *originNumbers;
@property (nonatomic,retain) NSArray<NSNumber *> *scaleNumbers;
@end
