//
//  GlLineChartView.m
//  YKCharts
//
//  Created by gleeeli on 2018/8/23.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlLineChartView.h"
#import "GlDrawLineView.h"
#import "GlXYCoordView.h"
#import "GlPopView.h"

//version 1.0.4
#define  MinItemWith 10
@interface GlLineChartView()<GlDrawLineViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) GlDrawLineView *drawLineView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) GlChartConfig *config;
@property (nonatomic, strong) NSMutableArray *drawPoints;
//x间距宽度 第一个不考虑进去
@property (nonatomic, assign) CGFloat xItemWidth;
@property (nonatomic, assign) CGFloat chartYLength;//y轴线高度
@property (nonatomic, assign) CGFloat xBottomHeight;//x轴线和文字总高度
@property (nonatomic, assign) CGFloat yLeftWidth;//y轴线和文字总宽度
@property (nonatomic, assign) NSInteger numberOfYLines;
@property (nonatomic, assign) CGFloat pointOffsety;//点偏移值
@property (nonatomic, assign) CGFloat topOffset;//顶部偏移
////x轴最后一个元素显示不全的考虑，增加点宽度
@property (nonatomic, assign) CGFloat xRightSpaceWidth;
@property (nonatomic, strong) GlXYCoordView *coordYview;
@property (nonatomic, strong) GlXYCoordView *coordXview;
@property (nonatomic, strong) GlPopView *showBackView;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, assign) CGPoint curSelPoint;
@property (nonatomic, assign) CGSize curPopSize;
@end

@implementation GlLineChartView
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseInfo];
    }
    return self;
}

- (void)initBaseInfo{
    self.backgroundColor = UIColor.whiteColor;
    _xBottomHeight = 25;
    _yLeftWidth = 50;
    self.pointOffsety = 10;
    self.topOffset = 10;
    
    _chartYLength = self.bounds.size.height - _xBottomHeight - self.topOffset;
    _xItemWidth = 40;
    self.numberOfYLines = 3;
    
    if (_drawPoints == nil) {
        _drawPoints = [NSMutableArray new];
    }
}

