//
//  LXAuthorityManager.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/13.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXAuthorityManager : NSObject

#pragma mark - 请求所有权限
+ (void)requestAllAuthority;

#pragma mark - 是否开启定位权限
+ (BOOL)isObtainLocationAuthority;
+ (void)obtainCLLocationAlwaysAuthorizedStatus; //始终访问位置信息
+ (void)obtainCLLocationWhenInUseAuthorizedStatus; //使用时访问位置信息

#pragma mark - 推送
+ (void)obtainUserNotificationAuthorizedStatus;


#pragma mark - 是否开启媒体资料库权限
+ (BOOL)isObtainMediaAuthority;
+ (void)obtainMPMediaAuthorizedStatus;

#pragma mark - 是否开启语音识别权限
+ (BOOL)isObtainSpeechAuthority;
+ (void)obtainSFSpeechAuthorizedStatus;

#pragma mark - 是否开启日历权限
+ (BOOL)isObtainEKEventAuthority;
//开启日历权限
+ (void)obtainEKEventAuthorizedStatus;

#pragma mark - 是否开启相册权限
+ (BOOL)isObtainPhPhotoAuthority;
//开启相册权限
+ (void)obtainPHPhotoAuthorizedStaus;

#pragma mark - 是否开启相机权限
+ (BOOL)isObtainAVVideoAuthority;
+ (void)obtainAVMediaVideoAuthorizedStatus;

#pragma mark - 是否开启通讯录权限
+ (BOOL)isObtainCNContactAuthority;
+ (void)obtainCNContactAuthorizedStatus;

#pragma mark - 是否开启麦克风权限
+ (BOOL)isObtainAVAudioAuthority;
+ (void)obtainAVMediaAudioAuthorizedStatus;

#pragma mark - 是否开启提醒事项权限
+ (BOOL)isObtainReminder;
+ (void)obtainEKReminderAuthorizedStatus;

#pragma mark - 开启运动与健身权限(需要的运动权限自己再加,目前仅有"步数"、"步行+跑步距离"、"心率")
+ (void)obtainHKHealthAuthorizedStatus;

#pragma mark - 是否开启语音识别事项权限
+ (BOOL)isObtainSpeechRecognizer;
+ (void)obtainSpeechRecognizeAuthorizedStatus;


@end

NS_ASSUME_NONNULL_END
