//
//  UIView+Constraint.h
//  gjj51
//
//  Created by 魏裕群 on 15/6/18.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UILayoutAttributeNone = 0,
    UILayoutAttributeWidth = 1,
    UILayoutAttributeHeight = 1<<1,
    UILayoutAttributeLeft = 1<<2,
    UILayoutAttributeRight = 1<<3,
    UILayoutAttributeTop = 1<<4,
    UILayoutAttributeBottom = 1<<5,
    UILayoutAttributeHorizontal = 1<<6,
    UILayoutAttributeVertical = 1<<7
}UILayoutAttribute;

@class UILayout;

@interface UILayoutProperty : NSObject

-(UILayoutProperty*)initWithLayout:(UILayout*)layout property:(NSLayoutAttribute)attribute;

@property(nonatomic,weak,readonly)UILayout *layout;
@property(nonatomic,assign,readonly)NSLayoutAttribute property;

-(UILayout *(^)(UILayoutProperty *propery,CGFloat constant))spacing;

@end

@interface UILayout : NSObject{
    @protected
    __weak UIView *_view;
    __weak UIView *_relatedView;
    
    UILayoutProperty *_left;
    UILayoutProperty *_right;
    UILayoutProperty *_bottom;
    UILayoutProperty *_top;
}

-(UILayout*)initWithView:(UIView*)view;

@property(nonatomic,weak,readonly)UIView *view;
@property(nonatomic,weak,readonly)UIView *relatedView;

@property(nonatomic,retain,readonly)UILayoutProperty *left;
@property(nonatomic,retain,readonly)UILayoutProperty *right;
@property(nonatomic,retain,readonly)UILayoutProperty *bottom;
@property(nonatomic,retain,readonly)UILayoutProperty *top;

-(UILayout *(^)(UIView*))equalTo;
-(UILayout *(^)(void))end;

-(UILayout *(^)(NSInteger attrs))remove;

-(UILayout *(^)(CGFloat width))width;
-(UILayout *(^)(CGFloat height))height;
-(UILayout *(^)(CGSize size))size;
-(UILayout *(^)(CGFloat ratio))ratio;
-(UILayout *(^)(CGFloat multipier,int attrs))scaleSize;
-(UILayout *(^)(CGFloat rate))scaleWidthToHeight;//宽高比
-(UILayout *(^)(CGFloat rate))scaleHeightToWidth;//高宽比

-(UILayout *(^)(CGPoint point))position;
-(UILayout *(^)(CGFloat x))x;
-(UILayout *(^)(CGFloat y))y;
-(UILayout *(^)(CGFloat))base;
-(UILayout *(^)(CGFloat))rightValue;
-(UILayout *(^)(CGFloat))centerX;
-(UILayout *(^)(CGFloat))centerY;
-(UILayout *(^)(UIEdgeInsets insets))insets;
-(UILayout *(^)(UIEdgeInsets,int))edge;
-(UILayout *(^)(void))fullWidth;
-(UILayout *(^)(void))fullHeight;

-(UILayout *(^)(UIView*view,CGFloat margin))follow;
-(UILayout *(^)(UIView*view,CGFloat margin))after;

-(UILayout *(^)(int))center;

-(UILayout *(^)(UIView*))equalWidth;
-(UILayout *(^)(UIView*))equalHeight;
-(UILayout *(^)(UIView*))equalBottom;
-(UILayout *(^)(UIView*))equalBaseline;
-(UILayout *(^)(UIView*))equalTop;
-(UILayout *(^)(UIView*))equalCenterX;
-(UILayout *(^)(UIView*))equalCenterY;
-(UILayout *(^)(UIView*))equalLeft;
-(UILayout *(^)(UIView*))equalRight;

-(UILayout *(^)(int, CGFloat))centerSkewing;
-(UILayout *(^)(UIViewController*, CGFloat))topLayoutGuide;
-(UILayout *(^)(UIViewController*, CGFloat))bottomLayoutGuide;
@end

@interface UIView (Constraint)
@property(nonatomic,strong,readonly)UILayout *layout;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;


-(void)removeAllSubviews;
+(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay constraint:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
@end