-(void)setupwithConfgi:(GlChartConfig *)config {
    _config = config;
    [self emptyCharts];
    if (config.scaleNumbers.count == 0) {
        return;
    }
    
    [self updateBaseLayout];
    
    if (config.linesCountY > 0) {
        self.numberOfYLines = config.linesCountY;
    }
    [self updateItemWidth];
    [self installYLines];
    [self installXLines];
    [self installDrawlines];
    [self installPointsText];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateItemWidth{
    NSArray *array = [self getYArray];
    CGFloat maxYWordWidth = [self contentLength:array font:_config.yDescFront];
    self.yLeftWidth = maxYWordWidth + 5;//调节y轴宽度 字的宽度上增加点宽度
    
    CGFloat maxXWordWidth = [self contentLength:_config.xDescriptionDataSource font:_config.xDescFront];
    CGFloat minSpaceWidth = maxXWordWidth * 0.5 > MinItemWith? maxXWordWidth * 0.5:MinItemWith;
    
    self.xRightSpaceWidth = minSpaceWidth;
    
    //此处减minSpaceWidth 不考虑进第一个元素，第一个元素坐标定死为 minSpaceWidth
    CGFloat drawVisibleWith = self.bounds.size.width - self.yLeftWidth - self.xRightSpaceWidth - minSpaceWidth;
    
    // -1 不考虑第一个
    _xItemWidth = [_config.xDescriptionDataSource count] > 1? drawVisibleWith /([_config.xDescriptionDataSource count] - 1):MinItemWith;
    
    if (_xItemWidth < maxXWordWidth) {//显示区域无法满足显示这么多的时候
        
        if(_config.iscurtailX){//缩减x轴
//            CGFloat relMinWidth = _xItemWidth;
            //最多显示个数
            NSInteger maxShowNum = drawVisibleWith / maxXWordWidth + 1;
            NSInteger allCount = [_config.xDescriptionDataSource count];
            //需要减少的倍数
            NSInteger multiple = roundf(allCount / (float)maxShowNum);
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(int i =0; i < allCount; i++){
                if(i % multiple == 0){
                    [array addObject:_config.xDescriptionDataSource[i]];
                }
                else{
                    [array addObject:@""];
                }
            }
            _config.xDescriptionDataSource = array;
            //_xItemWidth = maxXWordWidth;
        }else{
            _xItemWidth = maxXWordWidth;
        }
    }
    _xItemWidth = _xItemWidth < MinItemWith? MinItemWith:_xItemWidth;
    
    //NSLog(@"最小宽度:%f",_xItemWidth);
}

/**
 计算折线每个点的坐标
 */
-(void)installDrawlines{
    for (NSInteger i = 0 ; i < _config.scaleNumbers.count; i ++){
        NSNumber *data = [_config.scaleNumbers objectAtIndex:i];
        double number = [data doubleValue];
        //计算 y 的位置 （当前数字在整个y的百分比）
        long interval = _config.max - _config.min;
        
        CGFloat percentage = interval > 0? (1 - fabs(number-_config.min)/labs(interval)) : 1;
        //NSLog(@"percentage:%f",percentage);
        CGFloat yOffset = _chartYLength  * percentage + self.pointOffsety;
        CGFloat xOffset = _xItemWidth * i;
        CGPoint drawPoint = CGPointMake(xOffset, yOffset);
        
        //NSLog(@"drawPoint:%@", NSStringFromCGPoint(drawPoint));
        [_drawPoints addObject:[NSValue valueWithCGPoint:drawPoint]];
    }
    [self.drawLineView setPoints:_drawPoints uiconfig:_config];
}

//绘制每个点上方的提示文字
-(void)installPointsText {
    if (self.config.disablePointText) {
        return;
    }
    if (self.textBackView == nil) {
        self.textBackView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.textBackView];
    }
    for (UIView *tmpView in self.textBackView.subviews) {
        [tmpView removeFromSuperview];
    }
    
    for (NSInteger i = 0 ; i < _config.originNumbers.count; i ++) {
        CGPoint drawPoint = [[_drawPoints objectAtIndex:i] CGPointValue];
        //第一个不会绘制，y坐标就在第一个，没必要
        if (i > 0 && i < [self.config.originNumbers count]) {
            NSString *pointStr  = [NSString stringWithFormat:@"%@", self.config.originNumbers[i]];
            CGPoint realPoint = [self.drawLineView convertPoint:drawPoint toView:self.textBackView];
            UILabel *textLab = [[UILabel alloc] init];
            textLab.textColor = self.config.pointHintTextColor;
            textLab.font = self.config.pointHintTextFront;
            textLab.text = pointStr;
            [textLab sizeToFit];
            CGRect frame = textLab.frame;
            frame.origin.x = realPoint.x - frame.size.width * 0.5;
            frame.origin.y = realPoint.y - frame.size.height - 5;
            textLab.frame = frame;
            
            [self.textBackView addSubview:textLab];
        }
    }
}

-(void)installYLines{
    NSArray *yArray = [self getYArray];
    
    CGFloat offset = self.topOffset;
    CGFloat itemtWidth = _chartYLength / ([yArray count] -1);
    // 此处乘以2是考虑顶部和底部都增加间隙
    GlXYCoordView *coordYview = [[GlXYCoordView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _chartYLength + offset *2)];
    self.coordYview = coordYview;
    coordYview.directon = GlDirectionY;
    coordYview.titleArray = yArray;
    coordYview.isNeedGuidLine = self.config.isShowYHorizontalStretchline;
    coordYview.mainMaxWith = self.yLeftWidth;
    coordYview.offsetSPaceXY = offset;
    coordYview.itemWith = itemtWidth;
    coordYview.isNeedSubscriptLine = self.config.isShowYLeftGuideline;
    coordYview.lineColor = _config.ylineColor;
    coordYview.wordColor = _config.yDescColor;
    coordYview.wordFont = _config.yDescFront;
    coordYview.wordInsert = _config.wordYInset;
    coordYview.config = self.config;
    [self addSubview:coordYview];
    [self sendSubviewToBack:coordYview];
}

