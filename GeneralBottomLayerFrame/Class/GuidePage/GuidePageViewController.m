//
//  GuidePageViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/21.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "GuidePageViewController.h"
#import "BaseTabBarController.h"
#import "UIView+Utils.h"

#define NewfeatureCount 3

@interface GuidePageViewController ()<UIScrollViewDelegate>

///分页，用来展示当前是第几页
@property (nonatomic,strong) UIPageControl *pageControl;
///跳过当前引导的按钮
@property (nonatomic,strong)  UIButton     *skipBt;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupScrollView];
    [self createSkipBt];
}

//创建UIScrollView并添加图片
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:scrollView];
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, 0);
    scrollView.delegate = self;
    
    for (NSInteger i = 0; i < NewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.left = SCREEN_WIDTH * i;
        imageView.top = 0;
        imageView.width = SCREEN_WIDTH;
        imageView.height = SCREEN_HEIGHT;
        NSString *name = [NSString stringWithFormat:@"引导页%ld",i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        if (i == NewfeatureCount - 1) {
            [self setupStartBtn:imageView];
        }
    }
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = RGB_COLOR(159, 159, 159);
    pageControl.centerX = SCREEN_WIDTH * 0.5;
    pageControl.centerY = SCREEN_HEIGHT - 50;
//    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

//左上角的灰色跳过按钮
-(void)createSkipBt
{
    self.skipBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBt.frame = CGRectMake(SCREEN_WIDTH - 90, 40, 80, 30);
    self.skipBt.backgroundColor = FONTCOLOR_LIGHTGRAY;
    [self.skipBt setTitle:@"跳过" forState:UIControlStateNormal];
    [self.skipBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.skipBt.layer.cornerRadius = 10;
    self.skipBt.clipsToBounds = YES;
    self.skipBt.tag = 1000;
    [self.skipBt addTarget:self action:@selector(BtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipBt];
}

//手动拖拽结束时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
    if (self.pageControl.currentPage == 2) {
        self.skipBt.hidden = YES;
    }
    // 1.3四舍五入 1.3 + 0.5 = 1.8 强转为整数(int)1.8= 2
    // 1.5四舍五入 1.5 + 0.5 = 2.0 强转为整数(int)2.0= 2
    // 1.6四舍五入 1.6 + 0.5 = 2.1 强转为整数(int)2.1= 2
    // 0.7四舍五入 0.7 + 0.5 = 1.2 强转为整数(int)1.2= 1
}

//给最后一张图片添加 进入首页按钮
- (void)setupStartBtn:(UIImageView *)imgView
{
    imgView.userInteractionEnabled = YES;
//    [btn setBackgroundImage:[UIImage imageNamed:@"cancel_ask"] forState:UIControlStateNormal];
//    btn.size = btn.currentBackgroundImage.size;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(100, 44);
    btn.centerX = imgView.width * 0.5;
    btn.centerY = imgView.height * 0.85;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22.0;
    btn.backgroundColor = ThemeColor;
    [btn setTitle:@"进入首页" forState:UIControlStateNormal];
    [btn setTitleColor:FONTCOLOR_BLACK forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:btn];
}

//进入首页按钮点击事件
-(void)BtnDidClicked
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[BaseTabBarController alloc] init];
}


@end
