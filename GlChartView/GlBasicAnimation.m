//
//  GlBasicAnimation.m
//  YKCharts
//
//  Created by 小柠檬 on 2018/9/4.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlBasicAnimation.h"

@implementation GlBasicAnimation
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.gldelegate respondsToSelector:@selector(animationDidStop:)]) {
        [self.gldelegate animationDidStop:anim];
    }
}

- (void)setGldelegate:(id<GlAnimationDelgate>)gldelegate{
    _gldelegate = gldelegate;
    self.delegate = self;
}

- (void)dealloc {
    NSLog(@"dealloc***GlBasicAnimation");
}
@end
