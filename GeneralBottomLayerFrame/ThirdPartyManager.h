//
//  ThirdPartyManager.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/20.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdPartyManager : NSObject

+ (ThirdPartyManager *)shareThirdPartyManager;

- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)thirdApplicationDidBecomeActive:(UIApplication *)application;
- (void)thirdApplicationWillResignActive:(UIApplication *)application;
- (void)thirdApplicationWillEnterForeground:(UIApplication *)application;
- (void)thirdApplication:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)thirdApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

- (void)thirdApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)thirdApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification withNav:(UINavigationController *)nav;
- (void)thirdApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)thirdApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;


@end

NS_ASSUME_NONNULL_END
