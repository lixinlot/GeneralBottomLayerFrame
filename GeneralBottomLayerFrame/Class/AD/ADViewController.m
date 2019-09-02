//
//  ADViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/22.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "ADViewController.h"
#import "GuidePageViewController.h"
#import "SWRevealViewController.h"

@interface ADViewController ()

@property (nonatomic, strong)  UIView      * adContaintView;
@property (nonatomic,strong)  UIButton     * clipClickBtn;
@property (nonatomic,strong)  UIImageView  * adImageView;
//因为NSTimer是系统管理的 用完不会销毁 所以不需要强引用
@property (nonatomic, weak) NSTimer * timer;
@property (nonatomic,copy)  NSString  * jump_ad_url;

@end

@implementation ADViewController

-(UIImageView *)adImageView
{
    if (_adImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.adContaintView addSubview:imageView];
        _adImageView = imageView;
        _adImageView.userInteractionEnabled = YES;
        //如果想点击广告网页图片就跳转到对应的网页 就给imageView添加一个手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
        imageView.userInteractionEnabled = YES;
    }
    return _adImageView;
}

//跳转到广告界面
-(void)tap
{
    //UIApplication可以打开Safari
    UIApplication *app = [UIApplication sharedApplication];
//    NSURL *url = [NSURL URLWithString:Ad_url];
    
    if (!self.jump_ad_url) {
        return;
    }
    if ([app canOpenURL:[NSURL URLWithString:self.jump_ad_url]]) {
        [app openURL:[NSURL URLWithString:self.jump_ad_url]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewUI];
    [self loadData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

-(void)loadData
{
    WeakObj(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    [HttpManager postHttpRequestByGet:Ad_url andParameter:parameters success:^(id successResponse) {
        NSArray *resultArray = successResponse[@"ad"];
        for (NSDictionary * dict in resultArray) {
            
            [selfWeak.adImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"w_picurl"]]]];
            
            selfWeak.jump_ad_url = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ori_curl"]];
            
        }
    } andFailure:^(id failureResponse) {
        [HttpManager showFail];
    }];
    
    
}

-(void)setClipClick
{
    NSUserDefaults * SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString * isFirstLogin = [SaveDefaults objectForKey:@"isFirstLogin"];
    if (![isFirstLogin isEqualToString:@"0"]) {
        GuidePageViewController *vc = [[GuidePageViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        [SaveDefaults setObject:@"0" forKey:@"isFirstLogin"];
    }else{
        kKeyWindow.rootViewController = [[BaseTabBarController alloc] init];
    }
    //销毁定时器
    [self.timer invalidate];
}

-(void)timeChange
{
    //倒计时
    static int i = 3;
    
    //设置跳转按钮文字
    [self.clipClickBtn setTitle:[NSString stringWithFormat:@"跳转(%d)",i] forState:UIControlStateNormal];
    if (i == 0) {
        
        [self setClipClick];
    }
    i -- ;
}

-(void)setViewUI
{
//    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.userInteractionEnabled = YES;
//    self.adImageView.bounds = self.view.bounds;
    self.adImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.adImageView];
    
    self.clipClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clipClickBtn.frame = CGRectMake(SCREEN_WIDTH - ScreenX375(95), ScreenX375(25), ScreenX375(80), ScreenX375(35));
    [self.clipClickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clipClickBtn setTitle:@"跳转(3)" forState:UIControlStateNormal];
    self.clipClickBtn.backgroundColor = FONTCOLOR_LIGHTGRAY;
    [self.clipClickBtn addTarget:self action:@selector(setClipClick) forControlEvents:UIControlEventTouchUpInside];
    [self.adImageView addSubview:self.clipClickBtn];
    
}


@end