-(void)installXLines{
    CGFloat count = [_config.xDescriptionDataSource count];
    CGFloat y = self.bounds.size.height - self.xBottomHeight;
    CGFloat offsetX = self.xRightSpaceWidth;
    GlXYCoordView *coordXview = [[GlXYCoordView alloc] initWithFrame:CGRectMake(-offsetX, y, _xItemWidth * count + self.xRightSpaceWidth, self.xBottomHeight)];
    self.coordXview = coordXview;
    coordXview.itemWith = _xItemWidth;
    coordXview.directon = GlDirectionX;
    coordXview.titleArray = _config.xDescriptionDataSource;
    coordXview.lineColor = _config.xlineColor;
    coordXview.wordColor = _config.xDescColor;
    coordXview.wordFont = _config.xDescFront;
    coordXview.iscurtailHiddenEmptyTitle = _config.iscurtailX;
    coordXview.offsetSPaceXY = offsetX;
    coordXview.config = self.config;
    [self.contentScrollView addSubview:coordXview];
    [self.contentScrollView sendSubviewToBack:coordXview];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateBaseLayout];
}

- (void)updateBaseLayout {
    //y轴每一段高度
    //CGFloat lineHeight = _chartYLength/(_numberOfYLines - 1);
    
    CGRect sRect = self.bounds;
    sRect.origin.x = self.yLeftWidth;
    sRect.size.width = sRect.size.width - self.yLeftWidth;
    
    //NSLog(@"sRect:%@", NSStringFromCGRect(sRect));
    _contentScrollView.frame = sRect;
    CGFloat contentWidth = _xItemWidth * (_config.xDescriptionDataSource.count);
    _contentScrollView.contentSize = CGSizeMake(contentWidth + self.xRightSpaceWidth, self.bounds.size.height);
    
    //绘图
    CGFloat bottomDrawOffset = 10;//防止底部被截断
    self.drawLineView.frame = CGRectMake(0, self.topOffset - self.pointOffsety, contentWidth + self.xRightSpaceWidth, _chartYLength + self.pointOffsety + bottomDrawOffset);
}

-(void)emptyCharts{
    [self.coordXview removeFromSuperview];
    [self.coordYview removeFromSuperview];
    self.coordXview = nil;
    self.coordYview = nil;
    [_drawPoints removeAllObjects];
    while (self.drawLineView.layer.sublayers.count) {
        [self.drawLineView.layer.sublayers.lastObject removeFromSuperlayer];
    }
    [self.drawLineView setNeedsDisplay];
    _showBackView.hidden = YES;
}

- (NSArray *)getYArray{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    double interval = 0;
    if (self.config.min >= 0) {
        interval = self.config.max / (float)(self.numberOfYLines);
        
    }
    else{
        interval = (self.config.max - self.config.min) / (float)(self.numberOfYLines);
    }
    
    NSString *preStr = @"";
    for (int i = 0; i < self.numberOfYLines + 1; i++) {
        double nowSign = (self.config.min + interval * i) / ChartMulriple;
        
        NSNumber *showNum = [NSNumber numberWithDouble:nowSign];
        NSString * tmp = [NSString stringWithFormat:@"%@%@",[self decimalWithNUmber:showNum num:self.config.decimalNum], self.config.ySuffix];
        
        NSString *showTmp = tmp;
        if ([preStr isEqualToString:tmp] && i != 0) {//前一个数据和当前一样，则当前的置空不显示，防止都是0%的情况
            showTmp = @"";
        }
        preStr = tmp;
        [array addObject:showTmp];
    }
    
    return array;
}

- (NSString *)decimalWithNUmber:(NSNumber *)number num:(NSInteger)num{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = num;//最多保留几位小数，就是几
    formatter.groupingSeparator = @"";
    return [formatter stringFromNumber:number];
}

#pragma <YKDrawLineViewDelegate>
-(double)getItemLength{
    return  _xItemWidth;
}

/**
 点击原点
 */
-(void)touchAtIndex:(NSInteger)index{
    if (index < 1) {
        return;
    }
    if ( index > _drawPoints.count ) {
        return;
    }
    //点击节点弹出的内容
    if (self.delegate == nil) {
        NSLog(@"error:未添加点击代理回掉");
        return;
    }
    
    CGPoint drawPoint = [[_drawPoints objectAtIndex:index-1] CGPointValue];
    NSArray *array = [self.delegate glPopClickShowContent:self.config index:index-1];
    CGFloat backWith = [self contentLength:array font:[UIFont systemFontOfSize:11]] + 10;
    CGFloat lineHeight = 18;
    CGFloat height = lineHeight * [array count] + 20;
    self.curSelPoint = drawPoint;
    NSLog(@"pop宽度:%f",backWith);
    self.curPopSize = CGSizeMake(backWith, height);
    
    self.showBackView.frame = [self getShowBackViewFrameWithNowPoint:drawPoint];
    self.showBackView.hidden = NO;
    for (UIView *view in self.showBackView.subviews) {
        [view removeFromSuperview];
    }
    [self bringSubviewToFront:self.showBackView];
    
    for (int i = 0; i < [array count]; i++) {
        NSString *title = array[i];
        CGFloat top = self.showBackView.congfig.directionArrow == GlArrowDirectionBottom? (i * lineHeight + 7):(i * lineHeight + 7 + self.showBackView.congfig.heightArrow);
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, top, backWith-5, lineHeight)];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.text = title;
        leftLabel.font = [UIFont systemFontOfSize:11];
        [self.showBackView addSubview:leftLabel];
    }
    self.showBackView.alpha = 0;
    self.showBackView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.showBackView.alpha = 1;
                         self.showBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

