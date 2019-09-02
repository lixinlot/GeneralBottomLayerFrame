//
//  UIBarButtonItem+BarItem.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "UIBarButtonItem+BarItem.h"

@implementation UIBarButtonItem (BarItem)

+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)hightImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIView *view = [[UIView alloc] initWithFrame:button.bounds];
    [view addSubview:button];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return barItem;
}

+(UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+(UIBarButtonItem *)itemWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage titleColor:(UIColor *)color highTitleCorlor:(UIColor *)highTitleColor target:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:color forState:UIControlStateNormal];
    [backButton setTitleColor:highTitleColor forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

@end
