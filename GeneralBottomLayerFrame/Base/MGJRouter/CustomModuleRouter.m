//
//  CustomModuleRouter.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "CustomModuleRouter.h"
#import "MGJRouter.h"
#import "CenterViewController.h"
#import "NewHomeViewController.h"
#import "OtherViewController.h"
#import "MineViewController.h"
#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"

@implementation CustomModuleRouter

/**
 从上文的运行流程分析中已经了解到，main函数是整个应用运行的入口load方法是在main函数之前执行的，并且只执行一次，load方法既然这么特殊，那么在使用他时肯定还是要注意很多东西。
 **不要做耗时操作
 因为执行在main函数之前，所有是所有实现的load函数跑完了才会启动应用，在load方法中进行耗时操作必然会影响程序的启动时间，这么一想load方法里写耗时操作一听就是大忌了。
 **不要做对象的初始化操作
 因为在main函数之前自动调用，load方法调用的时候使用者根本就不能确定自己要使用的对象是否已经加载进来了，所以千万不能在这里初始化对象。
 **常用场景 load方法中实现Method Swizzle
 Method Swizzing是发生在运行时的，主要用于在运行时将两个Method进行交换，我们可以将Method Swizzling代码写到任何地方，但是只有在这段Method Swilzzling代码执行完毕之后互换才起作用。
 
 
 */
+ (void)load {
    
    [MGJRouter registerURLPattern:@"LX://NewHome/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        NewHomeViewController *vc = [[NewHomeViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:@"LX://Center/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        CenterViewController *vc = [[CenterViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:@"LX://Other/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        OtherViewController *vc = [[OtherViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:@"LX://Mine/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        MineViewController *vc = [[MineViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    
    [MGJRouter registerURLPattern:@"LX://Test1/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        TestViewController1 *vc = [[TestViewController1 alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    [MGJRouter registerURLPattern:@"LX://Test2/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        TestViewController2 *vc = [[TestViewController2 alloc] init];
        vc.title1 = routerParameters[MGJRouterParameterUserInfo][@"text1"];
        vc.title2 = routerParameters[MGJRouterParameterUserInfo][@"text2"];
        vc.title3 = routerParameters[MGJRouterParameterUserInfo][@"text3"];
        [navigationVC pushViewController:vc animated:YES];
    }];
    [MGJRouter registerURLPattern:@"LX://Test3/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        TestViewController3 *vc = [[TestViewController3 alloc] init];
        vc.clicked = routerParameters[MGJRouterParameterUserInfo][@"block"];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    
    
}

@end
