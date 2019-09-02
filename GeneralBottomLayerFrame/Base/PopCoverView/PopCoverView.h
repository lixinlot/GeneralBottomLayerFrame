//
//  PopCoverView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/21.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopCoverEnum.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^showBlock)(void);
typedef void(^hideBlock)(void);

@interface PopCoverView : UIView<CAAnimationDelegate>

+ (instancetype)cover;

#pragma mark - 判断是否已经有cover
+ (BOOL)hasCover;

#pragma mark - 分离弹出和隐藏时的动画
/**
 显示遮罩
 
 @param fromView 显示在此视图上
 @param contentView 显示的内容视图
 @param style 遮罩类型
 @param showStyle 显示方式
 @param showAnimStyle 显示动画类型
 @param hideAnimStyle 隐藏动画类型
 @param notClick 是否不可点击
 */
+ (void)coverFrom:(UIView *)fromView
      contentView:(UIView *)contentView
            style:(PopCoverStyle)style
        showStyle:(PopCoverShowStyle)showStyle
    showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle
    hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle
         notClick:(BOOL)notClick;


/**
 显示遮罩
 
 @param fromView 显示在此视图上
 @param contentView 显示的内容视图
 @param style 遮罩类型
 @param showStyle 显示方式
 @param showAnimStyle 显示动画类型
 @param hideAnimStyle 隐藏动画类型
 @param notClick 是否不可点击
 @param showBlock 显示后的block
 @param hideBlock 隐藏后的block
 */
+ (void)coverFrom:(UIView *)fromView
      contentView:(UIView *)contentView
            style:(PopCoverStyle)style
        showStyle:(PopCoverShowStyle)showStyle
    showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle
    hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle
         notClick:(BOOL)notClick
        showBlock:(showBlock)showBlock
        hideBlock:(hideBlock)hideBlock;


/**
 显示遮罩-隐藏状态栏
 
 @param contentView 显示的内容视图
 @param style 遮罩类型
 @param showStyle 显示方式
 @param showAnimStyle 显示动画类型
 @param hideAnimStyle 隐藏动画类型
 @param notClick 是否不可点击
 @param showBlock 显示后的block
 @param hideBlock 隐藏后的block
 */
+ (void)coverHideStatusBarWithContentView:(UIView *)contentView
                                    style:(PopCoverStyle)style
                                showStyle:(PopCoverShowStyle)showStyle
                            showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle
                            hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle
                                 notClick:(BOOL)notClick
                                showBlock:(showBlock)showBlock
                                hideBlock:(hideBlock)hideBlock;

#pragma mark - 隐藏视图
+ (void)hideCover;

#pragma mark -  重新布局
+ (void)layoutSubViews;

#pragma mark - 2.5.2
// 调用此方法,主方法中的hideBlock将不再起作用
+ (void)hideCoverWithHideBlock:(hideBlock)hideBlock;

+ (void)changeCoverBgColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
