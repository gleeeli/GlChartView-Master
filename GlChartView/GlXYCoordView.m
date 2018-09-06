//
//  GlXYCoordView.m
//  YKCharts
//
//  Created by 小柠檬 on 2018/8/23.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlXYCoordView.h"

@interface GlXYCoordView()


@end

@implementation GlXYCoordView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initBaseView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    self.backgroundColor = [UIColor clearColor];
    self.titleArray = [[NSMutableArray alloc] init];
    self.directon = GlDirectionX;
    self.lineWidth = 0.5;
    self.subScriptLenght = 5;
    self.lineColor = [UIColor orangeColor];
    self.isNeedSubscriptLine = YES;
    self.wordInsert = 5.0;
    self.offsetSPaceXY = 10.0;
    self.wordColor = [UIColor blackColor];
    self.wordFont = [UIFont systemFontOfSize:11];
}

- (void)drawRect:(CGRect)rect {
    if([self.titleArray count] == 0){
        return;
    }
    
    if (_directon == GlDirectionX) {
        [self drawXRect:rect];
    }
    else{
        [self drawYRect:rect];
    }
}

#define 画X轴方向
/**
 绘制x轴方向
 */
- (void)drawXRect:(CGRect)rect{
    CGSize size = rect.size;
    CGFloat yoffset = self.lineWidth * 0.5;
    CGPoint lastPoint = CGPointMake(0, yoffset);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //先画横线
    [path moveToPoint:lastPoint];
    [path addLineToPoint:CGPointMake(size.width, yoffset)];
    
    for (int i = 0; i < [self.titleArray count]; i++) {
        NSString *title = self.titleArray[i];
        CGFloat nowX = _itemWith * (i + 1);
        
        //小凸点
        if (self.isNeedSubscriptLine) {
            
            CGPoint nowPoint = CGPointMake(nowX, self.lineWidth);
            CGPoint nowBottomPoint = CGPointMake(nowX, self.subScriptLenght);
            
            if(self.iscurtailHiddenEmptyTitle && [title isEqualToString:@""]){
                [path moveToPoint:nowPoint];
                nowBottomPoint.y  = nowBottomPoint.y * 0.5;
                [path addLineToPoint:nowBottomPoint];
            }
            else {//非空字符才画下标
                //画向下坐标线
                [path moveToPoint:nowPoint];
                [path addLineToPoint:nowBottomPoint];
            }
            
        }
        
        //画坐标上的字
        
        CGFloat titleWidth = self.iscurtailHiddenEmptyTitle? [self getTextWidthtitle:title font:self.wordFont]:_itemWith;
        CGFloat tmpTopY = self.isNeedSubscriptLine ? self.subScriptLenght:self.lineWidth;
        [self drawXTitle:CGRectMake(nowX, tmpTopY + self.wordInsert, titleWidth, 15) title:title];
    }
    path.lineWidth = self.lineWidth;
    [self.lineColor setStroke];//将路径描成线
    [path stroke];
}
    
- (CGFloat)getTextWidthtitle:(NSString *)title font:(UIFont *)font{
        UILabel *testLabel = [UILabel new];
        testLabel.font = font;
        testLabel.text = title;
        testLabel.frame = CGRectMake(0, 0, MAXFLOAT, font.lineHeight);
        testLabel.numberOfLines = 0;
        [testLabel sizeToFit];
        
        CGFloat now = testLabel.bounds.size.width + 10;
     return now;
}

- (void)drawXTitle:(CGRect)rect title:(NSString *)title{
    UIFont *font = self.wordFont;
    CGRect titlrect = [title boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    NSDictionary *dict  =@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.wordColor };
    //居中显示
    CGFloat realX = rect.origin.x - titlrect.size.width * 0.5;
    titlrect.origin.x = realX;
    titlrect.origin.y = rect.origin.y;
    
    [title drawInRect:titlrect withAttributes:dict];
}

#define 画Y轴方向
/**
 绘制y轴方向
 */
- (void)drawYRect:(CGRect)rect{
    CGSize size = rect.size;
    CGFloat maxWidth = size.width;
    CGFloat bottomY = size.height - self.offsetSPaceXY;
    if (self.isNeedGuidLine) {
        maxWidth = self.mainMaxWith;
    }
    CGPoint lastPoint = CGPointMake(maxWidth, 0);
    
    CGFloat startX = maxWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    //先画竖线
    [path moveToPoint:lastPoint];
    [path addLineToPoint:CGPointMake(startX, bottomY)];
    
    // y轴线部分的最左边的坐标
    CGFloat endX = (startX - self.subScriptLenght);
    for (int i = 0; i < [self.titleArray count]; i++) {
        NSString *title = self.titleArray[i];
        CGFloat nowY = bottomY - (_itemWith * i);
        
        //小凸点
        if (self.isNeedSubscriptLine) {
            CGPoint nowPoint = CGPointMake(startX, nowY);
            CGPoint nowLeftPoint = CGPointMake(endX, nowY);
            
            //画向下坐标线
            [path moveToPoint:nowPoint];
            [path addLineToPoint:nowLeftPoint];
        }
        
        //引导线
        if (self.isNeedGuidLine) {
            CGPoint nowPoint = CGPointMake(startX, nowY);
            CGPoint rightPoint = CGPointMake(size.width, nowY);
            
            //画向下坐标线
            [path moveToPoint:nowPoint];
            [path addLineToPoint:rightPoint];
        }
        
        //画坐标上的字
        CGFloat tmpEndX = self.isNeedSubscriptLine ? endX:startX;
        [self drawYTitle:CGRectMake(tmpEndX - self.wordInsert , nowY, _itemWith, 15) title:title];
    }
    path.lineWidth = self.lineWidth;
    [self.lineColor setStroke];
    [path stroke];
}

- (void)drawYTitle:(CGRect)rect title:(NSString *)title{
    UIFont *font = self.wordFont;
    CGRect titlrect = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    NSDictionary *dict  =@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.wordColor};
    //垂直居中显示
    CGFloat realX = rect.origin.x - titlrect.size.width;
    titlrect.origin.x = realX;
    titlrect.origin.y = rect.origin.y - titlrect.size.height * 0.5;
    
    [title drawInRect:titlrect withAttributes:dict];
}
@end
