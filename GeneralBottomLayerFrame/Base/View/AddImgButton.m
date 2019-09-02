//
//  AddImgButton.m
//  ForestPack
//
//  Created by 郑洲 on 2018/7/10.
//  Copyright © 2018年 郑洲. All rights reserved.
//

#import "AddImgButton.h"

@implementation AddImgButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        
        CGFloat viewWidth = self.width;
        CGFloat viewHeight = self.height;
        self.layer.cornerRadius = 5;
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
        borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5].CGPath;
        borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
        //虚线边框
        borderLayer.lineDashPattern = @[@4, @4];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = REXADECIMALCOLOR(@"#dcdcdc").CGColor;
        [self.layer addSublayer:borderLayer];
    }
    return self;
}


@end
