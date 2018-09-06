//
//  GlDrawLineView.h
//  YKCharts
//
//  Created by 小柠檬 on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlChartConfig.h"

@protocol GlDrawLineViewDelegate
-(double)getItemLength;
-(void)touchAtIndex:(NSInteger)index;
@end

@interface GlDrawLineView : UIView
@property (nonatomic,assign) id<GlDrawLineViewDelegate> delegate;

-(void)setPoints:(NSArray *)drawPoints uiconfig:(GlChartConfig *)config;
@end
