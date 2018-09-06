//
//  GlLineChartView.h
//  YKCharts
//
//  Created by 小柠檬 on 2018/8/23.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlChartDataModel.h"
#import "GlChartConfig.h"
#import "GlChartViewDelegate.h"

@interface GlLineChartView : UIView
@property (nonatomic, weak) id<GlChartViewDelegate> delegate;
-(void)setupDataSource:(GlChartDataModel *)data withUIConfgi:(GlChartConfig *)config;
@end
