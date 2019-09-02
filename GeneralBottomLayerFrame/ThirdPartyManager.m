//
//  ThirdPartyManager.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/20.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "ThirdPartyManager.h"
#import "LXAuthorityManager.h"
#import "MGJRouter.h"
#import <UserNotifications/UserNotifications.h>

@implementation ThirdPartyManager

+ (ThirdPartyManager *)shareThirdPartyManager {
    static ThirdPartyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThirdPartyManager alloc] init];
    });
    return manager;
}

- (void)thirdApplication:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    
    [self registerNotifacationWith:application withOptions:launchOptions];
    
}

- (void)registerNotifacationWith:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    
    if (13.0 > [[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // iOS8
        // categories 可以设置不同类别的推送，在收到推送的代理方法中根据categories的identifier进行不同的推送处理
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    // 如果用户对程序进行滑飞操作，程序进程被杀死后，重新启动APP，推送的代理方法是不走的，这个时候就可以添加下面的代码，获取到推送，进行对应的操作。
    NSDictionary *userInfoLocal = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (userInfoLocal) {
        // 这里添加处理代码
        NSLog(@"=== Local:%@", userInfoLocal);
    }
}

- (void)thirdApplicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)thirdApplicationWillResignActive:(UIApplication *)application {
    
}

- (void)thirdApplicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    [self cancelNotifacation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [LXAuthorityManager obtainUserNotificationAuthorizedStatus];
//    [self setLocalNotifacation];
}


- (void)setLocalNotifacation {
    // 在需要添加本地通知的地方进行添加处理
    // 1.创建一个本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    // 1.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];//获取距离当前时间若干秒之后的时间(东八时区)
    //设置重复间隔
    localNote.repeatInterval = NSCalendarUnitMinute;
    // 1.2.设置通知内容
    localNote.alertBody = @"这是一个推送这是一个推送";
    // 1.3.设置锁屏时,字体下方显示的一个文字
    localNote.alertAction = @"赶紧!!!!!";
    // 1.4.设置启动图片(通过通知打开的)
    //    localNote.alertLaunchImage = @"144";
    // 1.5.设置通过到来的声音
    localNote.soundName = UILocalNotificationDefaultSoundName;
    // 1.6.设置应用图标左上角显示的数字
    localNote.applicationIconBadgeNumber = 999;
    // 1.7.设置一些额外的信息
    localNote.userInfo = @{@"qq" : @"1234567", @"msg" : @"success"};
    //  2 设置好本地推送后必须调用此方法启动此推送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)cancelNotifacation {
    // 1、取消某一个通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"qq"] isEqualToString:@"1234567"]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            break;
        }
    }
    
    // 2、取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)thirdApplicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //    int64_t delayInSeconds = 10.0; // 延迟的时间
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self cancelNotifacation];
    //    });
}

- (BOOL)thirdApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    return YES;
}

- (void)thirdApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)thirdApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification withNav:(UINavigationController *)nav {
    
    //收到本地推送
//    NSDate *fireDate = notification.fireDate;
//    NSDate *nowDate = [NSDate date];
//    if ([fireDate earlierDate:nowDate]) {
//        return;
//    }
    //app处于前台不处理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    if ([[notification.userInfo objectForKey:@"qq"] isEqualToString:@"1234567"]) {
        [MGJRouter openURL:@"LX://Test3/PushMainVC" withUserInfo:@{@"navigationVC" : nav} completion:nil];
    }
}

- (void)thirdApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)thirdApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受, 不处理消息，让用户自己点击消息查看
            //必须加这句代码
            
        }else{
            //应用处于前台时的本地推送接受
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        
    }else{
        //应用处于后台时的本地推送接受
        
    }
    completionHandler();
}


@end
