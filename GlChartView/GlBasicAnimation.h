//
//  GlBasicAnimation.h
//  YKCharts
//
//  Created by gleeeli on 2018/9/4.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@protocol GlAnimationDelgate<NSObject>
@optional
- (void)animationDidStop:(CAAnimation *)anim;

@end

@interface GlBasicAnimation : CABasicAnimation<CAAnimationDelegate>
@property (nonatomic,weak) id<GlAnimationDelgate> gldelegate;
@end
