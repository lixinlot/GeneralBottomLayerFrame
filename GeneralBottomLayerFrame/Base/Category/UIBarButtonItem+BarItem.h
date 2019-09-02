//
//  UIBarButtonItem+BarItem.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BarItem)

//快速的创建一个导航栏左右的按钮
+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)hightImage target:(id)target action:(SEL)action;

+(UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

//快速的创建一个返回按钮
+(UIBarButtonItem *)itemWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage titleColor:(UIColor *)color highTitleCorlor:(UIColor *)highTitleColor target:(id)target action:(SEL)action;

@end
