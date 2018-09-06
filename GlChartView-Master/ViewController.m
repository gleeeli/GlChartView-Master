//
//  ViewController.m
//  GlChartView-Master
//
//  Created by 小柠檬 on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "ViewController.h"
#import "GlChartConfig.h"
#import "GlChartDataModel.h"
#import "GlLineChartView.h"

@interface ViewController ()<GlChartViewDelegate>
{
    GlLineChartView *_glChartView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //y轴
    GlChartConfig *config = [GlChartConfig getCommConfig];
    config.iscurtailX = YES;
    config.lineColors = [NSArray arrayWithObjects:[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor], nil];
    GlChartDataModel *dataObject = [GlChartDataModel new];
    dataObject.ySuffix = @"%";
    dataObject.xDescriptionDataSource = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周七",@"周七",@"周七",@"周七",@"周七",@"周七",@"周七",@"周十"];
    dataObject.originNumbers = @[@(0.0),@(0.1),@(0.2),@(0.23),@(0.62),@(0.82),@(0.2),@(0.82),@(0.2),@(0.82),@(1.5),@(2)];//,@(90.72)
    
    //----------------------------------
    
    GlLineChartView *glChartView = [[GlLineChartView alloc] initWithFrame:CGRectMake(10, 300, self.view.bounds.size.width - 48, 130)];
    _glChartView = glChartView;
    glChartView.delegate = self;
    //glChartView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:glChartView];
    [glChartView setupDataSource:dataObject withUIConfgi:config];
}

#pragma mark <GlChartViewDelegate>
- (NSArray *)glPopClickShowContent:(GlChartDataModel *)dataSource index:(NSInteger)index{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([dataSource.popDataSource count] > index) {
        NSString *popdata = [dataSource.popDataSource objectAtIndex:index];
        NSString *showContent = [NSString stringWithFormat:@"第一项：%@",popdata];
        [array addObject:showContent];
    }
    
    if ([dataSource.scaleNumbers count] > index) {
        CGFloat percent = [dataSource.scaleNumbers[index] floatValue]/ ChartMulriple;
        NSString *showPercent = [NSString stringWithFormat:@"第二项：%.2f%%",percent];
        [array addObject:showPercent];
    }
    
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
