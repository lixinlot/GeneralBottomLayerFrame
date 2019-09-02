//
//  UIViewController+Extension.m
//  General
//
//  Created by jimmy on 2018/12/4.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "UIImage+GradientColor.h"

@implementation UIViewController (Extension)

#pragma mark - 状态栏是否隐藏 全局隐藏，是隐藏 App 在所有 UIViewController 时的状态栏 必须在 Info.plist 文件中添加 View controller-based status bar appearance ，并且必须设置为 NO
- (void)isStstusBarHide:(BOOL)isHidden
{
    if (isHidden) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

/*
 局部隐藏 在需要隐藏的控制器里写这个方法 而且在Info.plist 文件中添加 View controller-based status bar appearance 设置为 YES 。
 - (BOOL)prefersStatusBarHidden
 {
 return YES;
 }
 */

#pragma mark - 状态栏字体颜色 全部设置 必须在Info.plist 文件中添加 View controller-based status bar appearance 设置为 NO
- (void)setStatusBarTextColor:(UIStatusBarStyle )barStyle
{
    [UIApplication sharedApplication].statusBarStyle = barStyle;//UIStatusBarStyleLightContent
}
/*
 局部设置 在Info.plist 文件中添加 View controller-based status bar appearance 设置为 YES
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
 return UIStatusBarStyleLightContent;
 }
 */

#pragma mark - 设置状态栏颜色
- (void)setStatusBarBackGroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 导航栏是否透明
- (void)isNavigationBarClear:(BOOL)isClear
{
    if (isClear) {//如果是YES
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }else{//如果是NO
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}

#define iOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)
#pragma mark - 是否隐藏导航栏下面的黑线
- (void)isHideNavigationBarBottomLine:(BOOL)isHidden
{
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (iOS10) {
            //iOS10,改变了导航栏的私有接口为_UIBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                [view.subviews firstObject].hidden = isHidden;
            }
        }else{
            //iOS10之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view.subviews firstObject].hidden = isHidden;
            }
        }
    }];
    
    //再定义一个imageview来等同于这个黑线
    //    UIImageView *navBarHairlineImageView;
    //    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //    navBarHairlineImageView.hidden = isHidden;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 设置导航栏的背景颜色
- (void)setNavigationBarBackGroundColor:(UIColor *)backGroundColor
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage initWithColor:backGroundColor] forBarMetrics:UIBarMetricsDefault];
}

#define Mfont(f)   [UIFont fontWithName:@"PingFangSC-Medium" size:ScreenX375(f)]
#pragma mark - 设置导航栏上控件的颜色
- (void)setNavigationBarTitleColor:(UIColor *)titleColor
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : Mfont(17), NSForegroundColorAttributeName : titleColor};
    self.navigationController.navigationBar.tintColor = titleColor;
}

#pragma mark - 设置导航栏背景颜色为渐变色
- (void)setNavigationBarBackGroundColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientColorImageFromColors:@[fromColor, toColor] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 设置导航栏左边的按钮 包括按钮是否是图片 字体颜色 字体大小 按钮位置 按钮大小
- (void)setNavigationLeftBarButtonWithImage:(UIImage *)image withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)titleFont withButtonFrame:(CGRect )buttonRect withSelector:(SEL )selector withTarget:(id )target
{
    if (self.navigationItem && self.navigationController) {
        CGRect buttonFrame;
        CGRect viewFrame;
        if (CGRectIsNull(buttonRect)) {
            buttonFrame = CGRectMake(0, 0, 44, 44);
            viewFrame = CGRectMake(0, 0, 44, 44);
        } else {
            buttonFrame = buttonRect;
            viewFrame = buttonRect;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
        
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:RGBACOLOR(30, 30, 30, 1.0) forState:UIControlStateNormal];
        
        if (image) {
            [button setImage:image forState:UIControlStateNormal];
        }
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (titleColor) {
            [button setTitleColor:titleColor forState:UIControlStateNormal];
        }
        if (titleFont) {
            button.titleLabel.font = titleFont;
        }
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        [view addSubview:button];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

#pragma mark - 设置导航栏右边的按钮 包括按钮是否是图片 字体颜色 字体大小 按钮位置 按钮大小
- (void)setNavigationRightBarButtonWithImage:(UIImage *)image withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)titleFont withButtonFrame:(CGRect )buttonRect withSelector:(SEL )selector withTarget:(id )target
{
    if (self.navigationController && self.navigationItem) {
        CGRect buttonFrame;
        CGRect viewFrame;
        if (CGRectIsNull(buttonRect)) {
            buttonFrame = CGRectMake(0, 0, 74, 44);
            viewFrame = CGRectMake(0, 0, 74, 44);
        } else {
            buttonFrame = buttonRect;
            viewFrame = buttonRect;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [button setTitleColor:RGBACOLOR(232, 41, 28, 1.0) forState:UIControlStateNormal];
        
        if (image) {
            [button setImage:image forState:UIControlStateNormal];
        }
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (titleColor) {
            [button setTitleColor:titleColor forState:UIControlStateNormal];
        }
        if (titleFont) {
            button.titleLabel.font = titleFont;
        }
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
        [view addSubview:button];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

@end
