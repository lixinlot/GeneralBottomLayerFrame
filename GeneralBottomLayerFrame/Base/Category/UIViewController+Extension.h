//
//  UIViewController+Extension.h
//  ForestPack
//
//  Created by jimmy on 2018/7/5.
//  Copyright © 2018年 郑洲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

///状态栏是否隐藏 全局隐藏，是隐藏 App 在所有 UIViewController 时的状态栏 必须在 Info.plist 文件中添加 View controller-based status bar appearance ，并且必须设置为 NO
- (void)isStstusBarHide:(BOOL)isHidden;
/*
 局部隐藏 在需要隐藏的控制器里写这个方法 而且在Info.plist 文件中添加 View controller-based status bar appearance 设置为 YES 。
 - (BOOL)prefersStatusBarHidden {
 return YES;
 }
 */

///状态栏字体颜色 全部设置 必须在Info.plist 文件中添加 View controller-based status bar appearance 设置为 NO
- (void)setStatusBarTextColor:(UIStatusBarStyle )barStyle;
/*
 局部设置 在Info.plist 文件中添加 View controller-based status bar appearance 设置为 YES
 - (UIStatusBarStyle)preferredStatusBarStyle {
 return UIStatusBarStyleLightContent;
 }
 */

///设置状态栏颜色
- (void)setStatusBarBackGroundColor:(UIColor *)color;

///导航栏是否透明
- (void)isNavigationBarClear:(BOOL)isClear;

///是否隐藏导航栏下面的黑线
- (void)isHideNavigationBarBottomLine:(BOOL)isHidden;

///设置导航栏的背景颜色
- (void)setNavigationBarBackGroundColor:(UIColor *)backGroundColor;

///设置导航栏上控件的颜色
- (void)setNavigationBarTitleColor:(UIColor *)titleColor;

///设置导航栏背景颜色为渐变色
- (void)setNavigationBarBackGroundColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

///设置导航栏左边的按钮 包括按钮是否是图片 字体颜色 字体大小 按钮位置 按钮大小
- (void)setNavigationLeftBarButtonWithImage:(UIImage *)image withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)titleFont withButtonFrame:(CGRect )buttonRect withSelector:(SEL )selector withTarget:(id )target;

///设置导航栏右边的按钮 包括按钮是否是图片 字体颜色 字体大小 按钮位置 按钮大小
- (void)setNavigationRightBarButtonWithImage:(UIImage *)image withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)titleFont withButtonFrame:(CGRect )buttonRect withSelector:(SEL )selector withTarget:(id )target;

@end
