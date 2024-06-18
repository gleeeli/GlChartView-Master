//
//  GlChartConfig.m
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlChartConfig.h"


@interface GlChartConfig ()
@property (nonatomic,assign) NSInteger max;
@property (nonatomic,assign) NSInteger min;
@end

@implementation GlChartConfig
+ (GlChartConfig *)getCommConfig{
    //y轴
    GlChartConfig *config = [GlChartConfig new];
    config.yDescFront = [UIFont systemFontOfSize:11.0];
    config.yDescColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    config.ylineColor =  [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.5f];
    
    //x轴
    config.xDescFront = [UIFont systemFontOfSize:11.0];
    config.xDescColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    config.xlineColor =  [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.5f];
    //线
    config.lineWidth = 2;
    config.lineColor = [UIColor colorWithRed:56/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    config.circleWidth = 3;
    config.decimalNum = 2;
    config.speed = 200;
    
    config.pointHintTextFront = [UIFont systemFontOfSize:12.0];
    config.pointHintTextColor = [UIColor colorWithWhite:1 alpha:0.8];
    return config;
}

-(NSInteger)max{
    if (_maxValue != 0) {
        return  _maxValue * ChartMulriple;
    }
    NSInteger tempMax = 0;
    for (NSNumber *number in self.scaleNumbers) {
        if ([number integerValue] > tempMax) {
            tempMax = [number integerValue];
        }
    }
    _max = tempMax;
    return _max;
}

-(NSInteger)min{
    if (_minValue != 0) {
        return  _minValue * ChartMulriple;
    }
    NSInteger tempMin = [self.scaleNumbers.firstObject integerValue];
    for (NSNumber *number in self.scaleNumbers) {
        if ([number integerValue] < tempMin) {
            tempMin = [number integerValue];
        }
    }
    if (tempMin < 0) {
        _min = tempMin;
    }else{
        _min = 0;
    }
    return _min;
}

- (void)setOriginNumbers:(NSArray *)originNumbers{
    _originNumbers = originNumbers;
    NSMutableArray *muArray = [NSMutableArray array];
    for (int i = 0; i < [originNumbers count]; i++) {
        NSInteger now = [originNumbers[i] doubleValue] * ChartMulriple;
        [muArray addObject:[NSNumber numberWithInteger:now]];
    }
    
    _scaleNumbers = muArray;
}
@end
