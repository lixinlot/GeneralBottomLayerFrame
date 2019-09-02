//
//  LXStepView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/26.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXStepView : UIView

// 指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray stepIndex:(NSUInteger)stepIndex;

// 设置当前步骤
- (void)setStepIndex:(NSUInteger)stepIndex animation:(BOOL)animation;


@end

NS_ASSUME_NONNULL_END
