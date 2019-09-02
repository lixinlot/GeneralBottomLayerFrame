//
//  NewHomeViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/7/17.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "NewHomeViewController.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "LXAuthorityManager.h"
#import "LXFileManager.h"
#import "MGJRouter.h"
#import "CustomModuleRouter.h"
#import "ProgressSliderView.h"
#import "OtherViewController.h"
#import "PopCoverView.h"

@interface NewHomeViewController ()<UIScrollViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>
{
    NSString *fileName1;
    NSString *fileName2;
    NSString *fileName3;
}

@property (nonatomic, strong) UIView           * topView;
@property (nonatomic, strong) UIView           * pickView;
@property (nonatomic, strong) UIView           * centerView;
@property (nonatomic, strong) TYCyclePagerView * pagerView;
@property (nonatomic, strong) TYPageControl    * pageControl;
@property (nonatomic, strong) NSArray          * datas;

@property (nonatomic, strong)  UIScrollView  * scrollView;
@property (nonatomic, strong)  UIScrollView  * scrollView1;
@property (nonatomic, strong)  UIView        * contentView;

@property (nonatomic, strong) CAEmitterLayer * redpacketLayer;

@property (nonatomic, strong) CAEmitterLayer * fireworksLayer;

@end

__weak id refrence = nil;
@implementation NewHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSLog(@"viewWillAppear:%@",refrence);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear:%@",refrence);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSLog(@"viewWillDisappear:%@",refrence);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self addPagerView];
//    [self redpacketRain];
//    [self setupEmitter];
    [self loadData];
    @autoreleasepool {
        refrence = [NSString stringWithFormat:@"jimmy"];
    }
    NSLog(@"viewDidLoad:%@",refrence);
    
    [self transformView];
}

- (void)addAcountDetailInfoViewUI {
    
    self.scrollView1 = [UIScrollView new];
//    self.scrollView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView1.delegate = self;
    [self.view addSubview:self.scrollView1];
    [self.scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.topView = [[UIView alloc] init];
//    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    self.topView.backgroundColor = [UIColor blueColor];
    [self.scrollView1 addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(200));
    }];
    
    UIButton *back = [[UIButton alloc] init];//WithFrame:CGRectMake(20, 30, 80, 20)];
    [back setTitle:@"< 返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.topView addSubview:back];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(80));
        make.top.equalTo(self.view.mas_top).offset(30);
        make.height.equalTo(@(20));
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"12345678";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = 10;
    label1.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(100));
        make.top.equalTo(back.mas_bottom).offset(40);
        make.height.equalTo(@(20));
    }];
}

- (void)addPagerView {
    WeakObj(self);
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view.mas_UIEdgeInsetsMake(0, 0, 0, 0));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView * contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
//        make.height.equalTo(self.scrollView.mas_height);
    }];
    
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    pagerView.layout.itemSpacing = 12;
    pagerView.layout.itemSize = CGSizeMake(SCREEN_WIDTH-40, 155);
    pagerView.layout.layoutType = TYCyclePagerTransformLayoutLinear;
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [contentView addSubview:pagerView];
    _pagerView = pagerView;
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(contentView.mas_top).offset(NAVIGATION_BAR_HEIGHT);
        make.height.equalTo(@(200));
    }];
    
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.currentPageIndicatorSize = CGSizeMake(16, 3);
    pageControl.pageIndicatorSize = CGSizeMake(16, 3);
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.pageIndicatorSpaing = -2;
    [pagerView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfWeak.pagerView.mas_left);
        make.width.equalTo(selfWeak.pagerView.mas_width);
        make.top.equalTo(selfWeak.pagerView.mas_bottom).offset(-46);
        make.height.equalTo(@(26));
    }];
    
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:self.centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(self.pagerView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@(800));
    }];
    
//    UIView *view1 = [[UIView alloc] init];
//    view1.backgroundColor = [UIColor purpleColor];
//    [contentView addSubview:view1];
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.width.equalTo(@(SCREEN_WIDTH));
//        make.top.equalTo(self.centerView.mas_bottom);
//        make.height.equalTo(@(400));
//    }];
//
//    UIView *view2 = [[UIView alloc] init];
//    view2.backgroundColor = [UIColor cyanColor];
//    [contentView addSubview:view2];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.width.equalTo(@(SCREEN_WIDTH));
//        make.top.equalTo(view1.mas_bottom);
//        make.height.equalTo(@(400));
//    }];
}

- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        if (i == 0) {
            [datas addObject:[UIColor redColor]];
            continue;
        }
        [datas addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0]];
    }
    _datas = [datas copy];
    _pageControl.numberOfPages = _datas.count;
    [_pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _datas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    WeakObj(self);
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.backgroundColor = _datas[index];
    cell.acountLabel.text = [NSString stringWithFormat:@"index->%ld",index];
    cell.seeDetailLabel.text = @"点击查看详情";
    cell.seeDetailBlock = ^{
        [selfWeak animateTopView];
    };
    return cell;
}

- (void)animateTopView {
    
    [UIView animateWithDuration:1.0 animations:^{
        CATransition *anima = [CATransition animation];
        anima.type = @"oglFlip";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 1.0f;
        [self.view.layer addAnimation:anima forKey:@"oglFlipAnimation"];

        self.scrollView.hidden = YES;
        [self addAcountDetailInfoViewUI];
    }];
}

- (void)backClick {
    
    [UIView animateWithDuration:1.0 animations:^{
        CATransition *anima = [CATransition animation];
        anima.type = @"oglFlip";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 1.0f;
        [self.view.layer addAnimation:anima forKey:@"oglFlipAnimation"];
        self.scrollView1.hidden = YES;
        self.scrollView.hidden = NO;
    }];
    
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSpacing = 15;
    
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark - action
- (void)pageControlValueChangeAction:(TYPageControl *)sender {
    NSLog(@"pageControlValueChangeAction: %ld",sender.currentPage);
}

#pragma mark - 烟花
- (void)setupEmitter {
    // 配置layer
    CAEmitterLayer * fireworksLayer = [CAEmitterLayer layer];
    [self.centerView.layer addSublayer:fireworksLayer];
    self.fireworksLayer = fireworksLayer;
    
    fireworksLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width * 0.5, NAVIGATION_BAR_HEIGHT+200+400); // 在底部
    fireworksLayer.emitterSize = CGSizeMake(self.view.layer.bounds.size.width * 0.1, 0.f);  // 宽度为一半
    fireworksLayer.emitterMode = kCAEmitterLayerOutline;
    fireworksLayer.emitterShape = kCAEmitterLayerLine;
    fireworksLayer.renderMode = kCAEmitterLayerAdditive;
    
    // 发射
    CAEmitterCell * shootCell = [CAEmitterCell emitterCell];
    shootCell.name = @"shootCell";
    
    shootCell.birthRate = 1.f;
    shootCell.lifetime = 1.02;  // 上一个销毁了下一个再发出来
    
    shootCell.velocity = 600.f;
    shootCell.velocityRange = 100.f;
    shootCell.yAcceleration = 75.f;  // 模拟重力影响
    
    shootCell.emissionRange = M_PI * 0.25; //
    
    shootCell.scale = 0.05;
    shootCell.color = [[UIColor redColor] CGColor];
    shootCell.greenRange = 1.f;
    shootCell.redRange = 1.f;
    shootCell.blueRange = 1.f;
    shootCell.contents = (id)[[UIImage imageNamed:@"shoot_white"] CGImage];
    
    shootCell.spinRange = M_PI;  // 自转360度
    
    // 爆炸
    CAEmitterCell * explodeCell = [CAEmitterCell emitterCell];
    explodeCell.name = @"explodeCell";
    
    explodeCell.birthRate = 1.f;
    explodeCell.lifetime = 0.5f;
    explodeCell.velocity = 0.f;
    explodeCell.scale = 2.5;
    explodeCell.redSpeed = -1.5;  //爆炸的时候变化颜色
    explodeCell.blueRange = 1.5; //爆炸的时候变化颜色
    explodeCell.greenRange = 1.f; //爆炸的时候变化颜色
    
    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";
    
    sparkCell.birthRate = 300.f;
    sparkCell.lifetime = 3.f;
    sparkCell.velocity = 125.f;
    sparkCell.yAcceleration = 75.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度
    
    sparkCell.scale = 1.2f;
    sparkCell.contents = (id)[[UIImage imageNamed:@"star_white_stroke"] CGImage];
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;
    
    sparkCell.spin = M_PI * 2; // 自转
    
    //添加动画
    fireworksLayer.emitterCells = @[shootCell];
    shootCell.emitterCells = @[explodeCell];
    explodeCell.emitterCells = @[sparkCell];
}

/**
 * 红包雨
 */
