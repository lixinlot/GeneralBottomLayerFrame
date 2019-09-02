//
//  HorseVerticalLampView.h
//  RongMei
//
//  Created by jimmy on 2019/5/5.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HorseVerticalLampView;

typedef NS_ENUM(NSInteger, CycleVerticalViewScrollDirection) {
    CycleVerticalViewScrollDirectionUp = 0,
    CycleVerticalViewScrollDirectionDown
};
@protocol CycleVerticalViewDelegate <NSObject>
// 当前点击数据源的第几个item
- (void)cycleVerticalView:(HorseVerticalLampView *)view didClickItemIndex:(NSInteger)index;

@end

@interface HorseVerticalLampView : UIView

@property (nonatomic, strong) NSArray *dataSource;                              // 数据源
@property (nonatomic, weak) id<CycleVerticalViewDelegate> delegate;

/**
 设置DataSource之前调用
 
 @param showTime 展示时间
 @param animationTime 动画时间
 @param direction 方向
 @param backgroundColor 背景颜色
 @param textColor 字体颜色
 @param font 字体
 @param textAlignment 对齐
 */
- (void)configureShowTime:(double)showTime
            animationTime:(double)animationTime
                direction:(CycleVerticalViewScrollDirection)direction
          backgroundColor:(UIColor *)backgroundColor
                textColor:(UIColor *)textColor
                     font:(UIFont *)font
            textAlignment:(NSTextAlignment)textAlignment;

// 开启动画 (主要用于进入其他页面返回时开启)
- (void)startAnimation;

// 关闭动画 (进入其他页面时调用)
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
