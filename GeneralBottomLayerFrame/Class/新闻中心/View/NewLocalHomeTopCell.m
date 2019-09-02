//
//  NewLocalHomeTopCell.m
//  RongMei
//
//  Created by jimmy on 2019/5/10.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "NewLocalHomeTopCell.h"
#import "QMUIButton.h"
//#import "NLGroupListModel.h"
#import <SDCycleScrollView.h>
#import "HorseVerticalLampView.h"

@interface NewLocalHomeTopCell()<SDCycleScrollViewDelegate,UIScrollViewDelegate,CycleVerticalViewDelegate>

@property (nonatomic,strong)  UINavigationController  *selfNav;
@property (nonatomic,strong)  SDCycleScrollView       *cycleBannerView;
@property (nonatomic,strong)  UILabel                 *noticeLabel;
@property (nonatomic,strong)  HorseVerticalLampView  * horseLampView;
@property (nonatomic,strong)  QMUIButton  * seeAllBtn;

@end


@implementation NewLocalHomeTopCell

- (instancetype)initWithFrame:(CGRect)frame withCurrentNav:(UINavigationController *)currentNav
{
    if ([super initWithFrame:frame]) {
        self.selfNav = currentNav;
        self.backgroundColor = UIColorFromRGB(@"#ffffff", 1);
        [self setupViews];
        [self setNewBottomViewUI];
    }
    return self;
}

- (void)setupViews
{
    self.cycleBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(ScreenX375(16), ScreenX375(10), SCREEN_WIDTH-ScreenX375(32), ScreenX375(120)) delegate:self placeholderImage:[UIImage imageNamed:@"兑换券背景"]];
    self.cycleBannerView.localizationImageNamesGroup = @[@"13",@"14",@"16"];
    self.cycleBannerView.autoScrollTimeInterval = 3.0;
    self.cycleBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleBannerView.pageDotColor = [UIColor whiteColor];
    self.cycleBannerView.currentPageDotColor = [UIColor redColor];
    self.cycleBannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleBannerView.layer.cornerRadius = ScreenX375(4);
    [self addSubview:self.cycleBannerView];    
}

#pragma mark ---按钮界面
-(void)setNewBottomViewUI
{
    self.noticeLabel = [[UILabel alloc] init];
    self.noticeLabel.frame = CGRectMake(ScreenX375(16), self.cycleBannerView.bottom+ScreenX375(12), ScreenX375(34), ScreenX375(18));
    self.noticeLabel.text = @"公告";
    self.noticeLabel.font = Rfont(13);
    self.noticeLabel.layer.masksToBounds = YES;
    self.noticeLabel.layer.cornerRadius = ScreenX375(2);
    self.noticeLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeLabel.textColor = [UIColor whiteColor];
    self.noticeLabel.backgroundColor = UIColorFromRGB(@"#E32316", 1);
    [self addSubview:self.noticeLabel];
    
    self.horseLampView = [[HorseVerticalLampView alloc] initWithFrame:CGRectMake(ScreenX375(56), ScreenX375(130), SCREEN_WIDTH-ScreenX375(80)-ScreenX375(60), ScreenX375(42))];
    self.horseLampView.delegate = self;
    [self.horseLampView configureShowTime:1.5 animationTime:0.9 direction:CycleVerticalViewScrollDirectionUp backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(@"212121", 1) font:Rfont(13) textAlignment:NSTextAlignmentLeft];
    self.horseLampView.dataSource = @[@"我是第1条",@"我是第2条",@"我是第3条",@"我是第4条"];
    [self addSubview:self.horseLampView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenX375(180)-10, SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(@"#F5F6F9", 1);
    [self addSubview:view];
}

#pragma mark - 实现轮播图的代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.didSelectCycleScrollViewBlock) {
        self.didSelectCycleScrollViewBlock(index);
    }
}

///设置轮播图图片
- (void)setCycleBannerViewBackImage:(NSArray *)imageArray
{
    self.cycleBannerView.imageURLStringsGroup = imageArray;
    if (imageArray.count == 1) {
        //self.cycleBannerView.autoScrollTimeInterval = 0.0;
        self.cycleBannerView.autoScroll = NO;
    }else {
        self.cycleBannerView.autoScroll = YES;
    }
}

//#pragma mark - 点击查看所有通知列表
//- (void)seeAllClick
//{
//    NLNoticeListController *vc = [[NLNoticeListController alloc] init];
//    [_selfNav pushViewController:vc animated:YES];
//}

#pragma mark - 设置跑马灯的数据
- (void)setVerticalLampDataSourceWith:(NSArray *)array
{
    self.horseLampView.dataSource = array;
}

@end
