//
//  BaseTabBarController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "BaseTabBarController.h"
#import "GetWKWebViewController.h"
#import "GuidePageViewController.h"
#import "HomeNewsController.h"
#import "NewHomeViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

#pragma mark - 设置选中字体颜色的load方法（只会被调用一次）
+(void)load
{
    //获取UITabBarItem
    NSArray *array = @[self];
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:array];
    
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    //    NSMutableDictionary *arrts = [NSMutableDictionary dictionary];
    //    arrts[NSForegroundColorAttributeName] = [UIColor blackColor];
    //    [item setTitleTextAttributes:arrts forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:ThemeColor} forState:UIControlStateSelected];
    
    // 设置字体尺寸:tabBar上 只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString* isFirstLogin = [SaveDefaults objectForKey:@"isFirstLogin"];
//    if (![SaveDefaults objectForKey:@"isFirst"]) {
//        kNSUDefaultSaveVauleAndKey(@"isFirst", @"0");
//    }
    // 2.设置根控制器
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        if (![isFirstLogin isEqualToString:@"0"]) {
            GuidePageViewController *vc = [[GuidePageViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [SaveDefaults setObject:@"0" forKey:@"isFirstLogin"];
        }
    } else { // 这次打开的版本和上一次不一样，显示新特性
        GuidePageViewController *vc = [[GuidePageViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        // 将当前的版本号存进沙盒
        [SaveDefaults setObject:@"0" forKey:@"isFirstLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 1 添加子控制器(5个子控制器)
    [self setTabBarChildVC];
    // 2 设置tabBar上按钮内容
    [self setTabBarContentUI];
    
}

#pragma mark - 设置所有子控制器
-(void)setTabBarChildVC
{
    NSMutableArray *aryControllers = [NSMutableArray array];
    //首页
    BaseNavController *homeNav = [[BaseNavController alloc] initWithRootViewController:[[NewHomeViewController alloc] init]];//HomeNewsController  HomeViewController
    [aryControllers addObject:homeNav];
     //中心
    BaseNavController *centerNav = [[BaseNavController alloc] initWithRootViewController:[[CenterViewController alloc] init]];
    [aryControllers addObject:centerNav];
    
    BaseNavController *otherVC = [[BaseNavController alloc] initWithRootViewController:[[OtherViewController alloc] init]];
    [aryControllers addObject:otherVC];
    
    BaseNavController *mineNav = [[BaseNavController alloc] initWithRootViewController:[[MineViewController alloc] init]];
    [aryControllers addObject:mineNav];
    
    self.viewControllers = aryControllers;
}

-(void)setTabBarContentUI
{
    //首页
    NewHomeViewController*homeVC = self.childViewControllers[0];
//    HomeViewController *homeVC = self.childViewControllers[0];
    homeVC.tabBarItem.title = @"新闻";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"home_unselect"];
    homeVC.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"home_select"];
    
    //天气
    CenterViewController *centerVC = self.childViewControllers[1];
    centerVC.tabBarItem.title = @"天气";
    centerVC.tabBarItem.image = [UIImage imageNamed:@"创意空间2"];
    centerVC.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"创意空间"];
    
    //其他
    OtherViewController *otherVC = self.childViewControllers[2];
    otherVC.tabBarItem.title = @"其他";
    otherVC.tabBarItem.image = [UIImage imageNamed:@"other_unselect"];
    otherVC.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"other_select"];
    
    //我的
    MineViewController *mineVC = self.childViewControllers[3];
    mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.image = [UIImage imageNamed:@"mine_unselect"];
    mineVC.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"mine_select"];
    
}


@end
