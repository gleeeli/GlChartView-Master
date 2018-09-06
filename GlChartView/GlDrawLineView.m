//
//  GlDrawLineView.m
//  YKCharts
//
//  Created by 小柠檬 on 2018/9/5.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlDrawLineView.h"
#import "GlBasicAnimation.h"

@interface GlDrawLineView()<GlAnimationDelgate>
{
    NSArray *_pointsArray;
    GlChartConfig *_uiconFig;
    NSInteger _curIndex;
}
@end

@implementation GlDrawLineView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _curIndex = 0;
    }
    return self;
}

-(void)setPoints:(NSArray *)drawPoints uiconfig:(GlChartConfig *)config{
    _pointsArray = drawPoints;
    _uiconFig = config;
    [self setNeedsDisplay];
    
    _curIndex = 0;
    [self startChatAnimationAtIndex];
}

-(CGRect)getRectWithCenterPoint:(CGPoint)point{
    return  CGRectMake(point.x -_uiconFig.circleWidth,  point.y - _uiconFig.circleWidth,  _uiconFig.circleWidth * 2, _uiconFig.circleWidth * 2);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    for (NSInteger i = 0 ; i < _pointsArray.count; i++){
//        NSValue *pointValue = [_pointsArray objectAtIndex:i];
//        NSValue *nextPointValue = nil;
//        if (_pointsArray.count > i+1) {
//            nextPointValue = [_pointsArray objectAtIndex:i+1];
//        }
//        CGPoint point = [pointValue CGPointValue];
//        CGPoint nextPoint = [nextPointValue CGPointValue];
//        //画线
//        if (nextPointValue != nil) {
//            UIBezierPath *linePath = [UIBezierPath bezierPath];
//            linePath.lineWidth = _uiconFig.lineWidth;
//            [_uiconFig.lineColor setStroke];
//            [linePath moveToPoint:point];
//            [linePath addLineToPoint:nextPoint];
//            [linePath stroke];
//        }
//
//        //画圆
//        CGRect getCirRect = [self getRectWithCenterPoint:point];
//        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:getCirRect];
//        [_uiconFig.lineColor setStroke];
//        [UIColor.whiteColor setFill];
//        [circlePath stroke];
//        [circlePath fill];
//
//    }
//}

- (void)startChatAnimationAtIndex{
    NSLog(@"执行下一个");
    if (_curIndex >= [_pointsArray count]) {
        NSLog(@"全部执行完成");
        return;
    }
    NSValue *pointValue = [_pointsArray objectAtIndex:_curIndex];
    NSValue *nextPointValue = nil;
    CGPoint point = [pointValue CGPointValue];
    CGFloat duration = 0.3;
    if (_pointsArray.count > _curIndex+1) {
        nextPointValue = [_pointsArray objectAtIndex:_curIndex+1];
        
        CGPoint nextPoint = [nextPointValue CGPointValue];
        //[keysArray addObject:(__bridge id)[self getCirle:point].CGPath];
        UIBezierPath *linePath = [self getOneToOneLinePoint:point nextPoint:nextPoint];
        
        GlBasicAnimation *animation = [GlBasicAnimation animationWithKeyPath:@"strokeEnd"];
        duration = [self distanceForTwoPoint:point another:nextPoint] / _uiconFig.speed;
        //每次动画的持续时间
        animation.duration = duration;
        //动画起始位置
        animation.fromValue = @(0);
        //动画结束位置
        animation.toValue = @(1);
        animation.gldelegate = self;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = linePath.CGPath;
        shapeLayer.lineWidth = _uiconFig.lineWidth;
        shapeLayer.fillColor = nil;
        shapeLayer.strokeColor = _uiconFig.lineColor.CGColor;
        //添加动画
        [shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        [self.layer addSublayer:shapeLayer];
    }
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    CGRect cirRect = [self getRectWithCenterPoint:point];
    circleLayer.path = [self getCirleWithSize:cirRect.size].CGPath;
    circleLayer.strokeColor = _uiconFig.lineColor.CGColor;;
    circleLayer.frame = cirRect;
    [self.layer addSublayer:circleLayer];
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //每次动画的持续时间
    circleAnimation.duration = duration * 0.5;
    //动画起始位置
    circleAnimation.fromValue = @(0.5);
    //动画结束位置
    circleAnimation.toValue = @(1);
    [circleLayer addAnimation:circleAnimation forKey:@"circleAnimation"];
}

- (UIBezierPath *)getCirleWithSize:(CGSize )size{
    CGRect getCirRect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:getCirRect];
    return circlePath;
}

- (UIBezierPath *)getOneToOneLinePoint:(CGPoint)point nextPoint:(CGPoint)nextPoint{
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:point];
    [linePath addLineToPoint:nextPoint];
    return linePath;
}

- (CGFloat)distanceForTwoPoint:(CGPoint)onePoint another:(CGPoint)another{
    CGFloat deltaX = another.x - onePoint.x;
    CGFloat deltaY = another.y - onePoint.y;
    CGFloat distance = sqrt(deltaX*deltaX + deltaY*deltaY );
    return distance;
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim{
    _curIndex ++;
    [self.layer removeAnimationForKey:@"strokeEndAnimation"];
    [self startChatAnimationAtIndex];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    double itemLength = [self.delegate getItemLength];
    //NSInteger index = touchPoint.x/itemLength + ((NSInteger)touchPoint.x % (NSInteger)itemLength > 0 ? 1 : 0);
    NSInteger index = touchPoint.x/itemLength;
    if (touchPoint.x > (itemLength * index + itemLength * 0.5)) {
        index ++;
    }
    else if(touchPoint.x < (itemLength * index - itemLength * 0.5)){
        index --;
    }
    if (index < 1) {
        index = 1;
    }
    else if (index > [_pointsArray count]){
        index = [_pointsArray count];
    }
    [self.delegate touchAtIndex:index];
    NSLog(@"touchPoint:%f,%f",touchPoint.x,touchPoint.y);
}
@end
