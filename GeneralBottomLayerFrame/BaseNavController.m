//
//  BaseNavController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/20.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)  UIPanGestureRecognizer  * fullScreenPopPanGesture;

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.interactivePopGestureRecognizer.delegate =self;
    
    //    1.防止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
//    [self addFullScreenPopPanGesture];
}

- (void)addFullScreenPopPanGesture {

    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    //  创建pan手势 作用范围是全屏
    self.fullScreenPopPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    self.fullScreenPopPanGesture.delegate = self;
    [self.view addGestureRecognizer:self.fullScreenPopPanGesture];

//    // 关闭边缘触发手势 防止和原有边缘手势冲突
//    [self.interactivePopGestureRecognizer setEnabled:NO];
}

//#pragma mark - 实现UIGestureRecognizerDelegate
////决定是否触发手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    return self.childViewControllers.count > 1;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
//    if ([gestureRecognizer isEqual:self.fullScreenPopPanGesture]) {
//        //获取手指移动后的相对偏移量
//        CGPoint translationPoint = [self.fullScreenPopPanGesture translationInView:self.view];
//        //向右滑动 && 不是跟视图控制器
//        if (translationPoint.x > 0 && self.childViewControllers.count > 1) {
//            return YES;
//        }
//        return NO;
//    }
//    return YES;
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
