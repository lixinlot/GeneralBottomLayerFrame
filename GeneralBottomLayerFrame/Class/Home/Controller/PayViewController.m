//
//  PayViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/21.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "PayViewController.h"
#import "PayMethodView.h"

@interface PayViewController ()

@property (nonatomic,strong)  PayMethodView  * payView;

@end

@implementation PayViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hidesBottomBarWhenPushed];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewUI];
    [self setPayMethodViewUI];

}

-(void)setViewUI
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(ScreenX375(15), ScreenX375(220), SCREEN_WIDTH - ScreenX375(30), ScreenX375(44));
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 22.0;
    button.backgroundColor = ThemeColor;
    [button setTitle:@"支付" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

-(void)setPayMethodViewUI
{
    self.payView = [PayMethodView payMethodViewWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.payView.selectPayMethodBlock = ^(NSInteger methodIndexPath) {
        NSLog(@"选择的是%ld",(long)methodIndexPath);
        
        
    };
    [self.view addSubview:self.payView];
}

-(void)payClick
{
    WeakObj(self);
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.payView.backBlock = ^{
            selfWeak.payView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        };
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
