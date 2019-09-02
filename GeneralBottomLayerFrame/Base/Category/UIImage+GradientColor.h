//
//  UIImage+GradientColor.h
//  欧陆风庭
//
//  Created by 郑洲 on 2018/4/9.
//  Copyright © 2018年 eage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom = 0,//从上到下
    
    GradientTypeLeftToRight = 1,//从左到右
    
    GradientTypeUpleftToLowright = 2,//左上到右下
    
    GradientTypeUprightToLowleft = 3,//右上到左下
    
};

@interface UIImage (GradientColor)

+ (UIImage *)initWithColor:(UIColor *)color;

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

/*
 UIImage *bgImg = [UIImage gradientColorImageFromColors:@[REXADECIMALCOLOR(@"#cccccc"),REXADECIMALCOLOR(@"#cccccc")] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(ScreenX375(80), ScreenX375(24))];
 UIView *codeRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenX375(80), ScreenX375(37))];
 _verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenX375(6), ScreenX375(80), ScreenX375(24))];
 [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
 [_verCodeBtn setTitleColor:REXADECIMALCOLOR(@"#ffffff") forState:UIControlStateNormal];
 _verCodeBtn.titleLabel.font = Kfont(12);
 [_verCodeBtn addTarget:self action:@selector(sendVerCode:) forControlEvents:UIControlEventTouchUpInside];
 [_verCodeBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
 _verCodeBtn.layer.cornerRadius = ScreenX375(12);
 _verCodeBtn.clipsToBounds = YES;
 [codeRight addSubview:_verCodeBtn];
 */

@end
