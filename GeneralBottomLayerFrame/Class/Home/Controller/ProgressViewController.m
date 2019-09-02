//
//  ProgressViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/26.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "ProgressViewController.h"
#import "LXStepView.h"
#import "LXProgressStepView.h"

@interface ProgressViewController ()

@property (nonatomic,strong)  LXStepView  * stepView;

@end

@implementation ProgressViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 设置当前步骤，步骤索引=数组索引
    [self.stepView setStepIndex:3 animation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"进度条"];
    [self setProgressViewUI];
}

- (void)setProgressViewUI
{
//    NSArray *arr=@[@"第一天", @"第二天", @"第三天",@"第四天",@"第五天",@"第六天",@"第七天"];
//    LXProgressStepView *stepView=[LXProgressStepView progressViewFrame:CGRectMake(0, 100, self.view.bounds.size.width, 60) withTitleArray:arr];
//    stepView.stepIndex=2;
//    [self.view addSubview:stepView];
    // 初始化
    self.stepView = [[LXStepView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 60) titlesArray:@[@"第一天", @"第二天", @"第三天",@"第四天",@"第五天",@"第六天",@"第七天"] stepIndex:0];
    [self.view addSubview:self.stepView];
}


@end
