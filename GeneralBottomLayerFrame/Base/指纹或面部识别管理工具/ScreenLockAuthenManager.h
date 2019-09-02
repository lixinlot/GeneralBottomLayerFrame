//
//  ScreenLockAuthenManager.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/12.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GjjScreenLockType) {
    GjjScreenLockTypeNone,
    GjjScreenLockTypeGestureSet,//添加手势
    GjjScreenLockTypeGestureUnlock,//屏幕手势解锁
    GjjScreenLockTypeGestureClose,//关闭手势
    GjjScreenLockTypeFingerprintSet,//添加指纹
    GjjScreenLockTypeFingerprintUnlock,//屏幕指纹解锁
    GjjScreenLockTypeFingerprintClose//关闭指纹
};

NS_ASSUME_NONNULL_BEGIN

@interface ScreenLockAuthenManager : NSObject

@property (nonatomic, assign) GjjScreenLockType lockType;
@property (nonatomic, assign) BOOL touchIDSupport;
@property (nonatomic, assign) BOOL existGestureLock;
@property (nonatomic, assign) BOOL existFingerprintLock;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) BOOL faceID;

+ (instancetype)shareInstance;

/**
 *  启动锁屏
 */
+ (void)openScreenLock;

/**
 *  关闭手势密码
 */
+ (void)openCloseGesture;

/**
 *  设置手势密码
 */
+ (void)openSetGesture;

/**
 *  设置指纹密码
 */
+ (void)openSetFingerprint;

/**
 *  验证指纹密码
 */
+ (void)openUnlockFingerprint;

+ (NSString *)gesturePassword;

/**
 *  清除锁屏密码
 */
+ (void)clearScreenLock;

/**
 *  清除指纹密码
 */
+ (void)clearFingerprintLock;

/**
 *  清除手势密码
 */
+ (void)clearGestureLock;

/**
 *  验证、设置等动作完成返回
 */
+ (void)clearScreenLockControllerAndBack;

/**
 *  忘记密码
 */
+ (void)forget;

+ (void)gestureSetSuccess:(NSString *)password;

+ (void)gestureUnlockSuccess;

+ (void)gestureCloseSuccess;

@end

NS_ASSUME_NONNULL_END
