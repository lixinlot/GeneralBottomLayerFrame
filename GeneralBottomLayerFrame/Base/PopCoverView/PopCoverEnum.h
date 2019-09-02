//
//  PopCoverEnum.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/21.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#ifndef PopCoverEnum_h
#define PopCoverEnum_h

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

//默认动画时间
#define kAnimDuration 0.25
//默认透明度
#define kAlpha 0.5

//遮罩类型
typedef NS_ENUM(NSUInteger, PopCoverStyle) {
    //半透明
    PopCoverStyleTranslucent,
    //全透明
    PopCoverStyleTransparent,
    //高斯模糊
    PopCoverStyleBlur
};

/** 视图显示类型 */
typedef NS_ENUM(NSUInteger, PopCoverShowStyle) {
    /** 显示在上面 */
    PopCoverShowStyleTop,     // 显示在上面
    /** 显示在中间 */
    PopCoverShowStyleCenter,  // 显示在中间
    /** 显示在底部 */
    PopCoverShowStyleBottom,  // 显示在底部
    /** 显示在左侧 */
    PopCoverShowStyleLeft,    // 显示在左侧
    /** 显示在右侧 */
    PopCoverShowStyleRight    // 显示在右侧
};

/** 弹窗显示时的动画类型 */
typedef NS_ENUM(NSUInteger, PopCoverShowAnimStyle) {
    /** 从上弹出 */
    PopCoverShowAnimStyleTop,     // 从上弹出
    /** 中间弹出 */
    PopCoverShowAnimStyleCenter,  // 中间弹出
    /** 底部弹出 */
    PopCoverShowAnimStyleBottom,  // 底部弹出
    /** 左侧弹出 */
    PopCoverShowAnimStyleLeft,    // 左侧弹出
    /** 右侧弹出 */
    PopCoverShowAnimStyleRight,   // 右侧弹出
    /** 无动画 */
    PopCoverShowAnimStyleNone     // 无动画
};

/** 弹窗隐藏时的动画类型 */
typedef NS_ENUM(NSUInteger, PopCoverHideAnimStyle) {
    /** 从上隐藏 */
    PopCoverHideAnimStyleTop,     // 从上隐藏
    /** 中间隐藏（直接消失） */
    PopCoverHideAnimStyleCenter,  // 中间隐藏（直接消失）
    /** 底部隐藏 */
    PopCoverHideAnimStyleBottom,  // 底部隐藏
    /** 左侧隐藏 */
    PopCoverHideAnimStyleLeft,    // 左侧弹出
    /** 右侧隐藏 */
    PopCoverHideAnimStyleRight,   // 右侧弹出
    /** 无动画 */
    PopCoverHideAnimStyleNone     // 无动画
};




#endif /* PopCoverEnum_h */
