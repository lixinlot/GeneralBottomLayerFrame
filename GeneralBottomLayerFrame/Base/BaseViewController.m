//
//  BaseViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//
//

#import "BaseViewController.h"
#import "UIViewController+Extension.h"

@interface BaseViewController ()
//{
//    UIButton *_currentButton;
//}

@end

@implementation BaseViewController

//-(UIImage*)convertViewToImage:(UIView*)v
//{
//    CGSize s = v.bounds.size;
//    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需  要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
//    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
//    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:135/255.0 green:219/255.0 blue:214/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:94/255.0 green:189/255.0 blue:205/255.0 alpha:1].CGColor,nil];
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 1);
//    gradientLayer.frame = backView.frame;
//    [backView.layer addSublayer:gradientLayer];
//
//    [self.navigationController.navigationBar setBackgroundImage:[self convertViewToImage:backView] forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"," size:16.0], nil]];
//
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (self != [self.navigationController.viewControllers objectAtIndex:0]) {
//        [self setLeftButton:[UIImage imageNamed:@"返回白色"] title:nil target:self action:@selector(back) rect:CGRectMake(0, 0, 44, 44)];
//        self.tabBarController.tabBar.hidden = YES;
//    }else {
//        self.tabBarController.tabBar.hidden = NO;
//    }
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    for (UIView *field in self.view.subviews) {
//        if ([field isKindOfClass:[UITextField class]] || [field isKindOfClass:[UITextView class]]) {
//            [field resignFirstResponder];
//        }
//    }
//}
//
//#pragma mark - Method
//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (UIImage *)createImageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
//}
//
//- (UIButton *)setRightButton:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)selector{
//    UIButton *currentButton = [self setRightButton:image title:title target:target action:selector rect:CGRectNull];
//    return currentButton;
//}
//
//- (UIButton *)setRightButton:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)selector rect:(CGRect)rect{
//    if (self.navigationController && self.navigationItem) {
//        CGRect buttonFrame;
//        CGRect viewFrame;
//        if (CGRectIsNull(rect)) {
//            buttonFrame = CGRectMake(0, 0, 44, 44);
//            viewFrame = CGRectMake(0, 0, 44, 44);
//        } else {
//            buttonFrame = rect;
//            viewFrame = rect;
//        }
//        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
//        //        button.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
//        if (image) {
//            [button setImage:image forState:UIControlStateNormal];
//        }
//        if (title) {
//            [button setTitle:title forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:14];
//            //Customzied TitleColor..
//            //            [button setTitleColor:RGBACOLOR(232, 41, 28, 1.0) forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        }
//        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
//        [view addSubview:button];
//        _currentButton = button;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
//    }
//    return _currentButton;
//}
//
//- (UIButton *)setLeftButton:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)selector{
//    UIButton *currentButton = [self setLeftButton:image title:title target:target action:selector rect:CGRectNull];
//    return currentButton;
//}
//
//- (UIButton *)setLeftButton:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)selector rect:(CGRect) rect{
//    if (self.navigationItem && self.navigationController) {
//
//        CGRect buttonFrame;
//        CGRect viewFrame;
//        if (CGRectIsNull(rect)) {
//            buttonFrame = CGRectMake(0, 0, 44, 44);
//            viewFrame = CGRectMake(0, 0, 44, 44);
//        } else {
//            buttonFrame = rect;
//            viewFrame = rect;
//        }
//
//        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
//        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
//
//        if (image) {
//            [button setImage:image forState:UIControlStateNormal];
//        }
//        if (title) {
//            [button setTitle:title forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:16];
//            //Customzied TitleColor..
//            [button setTitleColor:RGBACOLOR(30, 30, 30, 1.0) forState:UIControlStateNormal];
//        }
//        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//        [view addSubview:button];
//        _currentButton = button;
//
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
//    }
//    return _currentButton;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    if (self.backImage) {
        return [[UIBarButtonItem alloc] initWithImage:self.backImage style:UIBarButtonItemStylePlain target:target action:action];
    }
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回白色"] style:UIBarButtonItemStylePlain target:target action:action];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self isHideNavigationBarBottomLine:false];
    //    [self setStatusBarBackGroundColor:[UIColor purpleColor]];
    [self setNavigationBarBackGroundColorFromColor:[UIColor colorWithRed:135/255.0 green:219/255.0 blue:214/255.0 alpha:1] toColor:[UIColor colorWithRed:94/255.0 green:189/255.0 blue:205/255.0 alpha:1]];
    [self setNavigationBarTitleColor:UIColorFromRGB(@"#212121", 1)];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

@end
