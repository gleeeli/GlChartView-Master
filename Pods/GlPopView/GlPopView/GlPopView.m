//
//  GlPopView.m
//  YKCharts
//
//  Created by luoluo on 2018/8/25.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "GlPopView.h"

@interface GlPopView()

@end

@implementation GlPopView

- (instancetype)init{
    self = [super init];
    if (self){
        [self setDefaultView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setDefaultView];
    }
    return self;
}

/**
 设置默认属性
 */
- (void)setDefaultView{
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor whiteColor];
    self.lineWidth = 2.0;
    self.lineColor = [UIColor orangeColor];
    self.cornerRadius = 5.0;

    self.rectCornerType = UIRectCornerAllCorners;
    //self.rectCornerType = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //self.rectCornerType = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
    
    //箭头
    self.congfig = [[GlPopViewConfig alloc] init];
    self.congfig.widthArrow = 20;
    self.congfig.heightArrow = 20;
    self.congfig.radiusArrow = 3;
    self.congfig.directionArrow = GlArrowDirectionLeft;//GlArrowDirectionBottom
    self.congfig.alignmentArrow = GlArrowAlignmentCenter;
    self.congfig.paddingDirectionArrow  = self.congfig.alignmentArrow == GlArrowAlignmentCenter? 0 : 5;
    self.congfig.offsetopHorizontalArrow = 0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    // 考虑到箭头 给内容区域定范围
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = width;
    CGFloat maxY = height;
    
    //带箭头 初始化边距信息
    switch (self.congfig.directionArrow) {
        case GlArrowDirectionTop:{
            minY = self.congfig.heightArrow;
        }
            break;
        case GlArrowDirectionLeft:{
            minX = self.congfig.heightArrow;
        }
            break;
        case GlArrowDirectionBottom:{
            maxY = size.height - self.congfig.heightArrow;
        }
            break;
        case GlArrowDirectionRight:{
            maxX =  size.width - self.congfig.heightArrow;
        }
            break;
            
        default:
            break;
    }
    
    

    float lineWidth = self.lineWidth * 0.5;//距离边的距离
    float radius = self.cornerRadius;
    CGFloat rtX = maxX - lineWidth;

    UIBezierPath *path = [UIBezierPath bezierPath];//创建轨道
    
    //右边竖线线的x坐标
    CGFloat rlineX = maxX - lineWidth;
    //右上
    CGFloat rX = (self.rectCornerType & UIRectCornerTopRight) ? rlineX - radius:rlineX;
    [path moveToPoint:CGPointMake(rX,lineWidth + minY)];
    if ((self.rectCornerType & UIRectCornerTopRight)) {
        //右上圆角
        //clockwise YES为顺时针 将圆分成四分 0 ，M_PI_2（二分之π）） ，M_PI ，M_PI_2*3
        [path addArcWithCenter:CGPointMake(rlineX - radius, minY + lineWidth + radius) radius:radius startAngle:M_PI_2*3 endAngle:0 clockwise:YES];
        rtX = rtX - radius;
    }
    
    //右边箭头
    if (self.congfig && self.congfig.directionArrow == GlArrowDirectionRight) {
        
        CGPoint arrowPoint = [self getArrowPointWithDirection:GlArrowDirectionRight width:width height:height];
        //先画到箭头三角形的底部左边
        [path addLineToPoint:CGPointMake(rlineX, arrowPoint.y - self.congfig.widthArrow * 0.5)];
        CGFloat centAngle = 0;
        [path addArcWithCenter:CGPointMake(arrowPoint.x - self.congfig.radiusArrow, arrowPoint.y + self.congfig.offsetopHorizontalArrow) radius:self.congfig.radiusArrow startAngle:centAngle - M_PI_2 * 0.5 endAngle:centAngle + M_PI_2 * 0.5  clockwise:YES];
        [path addLineToPoint:CGPointMake(rlineX, arrowPoint.y + self.congfig.widthArrow * 0.5)];
    }
    
    //底部线的y坐标
    CGFloat blineY = maxY-lineWidth;
    //右下
    CGFloat rbY = (self.rectCornerType & UIRectCornerBottomRight)? blineY - radius:blineY;
    [path addLineToPoint:CGPointMake(maxX-lineWidth, rbY)];
    if (self.rectCornerType & UIRectCornerBottomRight) {
        //右下角
        [path addArcWithCenter:CGPointMake(maxX-lineWidth-radius, blineY-radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    
    //底部箭头
    if (self.congfig && self.congfig.directionArrow == GlArrowDirectionBottom) {
        CGPoint arrowPoint = [self getArrowPointWithDirection:GlArrowDirectionBottom width:width height:height];
        [path addLineToPoint:CGPointMake(arrowPoint.x + self.congfig.widthArrow * 0.5, blineY)];
        CGFloat centAngle = M_PI_2;
        [path addArcWithCenter:CGPointMake(arrowPoint.x + self.congfig.offsetopHorizontalArrow, arrowPoint.y - self.congfig.radiusArrow) radius:self.congfig.radiusArrow startAngle:centAngle - M_PI_2 * 0.5 endAngle:centAngle + M_PI_2 * 0.5  clockwise:YES];
        [path addLineToPoint:CGPointMake(arrowPoint.x - self.congfig.widthArrow * 0.5, blineY)];
    }
    
    //左边线的x坐标
    CGFloat llineX = minX + lineWidth;
    //左下
    CGFloat lbX = (self.rectCornerType & UIRectCornerBottomLeft)? llineX + radius:llineX;
    [path addLineToPoint:CGPointMake(lbX, maxY-lineWidth)];
    if (self.rectCornerType & UIRectCornerBottomLeft) {
        //左下角
        [path addArcWithCenter:CGPointMake(llineX + radius, maxY - lineWidth - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    
    
    //左边箭头
    if (self.congfig && self.congfig.directionArrow == GlArrowDirectionLeft) {
        CGPoint arrowPoint = [self getArrowPointWithDirection:GlArrowDirectionLeft width:width height:height];
        [path addLineToPoint:CGPointMake(llineX, arrowPoint.y + self.congfig.widthArrow * 0.5)];
        CGFloat centAngle = M_PI;
        [path addArcWithCenter:CGPointMake(arrowPoint.x + self.congfig.radiusArrow, arrowPoint.y + self.congfig.offsetopHorizontalArrow) radius:self.congfig.radiusArrow startAngle:centAngle - M_PI_2 * 0.5 endAngle:centAngle + M_PI_2 * 0.5  clockwise:YES];
        [path addLineToPoint:CGPointMake(llineX, arrowPoint.y - self.congfig.widthArrow * 0.5)];
    }
    
    //左上
    CGFloat ltY = (self.rectCornerType & UIRectCornerTopLeft)? minY + lineWidth + radius:minY + lineWidth;
    [path addLineToPoint:CGPointMake(minX + lineWidth, ltY)];
    if (self.rectCornerType & UIRectCornerTopLeft) {
        //左上角
        [path addArcWithCenter:CGPointMake(minX + lineWidth + radius, minY + lineWidth + radius) radius:radius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    }
    
    CGFloat tlineY = minY + lineWidth;
    //顶部箭头
    if (self.congfig && self.congfig.directionArrow == GlArrowDirectionTop) {
        CGPoint arrowPoint = [self getArrowPointWithDirection:GlArrowDirectionTop width:width height:height];
        [path addLineToPoint:CGPointMake(arrowPoint.x - self.congfig.widthArrow * 0.5, tlineY)];
        CGFloat centAngle = M_PI * 3.0/2.0;
        [path addArcWithCenter:CGPointMake(arrowPoint.x + self.congfig.offsetopHorizontalArrow, arrowPoint.y + self.congfig.radiusArrow) radius:self.congfig.radiusArrow startAngle:centAngle - M_PI_2 * 0.5 endAngle:centAngle + M_PI_2 * 0.5  clockwise:YES];
        [path addLineToPoint:CGPointMake(arrowPoint.x + self.congfig.widthArrow * 0.5, tlineY)];
    }

    [path addLineToPoint:CGPointMake(rtX, tlineY)];
    path.lineWidth = self.lineWidth;

    //填充的颜色
    [self.fillColor setFill];

    //线颜色
    [self.lineColor setStroke];

    [path stroke];
    [path fill];
}

//箭头顶点坐标
- (CGPoint)getArrowPointWithDirection:(GlArrowDirection)direction width:(CGFloat)width height:(CGFloat)height{
    CGPoint point = CGPointZero;
    switch (direction) {
        case GlArrowDirectionTop:
        {
            switch (self.congfig.alignmentArrow) {
                case GlArrowAlignmentLeft:
                {
                    point = CGPointMake(self.lineWidth + self.cornerRadius + self.congfig.paddingDirectionArrow + self.congfig.widthArrow * 0.5, self.lineWidth * 0.5);
                }
                    break;
                case GlArrowAlignmentCenter:
                {
                    point = CGPointMake(width * 0.5  , self.lineWidth * 0.5);
                }
                    break;
                case GlArrowAlignmentRight:
                {
                    point = CGPointMake(width - self.lineWidth - self.cornerRadius - self.congfig.paddingDirectionArrow - self.congfig.widthArrow * 0.5, self.lineWidth * 0.5);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case GlArrowDirectionLeft:
        {
            switch (self.congfig.alignmentArrow) {
                case GlArrowAlignmentLeft:
                {
                    point = CGPointMake(self.lineWidth * 0.5, self.lineWidth + self.cornerRadius + self.congfig.paddingDirectionArrow + self.congfig.widthArrow * 0.5);
                }
                    break;
                case GlArrowAlignmentCenter:
                {
                    point = CGPointMake(self.lineWidth * 0.5, height * 0.5);
                }
                    break;
                case GlArrowAlignmentRight:
                {
                    point = CGPointMake(self.lineWidth * 0.5, height - self.lineWidth - self.cornerRadius - self.congfig.paddingDirectionArrow - self.congfig.widthArrow * 0.5);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case GlArrowDirectionBottom:
        {
            switch (self.congfig.alignmentArrow) {
                case GlArrowAlignmentLeft:
                {
                    point = CGPointMake(self.lineWidth + self.cornerRadius + self.congfig.paddingDirectionArrow + self.congfig.widthArrow * 0.5, height - self.lineWidth * 0.5);
                }
                    break;
                case GlArrowAlignmentCenter:
                {
                    point = CGPointMake(width * 0.5  , height - self.lineWidth * 0.5);
                }
                    break;
                case GlArrowAlignmentRight:
                {
                    point = CGPointMake(width - self.lineWidth - self.cornerRadius - self.congfig.paddingDirectionArrow - self.congfig.widthArrow * 0.5, height - self.lineWidth * 0.5);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case GlArrowDirectionRight:
        {
            switch (self.congfig.alignmentArrow) {
                case GlArrowAlignmentLeft:
                {
                    point = CGPointMake(width  - self.lineWidth * 0.5, self.lineWidth + self.cornerRadius + self.congfig.paddingDirectionArrow + self.congfig.widthArrow * 0.5);
                }
                    break;
                case GlArrowAlignmentCenter:
                {
                    point = CGPointMake(width  - self.lineWidth * 0.5, height * 0.5);
                }
                    break;
                case GlArrowAlignmentRight:
                {
                    point = CGPointMake(width  - self.lineWidth * 0.5, height - self.lineWidth - self.cornerRadius - self.congfig.paddingDirectionArrow - self.congfig.widthArrow * 0.5);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return point;
}
@end
