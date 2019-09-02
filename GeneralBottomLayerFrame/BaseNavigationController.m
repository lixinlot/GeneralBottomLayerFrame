//
//  BaseNavigationController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)  UIPanGestureRecognizer  * fullScreenPopPanGesture;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.interactivePopGestureRecognizer.delegate =self;
    
    //    1.防止手势冲突
//    self.interactivePopGestureRecognizer.enabled = NO;
    [self addFullScreenPopPanGesture];
}

- (void)addFullScreenPopPanGesture {
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View    
    //  创建pan手势 作用范围是全屏
    self.fullScreenPopPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    self.fullScreenPopPanGesture.delegate = self;
    [self.view addGestureRecognizer:self.fullScreenPopPanGesture];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

//#pragma mark - 实现UIGestureRecognizerDelegate
////决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.fullScreenPopPanGesture]) {
        //获取手指移动后的相对偏移量
        CGPoint translationPoint = [self.fullScreenPopPanGesture translationInView:self.view];
        //向右滑动 && 不是跟视图控制器
        if (translationPoint.x > 0 && self.childViewControllers.count > 1) {
            return YES;
        }
        return NO;
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
//    // 首先判断响应gestureRecognizer的view是不是系统UILayoutContainerView
//    if ([gestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        // 如果otherGestureRecognizer的响应者是UIScrollView，
//        // 再判断otherGestureRecognizer的state是began，
//        // 同时判断scrollView的位置是不是正好在最左边
//        // 满足条件即可实现返回手势
//        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
//            if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan &&
//                scrollView.contentOffset.x == 0) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}

//进入某个页面禁止手势后可以重写系统方法,恢复手势响应
//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    self.interactivePopGestureRecognizer.enabled = YES;
//    return  [super popToRootViewControllerAnimated:animated];
//}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }else{
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
