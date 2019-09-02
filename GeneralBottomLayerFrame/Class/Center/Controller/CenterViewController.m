//
//  CenterViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//


//自适应高度
//CGSize size = [model.text boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;

#import "CenterViewController.h"
#import "CHCardView.h"
//#import "CHCardItemCustomView.h"
#import "CHCardItemModel.h"
#import "WorksDetailViewController.h"
#import "CardCustomImageView.h"

@interface CenterViewController ()<CHCardViewDelegate, CHCardViewDataSource>

@property (nonatomic, strong) CHCardView      * cardView;

@property (nonatomic, strong) CHCardItemModel * proModel;

@property (nonatomic,assign)  BOOL                isSelect;
@property (nonatomic,strong)  UIView            * bjView;
@property (nonatomic,strong)  UIView            * skidView;
@property (nonatomic,strong)  NSArray           * dataArray;
@property (nonatomic,strong)  UIButton          * button;


@end

@implementation CenterViewController

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initData];
    //    [self setNavigationBarViewUI];
    //    [self setSkidViewUI];
    [self setHeaderViewUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"中心"];
 
}

- (void)initData
{
    self.dataArray = @[@{@"image_url":@"https://r.51gjj.com/image/catalog/51shebao/51loveshebao_icon/ico_zxwy.png",@"url":@"https://b.jianbing.com/app/track/chunyuyisheng_url/#partner"},
                       @{@"image_url":@"http://r.51gjj.com/image/static/new/icon_gjjgl.png",@"url":@"https://b.jianbing.com/business/home/base_service/loan/loanIndex.php"},
                       @{@"image_url":@"http://r.51gjj.com/image/static/new/icon_gd.png",@"url":@"www.baidu.com"},
                       @{@"image_url":@"https://r.51gjj.com/image/catalog/peiyanqing/2018/huluicon.png",@"url":@"https://51.huluhs.com"}
                       ];
}

-(void)setNavigationBarViewUI
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"全部商品灰"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"全部商品"] forState:UIControlStateSelected];
    [self.button addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button sizeToFit];
    UIView *view = [[UIView alloc] initWithFrame:self.button.bounds];
    [view addSubview:self.button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

}

-(void)setSkidViewUI
{
    self.skidView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 90, SCREEN_HEIGHT)];
    self.skidView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.skidView];
}

-(void)moreClick:(UIButton *)button
{
    if (button.selected == !button.selected) {
        self.bjView.hidden = YES;
        [self setSkidViewUI];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            //执行的动画
            self.bjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, SCREEN_HEIGHT)];
            self.bjView.backgroundColor = UIColorFromRGB(@"eeeeee", 0.5);
            [self.view addSubview:self.bjView];
            self.skidView.frame = CGRectMake(90, 0, SCREEN_WIDTH - 90, SCREEN_HEIGHT);
            self.tabBarController.tabBar.hidden = YES;
        }];
    }
}

- (void)setHeaderViewUI
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenX375(49), ScreenX375(43), SCREEN_WIDTH - ScreenX375(98), ScreenX375(400))];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = ScreenX375(8);
    view1.layer.shadowOffset = CGSizeMake(0, 4); //设置阴影的偏移量
    view1.layer.shadowRadius = ScreenX375(8);  //设置阴影的半径
    view1.layer.shadowColor = RGBACOLOR(0, 0, 0, 0.11).CGColor; //设置阴影的颜色为黑色
    view1.layer.shadowOpacity = 1; //设置阴影的不透明度
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenX375(34), ScreenX375(28), SCREEN_WIDTH - ScreenX375(68), ScreenX375(400))];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.cornerRadius = ScreenX375(8);
    view2.layer.shadowOffset = CGSizeMake(0, 4); //设置阴影的偏移量
    view2.layer.shadowRadius = ScreenX375(8);  //设置阴影的半径
    view2.layer.shadowColor = RGBACOLOR(0, 0, 0, 0.11).CGColor; //设置阴影的颜色为黑色
    view2.layer.shadowOpacity = 1; //设置阴影的不透明度
    [self.view addSubview:view2];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenX375(19), ScreenX375(13), SCREEN_WIDTH - ScreenX375(38), ScreenX375(400))];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = ScreenX375(8);
    view.layer.shadowOffset = CGSizeMake(0, 4); //设置阴影的偏移量
    view.layer.shadowRadius = ScreenX375(8);  //设置阴影的半径
    view.layer.shadowColor = RGBACOLOR(0, 0, 0, 0.11).CGColor; //设置阴影的颜色为黑色
    view.layer.shadowOpacity = 1; //设置阴影的不透明度
    [self.view addSubview:view];
    
    self.cardView = [[CHCardView alloc] initWithFrame:CGRectMake(ScreenX375(19), ScreenX375(13), SCREEN_WIDTH - ScreenX375(38), ScreenX375(400))];
    self.cardView.delegate = self;
    self.cardView.dataSource = self;
    [self.view addSubview:self.cardView];
    [self.cardView reloadData];
}

#pragma mark - CHCardViewDelegate
- (NSInteger)numberOfItemViewsInCardView:(CHCardView *)cardView
{
    return self.dataArray.count;
}

- (CHCardItemView *)cardView:(CHCardView *)cardView itemViewAtIndex:(NSInteger)index
{
    CHCardItemModel *model = [CHCardItemModel modelWithDictionary:self.dataArray[index]];
    CardCustomImageView *itemView = [[CardCustomImageView alloc] initWithFrame:cardView.bounds];
    itemView.itemModel = model;
    return itemView;
}

- (void)cardViewNeedMoreData:(CHCardView *)cardView {
    
    [self initData];
    [self.cardView reloadData];
}

- (void)cardView:(CHCardView *)cardView didClickItemAtIndex:(NSInteger)index
{
//    WorksDetailViewController *vc = [[WorksDetailViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
    NSLog(@"点击进入了第%ld个链接",index);
}

@end
