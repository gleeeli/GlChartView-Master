//
//  GlChartViewDelegate.h
//  YKCharts
//
//  Created by 小柠檬 on 2018/8/24.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlChartDataModel.h"

@protocol GlChartViewDelegate <NSObject>
- (NSArray *)glPopClickShowContent:(GlChartDataModel *)dataSource index:(NSInteger)index;
@end
