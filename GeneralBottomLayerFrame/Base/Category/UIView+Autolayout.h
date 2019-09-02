//
//  UIView+Autolayout.h
//  gjj51
//
//  Created by anan on 15-2-11.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Autolayout)
//@property(assign,nonatomic)CGFloat x;
//@property(assign,nonatomic)CGFloat y;
//@property(assign,nonatomic)CGFloat width;
//@property(assign,nonatomic)CGFloat height;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;

//auto layout function
-(void)setX:(float)x y:(float)y width:(float)w height:(float)h;
-(void)setEdge:(UIView*)oview attr:(NSLayoutAttribute)attr constant:(CGFloat)constant;
-(UIView*)layout:(NSDictionary*)info;
-(NSLayoutConstraint*)removeAlignFromParentBottom;
-(void)addFlowSubview:(UIView*)sub margin:(float)m bottom:(float)b;
-(void)addFlowSubview:(UIView*)sub bottom:(float)b;
-(void)addFlowSubview:(UIView*)sub;
-(void)fullWidth;
-(void)fullHeight;
-(void)fullParent;
-(void)centerX;
-(void)centerY;
-(void)equalWidthTo:(UIView*)oview;
-(void)equalWidthTo:(UIView*)oview multipier:(CGFloat)f;
-(void)equalOrGreaterWidthTo:(UIView *)oview multipier:(CGFloat)f;
-(void)equalHeightTo:(UIView*)oview;
-(void)follow:(UIView*)lastView;
-(void)follow:(UIView*)lastView margin:(float)m;
-(void)after:(UIView*)lastView margin:(float)m;
//animation for auto layout
//-(void)startMovie:(NSDictionary*)data andCompleted:(movieCompleted)cb;
-(void)startMovie:(NSDictionary*)data;
@end

@interface Movie : NSObject
//@property(nonatomic,copy)movieCompleted completed;
//@property(nonatomic,assign)float duration;
//@property(nonatomic,retain)NSDictionary *data;
//-(id)initWithView:(UIView*)view data:(NSDictionary*)dic andCompleted:(movieCompleted)cb;
//-(instancetype)initWithView:(UIView*)view data:(NSDictionary*)dic;
//-(void)start;
//-(void)update;
@end