- (CGRect)getShowBackViewFrameWithNowPoint:(CGPoint)drawPoint
{
    CGRect drawRect = CGRectMake(drawPoint.x - self.config.circleWidth, drawPoint.y - self.config.circleWidth,  self.config.circleWidth * 2,  self.config.circleWidth * 2);
    
    CGFloat backWith = self.curPopSize.width;
    CGFloat height = self.curPopSize.height;
    CGFloat by = drawRect.origin.y - height - 5;
    CGFloat bX = drawPoint.x - backWith * 0.5 + self.yLeftWidth;
    
    CGFloat max = self.bounds.size.width;
    CGFloat minx = 10;//self.yLeftWidth(坐标y轴宽)
    
    if (by < 0) {//节点的y坐标超出view 则弹窗放下面 否则点击不响应
        by = CGRectGetMaxY(drawRect) + 5;
        self.showBackView.congfig.directionArrow = GlArrowDirectionTop;
    }
    else{
        self.showBackView.congfig.directionArrow = GlArrowDirectionBottom;
    }
    [self.showBackView setNeedsDisplay];
    
    CGRect frame = CGRectMake(bX, by, backWith, height);
    bX  -= self.contentScrollView.contentOffset.x;
    
    if (bX + backWith > max) {
        bX = max - backWith - 10;
    }
    
    if (bX < minx) {
        bX = minx + 10;
    }
    frame.origin.x = bX;
    
    return frame;
}

- (GlPopView *)showBackView{
    if (_showBackView == nil) {
        GlPopView *showBackView = [[GlPopView alloc] init];
        _showBackView = showBackView;
        showBackView.cornerRadius = 3.0;
        showBackView.lineWidth = 0.5;
        showBackView.lineColor = [UIColor grayColor];
        showBackView.fillColor = [UIColor whiteColor];
        showBackView.congfig.directionArrow = GlArrowDirectionBottom;
        showBackView.congfig.heightArrow = 7;
        showBackView.congfig.widthArrow = 7;
        showBackView.congfig.radiusArrow = 1.0;
        showBackView.rectCornerType = UIRectCornerAllCorners;
        [showBackView addTarget:self action:@selector(popViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showBackView];
    }
    return _showBackView;
}

- (void)popViewClick:(id)sender{
    NSLog(@"点击弹框");
    self.showBackView.hidden = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

/**
 获取字符数组中最宽的字符串宽度
 */
-(CGFloat)contentLength:(NSArray *)array font:(UIFont *)font{
    CGFloat maxWidth = 0;
    for (NSString *content in array) {
        UILabel *testLabel = [UILabel new];
        testLabel.font = font;
        testLabel.text = content;
        testLabel.frame = CGRectMake(0, 0, MAXFLOAT, font.lineHeight);
        testLabel.numberOfLines = 0;
        [testLabel sizeToFit];
        
        CGFloat now = testLabel.bounds.size.width + 10;
        if (maxWidth < now) {
            maxWidth = now;
        }
    }
    
    return maxWidth;
}

- (GlDrawLineView *)drawLineView{
    
    if (_drawLineView == nil) {
        _drawLineView = [GlDrawLineView new];
        _drawLineView.delegate = self;
        [self.contentScrollView addSubview:_drawLineView];
    }
    
    return _drawLineView;
}

- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        _contentScrollView = [UIScrollView new];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.clipsToBounds = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_showBackView&& !_showBackView.hidden) {
        CGRect rect = [self getShowBackViewFrameWithNowPoint:self.curSelPoint];
        self.showBackView.frame = rect;
    }
}

- (void)dealloc{
    //NSLog(@"***释放画图***");
}
@end
