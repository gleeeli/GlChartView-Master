//
//  GlChartConfig.m
//  YKCharts
//
//  Created by gleeeli on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlChartConfig.h"

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
    return config;
}
@end