- (void)redpacketRain {
    
    // 1. 设置CAEmitterLayer
    CAEmitterLayer * redpacketLayer = [CAEmitterLayer layer];
    [self.pagerView.layer addSublayer:redpacketLayer];
    self.redpacketLayer = redpacketLayer;
    
    redpacketLayer.emitterShape = kCAEmitterLayerLine;  // 发射源的形状 是枚举类型
    redpacketLayer.emitterMode = kCAEmitterLayerSurface; // 发射模式 枚举类型
    redpacketLayer.emitterSize = self.view.frame.size; // 发射源的size 决定了发射源的大小
    redpacketLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, 0); // 发射源的位置
    redpacketLayer.birthRate = 0.f; // 每秒产生的粒子数量的系数
    
    // 2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"red_paceket"] CGImage];  // 粒子的内容 是CGImageRef类型的
    snowCell.birthRate = 10.f;  // 每秒产生的粒子数量
    snowCell.lifetime = 20.f;  // 粒子的生命周期
    snowCell.velocity = 10.f;  // 粒子的速度
    snowCell.yAcceleration = 200.f; // 粒子再y方向的加速的
    snowCell.scale = 0.5;  // 粒子的缩放比例
    redpacketLayer.emitterCells = @[snowCell];  // 粒子添加到CAEmitterLayer上
    
    [self performSelector:@selector(end) withObject:nil afterDelay:10];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.redpacketLayer setValue:@1.f forKeyPath:@"birthRate"];
}

- (void)end {
    [self.redpacketLayer setValue:@0.f forKeyPath:@"birthRate"];
    
    
    
    UIImageView *imaV = [[UIImageView alloc] init];
    [imaV sd_setImageWithURL:[NSURL URLWithString:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    NSDictionary *dic = @{@"11":@"11",@"2":@2};
    NSLog(@"dic%@",dic);
}

- (void)transformView {
//    CGAffineTransform *transform;
//    CATransform3D     *transform3D;
    
    CGFloat sapce = (kScreenWidth-60)/4;
    
    UIView *redPointView = [UIView new];
    redPointView.frame = CGRectMake(sapce, sapce+10, 20, 20);
    redPointView.backgroundColor = [UIColor redColor];
    redPointView.layer.masksToBounds = YES;
    redPointView.layer.cornerRadius = 10;
    [self.view addSubview:redPointView];
    UITapGestureRecognizer *red = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowOpenPhoto)];
    [redPointView addGestureRecognizer:red];
    
    UIView *yellowPointView = [UIView new];
    yellowPointView.frame = CGRectMake(sapce*2+20, sapce+10, 20, 20);
    yellowPointView.backgroundColor = [UIColor yellowColor];
    yellowPointView.layer.masksToBounds = YES;
    yellowPointView.layer.cornerRadius = 10;
    [self.view addSubview:yellowPointView];
    UITapGestureRecognizer *yellow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowLocation)];
    [yellowPointView addGestureRecognizer:yellow];
    
    UIView *greenPointView = [UIView new];
    greenPointView.frame = CGRectMake(sapce*3+40, sapce+10, 20, 20);
    greenPointView.backgroundColor = [UIColor greenColor];
    greenPointView.layer.masksToBounds = YES;
    greenPointView.layer.cornerRadius = 10;
    [self.view addSubview:greenPointView];
    UITapGestureRecognizer *green = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowHealth)];
    [greenPointView addGestureRecognizer:green];
    
    UIView *blackPointView = [UIView new];
    blackPointView.frame = CGRectMake(sapce, sapce*3, 20, 20);
    blackPointView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackPointView];
    UITapGestureRecognizer *black = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowSpeechRecognize)];
    [blackPointView addGestureRecognizer:black];
    
//    [UIView animateWithDuration:10.0 animations:^{
//        redPointView.transform = CGAffineTransformTranslate(redPointView.transform, 0, 20);
//        缩放视图。等同于CGAffineTransformScale(self.transform, sx, sy)
//        CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
//        CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
//        缩放视图。等同于CGAffineTransformTranslate(self.transform, tx, ty)
//        CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
//        CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
//        a表示x水平方向的缩放，tx表示x水平方向的偏移
//        d表示y垂直方向的缩放，ty表示y垂直方向的偏移
//        如果b和c不为零的话，那么视图肯定发生了旋转
//        yellowPointView.transform = CGAffineTransformMake(10, 0, 0, 10, 10, 10);
//        greenPointView.transform = CGAffineTransformScale(greenPointView.transform, 2, 2);
//        blackPointView.transform = CGAffineTransformRotate(blackPointView.transform, M_PI_4);
//    }];
    
    
    ProgressSliderView *slider = [[ProgressSliderView alloc] initWithFrame:CGRectMake(20, 250, kScreenWidth-40, 75)];
    slider.score = 5;
    [self.view addSubview:slider];
    
    UIView * pickView = [[UIView alloc] init];
    pickView.backgroundColor = UIColor.redColor;
    pickView.size = CGSizeMake(SCREEN_WIDTH, 240);
