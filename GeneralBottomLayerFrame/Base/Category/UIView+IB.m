//
//  UIView+IB.m
//  gjj51
//
//  Created by 魏裕群 on 15/5/7.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import "UIView+IB.h"
#import <objc/runtime.h>

static char action;

@implementation UIView (IB)

//-(void)addAction:(GjjBlock)handle{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
//    [self addGestureRecognizer:tap];
//    self.userInteractionEnabled = YES;
//
//    objc_setAssociatedObject(self, &action, handle, OBJC_ASSOCIATION_COPY);
//}
//
//-(void)click{
//    GjjBlock handle = objc_getAssociatedObject(self, &action);
//    if (handle) {
//        handle();
//    }
//}

- (void)addTarget:(id)target selector:(SEL)selector {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
}

-(void)setBorderWidth:(NSNumber *)borderWidth{
    self.layer.borderWidth = borderWidth.floatValue;
}
-(NSNumber *)borderWidth{
    return [NSNumber numberWithFloat:self.layer.borderWidth];
}

-(void)setBorderIBColor:(UIColor*)color
{
    self.layer.borderColor = color.CGColor;
}

-(UIColor*)borderIBColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setShadowIBColor:(UIColor*)color
{
    self.layer.shadowColor = color.CGColor;
}

-(UIColor*)shadowIBColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (UIViewController *)viewControllerSupportView{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIImage*)snapshotFromRect:(CGRect)rect{
    [self layoutIfNeeded];
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, kScreenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [self.layer renderInContext:context];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)drawDashLineWithRect:(CGRect)rect{
   
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFrame:rect];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
//    [shapeLayer setStrokeColor:[UIColor normGray].CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(rect)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:@(5), @(3), nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, kScreenWidth, 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

-(void)drawCornerWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius{
    [self drawCornerWithRect:rect cornerRadius:cornerRadius curveRadius:0 leftCurvePoint:CGPointZero rightCurvePoint:CGPointZero];
}

-(void)drawCornerWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius curveRadius:(CGFloat)curveRadius leftCurvePoint:(CGPoint)leftCurvePoint rightCurvePoint:(CGPoint)rightCurvePoint{
    
    CGFloat height = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(cornerRadius, 0)];
    [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:-0.5*M_PI endAngle:-M_PI clockwise:NO];
    [path addLineToPoint:leftCurvePoint];
    [path addArcWithCenter:leftCurvePoint radius:curveRadius startAngle:-0.5*M_PI endAngle:0.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(0, height - cornerRadius)];
    [path addArcWithCenter:CGPointMake(cornerRadius, height - cornerRadius) radius:cornerRadius startAngle:-M_PI endAngle:-1.5*M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(width - cornerRadius, height)];
    [path addArcWithCenter:CGPointMake(width - cornerRadius, height - cornerRadius) radius:cornerRadius startAngle:0.5*M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:rightCurvePoint];
    [path addArcWithCenter:rightCurvePoint radius:curveRadius startAngle:0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(width, cornerRadius)];
    [path addArcWithCenter:CGPointMake(width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:0 endAngle:-0.5*M_PI clockwise:NO];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

-(void)cornerLayer:(UIView *)view{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(6, 0)];
    [path addArcWithCenter:CGPointMake(6, 6) radius:6 startAngle:-0.5*M_PI endAngle:-M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(0, 173)];
    [path addArcWithCenter:CGPointMake(0, 173) radius:6 startAngle:-0.5*M_PI endAngle:0.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(0, 346 - 6)];
    [path addArcWithCenter:CGPointMake(6, 346 - 6) radius:6 startAngle:-M_PI endAngle:-1.5*M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(kScreenWidth - 36 -6, 346)];
    [path addArcWithCenter:CGPointMake(kScreenWidth - 36 -6, 346 - 6) radius:6 startAngle:0.5*M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(kScreenWidth - 36, 173)];
    [path addArcWithCenter:CGPointMake(kScreenWidth - 36, 173) radius:6 startAngle:0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(kScreenWidth - 36, 6)];
    [path addArcWithCenter:CGPointMake(kScreenWidth - 36 -6, 6) radius:6 startAngle:0 endAngle:-0.5*M_PI clockwise:NO];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

@end
