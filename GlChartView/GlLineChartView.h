//
//  GlLineChartView.h
//  YKCharts
//
//  Created by gleeeli on 2018/8/23.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlChartConfig.h"
#import "GlChartViewDelegate.h"

@interface GlLineChartView : UIView
@property (nonatomic, weak) id<GlChartViewDelegate> delegate;
-(void)setupwithConfgi:(GlChartConfig *)config;
@end