//    [self.view addSubview:pickView];
    self.pickView = pickView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickView)];
    [pickView addGestureRecognizer:tap];
}

- (void)allowOpenPhoto {
//    [LXAuthorityManager obtainPHPhotoAuthorizedStaus];
//    [LXAuthorityManager obtainEKEventAuthorizedStatus];
//    [LXAuthorityManager obtainCLLocationAlwaysAuthorizedStatus];
    
//    OtherViewController
//    [self.navigationController pushViewController:[MGJRouter objectForURL:@"LX://Other/getMainVC" withUserInfo:@{@"text" : @"我知道我对你不仅仅是喜欢",}] animated:YES];
    [MGJRouter openURL:@"LX://Other/PushMainVC" withUserInfo:@{@"navigationVC" : self.navigationController} completion:nil];
}

- (void)allowLocation {
//    [LXAuthorityManager obtainCLLocationWhenInUseAuthorizedStatus];
    
//    if (fileName1) {
//        return;
//    }
//    NSString *fileName = [LXFileManager createFileWithName:@"LXX" content:[NSData dataNamed:@"lx"]];
//    fileName1 = fileName;
//    BOOL isExsist = [LXFileManager fileExistsAtPath:fileName];
//    NSLog(@"名为%@的文件存在与否为：%@",fileName,@(isExsist));
    
//    [MGJRouter openURL:@"LX://Test1/PushMainVC" withUserInfo:@{@"navigationVC" : self.navigationController} completion:nil];
//    [GKCover coverFrom:[[UIApplication sharedApplication] keyWindow] contentView:pickView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:true];
    [PopCoverView coverFrom:self.view contentView:self.pickView style:PopCoverStyleTranslucent showStyle:PopCoverShowStyleCenter showAnimStyle:PopCoverShowAnimStyleCenter hideAnimStyle:PopCoverHideAnimStyleCenter notClick:NO];//PopCoverShowAnimStyleCenter   PopCoverShowAnimStyleNone
}

- (void)hidePickView {
    [PopCoverView hideCover];
    
    [MGJRouter openURL:@"LX://Test1/PushMainVC" withUserInfo:@{@"navigationVC" : self.navigationController} completion:nil];
}

- (void)allowHealth {
//    [LXAuthorityManager obtainHKHealthAuthorizedStatus];
//    [LXAuthorityManager obtainMPMediaAuthorizedStatus];
//    [LXAuthorityManager obtainUserNotificationAuthorizedStatus];
    
//    NSArray *fileArray = [LXFileManager getAllFilesAtPath:];
//    NSError *error;
//    BOOL isDelete = [LXFileManager deleteFileWithName:fileName1 error:&error];
//    NSLog(@"是否删除了刚才新创建的文件:%@",@(isDelete));
    [MGJRouter openURL:@"LX://Test2/PushMainVC" withUserInfo:@{@"navigationVC" : self.navigationController, @"text1" : @"蓝蓝的天，白白的云", @"text2" : @"我要删除自己", @"text3" : @"我要更新自己"} completion:nil];
    
}

- (void)allowSpeechRecognize {
//    [LXAuthorityManager obtainSFSpeechAuthorizedStatus];
//    [LXAuthorityManager obtainCNContactAuthorizedStatus];
//    [LXAuthorityManager obtainEKReminderAuthorizedStatus];
    
    
    [MGJRouter openURL:@"LX://Test3/PushMainVC" withUserInfo:@{@"navigationVC" : self.navigationController, @"block" : ^(NSString * text){
        NSLog(@"%@",text);
    },} completion:nil];
    
    
}

@end

/**
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @ "MyBundle"ofType :@ "bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"vc_name"bundle:resourceBundle];
 
    或者
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 50,50)];
    NSString *imgPath= [bundlePath stringByAppendingPathComponent:@"img_collect_success.png"];
    UIImage *image_1=[UIImage imageWithContentsOfFile:imgPath];
    [imgView setImage:image_1];
 
    或者预编译
    #define MYBUNDLE_NAME @ "MyBundle.bundle"
    #define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
    #define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
 
 */
