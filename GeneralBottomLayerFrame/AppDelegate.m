//
//  AppDelegate.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "AppDelegate.h"
#import "XHLaunchAd.h"
#import "ThirdPartyManager.h"
#import "LXAuthorityManager.h"
#import "GetWKWebViewController.h"
#import "GuidePageViewController.h"
#import "GuidePageViewController.h"

@interface AppDelegate ()<XHLaunchAdDelegate>

///正常程序退出之后，会在几秒内停止工作，要想申请更长的时间，需要用到beginBackgroundTaskWithExpirationHandler和endBackgroundTask这两个需要成对出现。
///为此c需要再添加一个属性
@property (nonatomic,assign)  UIBackgroundTaskIdentifier  tasks;
@property (nonatomic,strong)  NSTimer  * timer;

@end

@implementation AppDelegate

static NSInteger taskTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//#if DEBUG
//    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
//    // [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle"] load];
//    // [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle"] load];
//#endif
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    if (![userDef objectForKey:@"isFirst"]) {
        kNSUDefaultSaveVauleAndKey(@"isFirst", @"0");
    }
    
//    ADViewController *adVC = [[ADViewController alloc] init];
//    self.window.rootViewController = adVC;
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    
    //配置广告数据
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration defaultConfiguration];
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    //注意:视频广告只支持先缓存,下次显示(看效果请二次运行)
    videoAdconfiguration.videoNameOrURLString = @"https://rongmei.oss-cn-hangzhou.aliyuncs.com/rongmei/1545300285622_979*551.jpg";//@"https://rongmei.oss-cn-hangzhou.aliyuncs.com/rongmei/1545300299405.mp4";
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    videoAdconfiguration.openModel = @"https://rongmei.oss-cn-hangzhou.aliyuncs.com/rongmei/1545300285622_979*551.jpg";
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    //是否关闭音频
    videoAdconfiguration.muted = NO;
    //视频填充模式
    videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //是否只循环播放一次
    videoAdconfiguration.videoCycleOnce = YES;
    //广告显示完成动画
    videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //广告显示完成动画时间
    videoAdconfiguration.showFinishAnimateTime = 0.8;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = SkipTypeRoundProgressTime;
    
    self.window.rootViewController = [[BaseTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [[ThirdPartyManager shareThirdPartyManager] thirdApplication:application didFinishLaunchingWithOptions:launchOptions];
        
    return YES;
}

/**
 *  广告显示完成
 */
-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd
{
    NSLog(@"广告显示完成");
    GuidePageViewController *vc = [[GuidePageViewController alloc] init];
    [self.window.rootViewController.navigationController pushViewController:vc animated:true];
}

/**
 广告点击事件代理方法
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    NSLog(@"广告点击事件");
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    
    if(openModel==nil) return;
    
    NSString *urlString = (NSString *)openModel;
    
    //此处跳转页面
    GetWKWebViewController *VC = [[GetWKWebViewController alloc] init];
    VC.urlStr = urlString;
    ////此处不要直接取keyWindow
    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootVC.navigationController pushViewController:VC animated:YES];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //第一步是增加UIBackgroundTaskIdentifier第二步是在applicationDidEnterBackground里写下列代码
    [self beginTask];
    
    taskTime = 0;
    //在非主线程开启一个操作在更长时间内执行； 执行的动作
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTimer:) userInfo:nil repeats:NO];
    
    [[ThirdPartyManager shareThirdPartyManager] applicationDidEnterBackground:application];
}

- (void)beginTimer:(NSTimer *)timer {
    NSLog(@"%@==%ld ",[NSDate date],(long)taskTime);
    taskTime++;
    if (taskTime == 9) {
        [_timer invalidate];
        [self endTask];//// 任务执行完毕，主动调用该方法结束任务
    }
}

- (void)beginTask {
    NSLog(@"begin=============");
    UIApplication *app = [UIApplication sharedApplication];
    _tasks = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"begin  bgend=============");
        [self endTask];// 如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是10分钟
    }];
}

- (void)endTask {
    //关闭后台执行的代码
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:_tasks];
    _tasks = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[ThirdPartyManager shareThirdPartyManager] thirdApplicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //    int64_t delayInSeconds = 10.0; // 延迟的时间
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self cancelNotifacation];
    //    });
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    if () {
//        <#statements#>
//    }
    return YES;
    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [[TaxThirdPartyManager sharedInstance] thirdPartyApplicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    [[ThirdPartyManager shareThirdPartyManager] thirdApplication:application didReceiveLocalNotification:notification withNav:nav];
}

@end
