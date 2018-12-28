//
//  GlChartDataModel.m
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlChartDataModel.h"

@implementation GlChartDataModel
-(NSInteger)max{
    if (_max != 0) {
        return  _max;
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
    if (_min != 0) {
        return  _min;
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
