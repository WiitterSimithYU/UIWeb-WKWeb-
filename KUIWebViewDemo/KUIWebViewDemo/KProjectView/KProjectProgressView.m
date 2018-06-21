//
//  KProjectProgressView.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "KProjectProgressView.h"

@implementation KProjectProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)ColorFromSixteen(0x4ad9a4, 1.0).CGColor,
                                 (__bridge id)ColorFromSixteen(0x4ad9a4, 1.0).CGColor,
                                 (__bridge id)ColorFromSixteen(0x4ad9a4, 1.0).CGColor];
        gradientLayer.locations  = @[@0.4,@0.6, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint   = CGPointMake(1.0, 0);
        gradientLayer.frame      = CGRectMake(0, 0, MainScreenWidth, self.frame.size.height);
        [self.layer addSublayer:gradientLayer];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
