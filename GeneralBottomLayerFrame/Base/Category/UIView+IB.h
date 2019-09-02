//
//  UIView+IB.h
//  gjj51
//
//  Created by 魏裕群 on 15/5/7.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IB)
@property(retain,nonatomic)NSNumber *borderWidth;
@property(nonatomic, assign) UIColor* borderIBColor;
@property(nonatomic, assign) UIColor* shadowIBColor;

- (UIViewController *)viewControllerSupportView;

- (UIImage*)snapshotFromRect:(CGRect)rect;

-(void)drawDashLineWithRect:(CGRect)rect;

-(void)drawCornerWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

-(void)drawCornerWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius curveRadius:(CGFloat)curveRadius leftCurvePoint:(CGPoint)leftCurvePoint rightCurvePoint:(CGPoint)rightCurvePoint;

//-(void)addAction:(GjjBlock)handle;

- (void)addTarget:(id)target selector:(SEL)selector;

@end
