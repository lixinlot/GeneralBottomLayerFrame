//
//  NewsHeaderView.m
//  RongMei
//
//  Created by jimmy on 2019/4/10.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "NewsHeaderView.h"
#import "QMUIButton.h"

@interface NewsHeaderView ()

@property (nonatomic,strong)  UINavigationController  *selfNav;


@end

@implementation NewsHeaderView

-(instancetype)initWithFrame:(CGRect)frame withNavController:(UINavigationController *)navController{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(@"#ffffff", 1);
        self.selfNav=navController;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    NSArray *imageArray=@[@"找记者",@"土窝知道",@"直播直播"];//@"融媒中心活动",@"融媒中心活动",
    NSArray *titleArray=@[@"找记者",@" 转播",@" 直播"];//@"视频",@"活动",
    CGFloat buttonWid = (SCREEN_WIDTH)/imageArray.count;//-ScreenX375(30)*4
    for (int j = 0; j < imageArray.count; j++) {
        QMUIButton *btn=[[QMUIButton alloc] initWithFrame:CGRectMake(j*buttonWid, 20, buttonWid, 88)];
        [btn setImage:[UIImage imageNamed:imageArray[j]] forState:UIControlStateNormal];
        btn.titleLabel.font = Rfont(14);
        [btn setTitleColor:UIColorFromRGB(@"#333333", 1) forState:UIControlStateNormal];
        btn.tag=100+j;
        [btn addTarget:self action:@selector(typeTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titleArray[j] forState:UIControlStateNormal];
        btn.imagePosition = QMUIButtonImagePositionTop;//QMUIButtonImagePositionLeft;
        btn.spacingBetweenImageAndTitle = 6;
        [self addSubview:btn];
    }
    
//    UIView *line = [[UIView alloc] init];
//    line.frame = CGRectMake((SCREEN_WIDTH-1)/2, 29, 1, 30);
//    line.backgroundColor = UIColorFromRGB(@"#D8D8D8", 1);
//    [self addSubview:line];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, 108, SCREEN_WIDTH, 5);
    bottomView.backgroundColor = UIColorFromRGB(@"#F5F6F9", 1);
    [self addSubview:bottomView];
}

@end
