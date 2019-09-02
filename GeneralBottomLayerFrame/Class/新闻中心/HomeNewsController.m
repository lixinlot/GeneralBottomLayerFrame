//
//  HomeNewsController.m
//  RongMei
//
//  Created by jimmy on 2019/4/2.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "HomeNewsController.h"
#import "HomeNewsTableViewCell.h"
#import "HomeNewsDetailViewController.h"
#import "HomeNewsListModel.h"
#import <UIScrollView+Empty.h>
#import "HomeVideoLittleCell.h"
#import "NewLocalHomeTopCell.h"

#define cateTitle_height     48
#define Header_Height        ScreenX375(180)+10
#define cateTitle_default_y  ScreenX375(180)+10
#define tableViewHeight      SCREEN_WIDTH-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-ScreenX375(180)-10-48

@interface HomeNewsController ()<JXCategoryViewDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    
    
    
}

@property (nonatomic,assign)  NSInteger   currentIndex;

@property (nonatomic,strong)  JXCategoryTitleView  * categoryTitleView;
///标签名数组
@property (nonatomic, strong) NSMutableArray<UITableView *> * tableViewAry;

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic,strong)  NSMutableArray  * dataArray;
///标签ID数组
@property (nonatomic,strong)  NSArray  * labelNameArray;

@property (nonatomic,assign)  NSInteger   current_page;
@property (nonatomic,assign)  NSInteger   all_page;


@property (nonatomic,strong)  NewLocalHomeTopCell  * headerView;

@property (nonatomic,strong)  UIView  * roundView;

@property (nonatomic,strong)  UIButton  * button;

@property (nonatomic,strong)  UIView  * roundView2;

@property (nonatomic,strong)  NSMutableArray  * btnArr;
@property (nonatomic,strong)  NSMutableDictionary  * btnDic;



@end

@implementation HomeNewsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.categoryTitleView reloadData];
}

- (NewLocalHomeTopCell *)headerView
{
    if (!_headerView) {
        _headerView = [[NewLocalHomeTopCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(180)
                                                                            +10) withCurrentNav:self.navigationController];
    }
    return _headerView;
}

- (NSMutableArray *)tableViewAry
{
    if (_tableViewAry == nil) {
        _tableViewAry = [NSMutableArray array];
    }
    return _tableViewAry;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenX375(180)+10+48, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-ScreenX375(180)-TAB_BAR_HEIGHT)];
        _scrollView.pagingEnabled = true;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (JXCategoryTitleView *)categoryTitleView
{
    if (_categoryTitleView == nil) {
        _categoryTitleView = [[JXCategoryTitleView alloc] init];
        _categoryTitleView.frame = CGRectMake(0, ScreenX375(180)+10, SCREEN_WIDTH, 48);
        _categoryTitleView.delegate = self;
        _categoryTitleView.defaultSelectedIndex = 0;
        _categoryTitleView.backgroundColor = UIColorFromRGB(@"ffffff", 1);
        _categoryTitleView.titleColor = UIColorFromRGB(@"#212121", 0.60);
        _categoryTitleView.titleSelectedColor = UIColorFromRGB(@"#333333", 1);
        _categoryTitleView.titleFont = Mfont(17);
        _categoryTitleView.titleColorGradientEnabled = YES;
        _categoryTitleView.titleLabelZoomEnabled = YES;
        _categoryTitleView.titleLabelZoomScale = 1.05;
        
        JXCategoryIndicatorLineView * lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_JD;
        lineView.verticalMargin = 5;
        lineView.indicatorLineViewColor = UIColorFromRGB(@"#F6842F", 1);
        _categoryTitleView.indicators = @[lineView];
    }
    return _categoryTitleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"新闻中心"];
    [self initData];
    [self setViewUI];
//    [self setCategoryTitleWithData];
}

#pragma mark - 初始化数据
- (void)initData
{
    self.current_page = 1;
    self.all_page = 1;
    self.dataArray = [NSMutableArray array];
    
    self.btnArr = [NSMutableArray array];
    self.btnDic = [NSMutableDictionary dictionary];
}

#pragma mark - 设置tableView
- (void)getTableViewWith:(CGRect)frame tag:(int)tag
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.delaysContentTouches = NO;
    tableView.canCancelContentTouches = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    tableView.tag = tag;
    [self.tableViewAry addObject:tableView];
    
    WeakObj(self);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsListData:self.labelNameArray[selfWeak.currentIndex]];
    }];
    [tableView.mj_header beginRefreshing];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNewsListData:self.labelNameArray[selfWeak.currentIndex]];
    }];
    [self.scrollView addSubview:tableView];
}

- (void)setViewUI
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//    [self.view addSubview:self.headerView];
//    [self.view addSubview:self.categoryTitleView];
//    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    [self.scrollView setContentSize:CGSizeMake(0, 0)];
    
    UIView *roundView = [[UIView alloc] init];
    roundView.frame = CGRectMake(100, 100, 100, 100);
    roundView.layer.cornerRadius = 50;
    roundView.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:roundView];
    [roundView setUserInteractionEnabled:YES];
    [roundView setMultipleTouchEnabled:YES];
    self.roundView = roundView;
    
    UITapGestureRecognizer *tapRound = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundClick)];
    [roundView addGestureRecognizer:tapRound];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100,250, 100,50)];
    button.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:button];
    [button addTarget:self action:@selector(tanHuang) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.roundView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)tanHuang {
    [UIView animateWithDuration:1 delay:0.5 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.button.origin.y == 400) {
            self.button.frame = CGRectMake(100,250, 100,50);
        }else {
            self.button.frame = CGRectMake(100,400, 100,50);
        }
    } completion:^(BOOL finished) {
        
    }];
}


- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

#pragma mark - 圆球扩大后再缩小
- (void)roundClick {
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 1.2; // 动画持续时间
    animation.repeatCount = 10000000000; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.4]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.roundView.layer addAnimation:animation forKey:@"scale-layer"];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    NSMutableArray *values = [[NSMutableArray alloc]initWithCapacity:3];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    animation.duration = 0.5;
//    animation.removedOnCompletion = YES;
//    [self.roundView.layer addAnimation:animation forKey:nil];
}





#pragma mark - 加载数据
- (void)getNewsListData:(NSString *)labelName
{
    NSString *urlStr;
    NSString *key = @"2bb1695112739a264caa2b4db3f66a0a";
    //头条，社会，国内，娱乐，体育，军事，科技，财经，时尚
    if ([labelName isEqualToString: @"头条"]) {
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"top",key];
    }else if ([labelName isEqualToString: @"社会"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"shehui",key];
    }else if ([labelName isEqualToString: @"国内"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"guonei",key];
    }else if ([labelName isEqualToString: @"国际"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"guoji",key];
    }else if ([labelName isEqualToString: @"娱乐"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"yule",key];
    }else if ([labelName isEqualToString: @"体育"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"tiyu",key];
    }else if ([labelName isEqualToString: @"军事"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"junshi",key];
    }else if ([labelName isEqualToString: @"科技"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"keji",key];
    }else if ([labelName isEqualToString: @"财经"]){
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"caijing",key];
    }else{
        urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=%@",@"shishang",key];
    }
    [self.tableViewAry[self.currentIndex].mj_footer resetNoMoreData];
    WeakObj(self);
    [HttpManager postHttpRequestByGet:urlStr andParameter:@{} success:^(id successResponse) {
        NSString *status = successResponse[@"reason"];
        if ([status isEqualToString:@"成功的返回"]) {
            NSArray * dataAry = successResponse[@"result"][@"data"];
            if (selfWeak.current_page == 1) {
                [selfWeak.dataArray removeAllObjects];
            }else {
                [self.tableViewAry[selfWeak.currentIndex].mj_footer endRefreshingWithNoMoreData];
                return;
            }
            for (NSDictionary *dic in dataAry) {
                HomeNewsListModel *model = [HomeNewsListModel modelWithDictionary:dic];
                HomeNewsAllModel *allModel = [[HomeNewsAllModel alloc] init];
                allModel.homeNewsListModel = model;
                [self.dataArray addObject:allModel];
            }
            [selfWeak.tableViewAry[selfWeak.currentIndex] reloadData];
        }else {
            [HttpManager showNoteMsg:[NSString stringWithFormat:@"%@",successResponse[@"reason"]]];
        }
        [self.tableViewAry[selfWeak.currentIndex].mj_header endRefreshing];
        [self.tableViewAry[selfWeak.currentIndex].mj_footer endRefreshing];
    } andFailure:^(id failureResponse) {
        [self.tableViewAry[selfWeak.currentIndex].mj_header endRefreshing];
        [self.tableViewAry[selfWeak.currentIndex].mj_footer endRefreshing];
        [HttpManager showFail];
    }];
}

- (void)setCategoryTitleWithData
{
    self.labelNameArray = @[@"头条",@"社会热点",@"国内",@"国际",@"娱乐有看点",@"体育",@"军事",@"科技",@"财经",@"时尚"];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.labelNameArray.count, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-ScreenX375(180)-TAB_BAR_HEIGHT);
    self.categoryTitleView.titles = self.labelNameArray;
    self.categoryTitleView.contentScrollView = self.scrollView;
    [self.categoryTitleView reloadData];
    for (int i = 0; i < self.labelNameArray.count; i++) {
        CGRect frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-ScreenX375(180)-TAB_BAR_HEIGHT);
        [self getTableViewWith:frame tag:1000+i];
        if (i == 0) {
            [self getNewsListData:self.labelNameArray[0]];
        }
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    _currentIndex = index;
    
    [self getNewsListData:self.labelNameArray[_currentIndex]];
    NSLog(@"%d", (int)index);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeNewsAllModel *allModel = self.dataArray[indexPath.row];
    
    if (allModel.type == 0) {//0是没有图片
        return ScreenX375(70);
    }else if (allModel.type == 1) {//1是只有一张图片
        return ScreenX375(97);
    }else {//2是有三张图片
        return ScreenX375(175);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeNewsTableViewCell *cell = [HomeNewsTableViewCell cellWithTableView:tableView];
    HomeNewsAllModel *allModel = self.dataArray[indexPath.row];
    cell.allModel = allModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self ifNotAuthenticationShowAlert];
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    HomeNewsAllModel *allModel = self.dataArray[indexPath.row];
    HomeNewsDetailViewController *vc = [[HomeNewsDetailViewController alloc] init];
    vc.allModel = allModel;
    [self.navigationController pushViewController:vc animated:true];
}


- (void)ifNotAuthenticationShowAlert
{
    if (![kNSUDefaultReadKey(@"isLogin") integerValue]) {
//        kKeyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat orign = scrollView.contentOffset.y;
        NSLog(@"%@~~~~~",scrollView);
        if (orign > 0) {
            [self resetCategoryViewOrign_y];
        }else {
            [self restoreCategoryViewOrign_y];
        }
    }
}

#pragma mark - 重新设置Category的Y值
- (void)resetCategoryViewOrign_y
{
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.frame           = CGRectMake(0, -Header_Height, SCREEN_WIDTH, Header_Height);
        self.categoryTitleView.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        self.scrollView.frame           = CGRectMake(0, 48, SCREEN_WIDTH, SCREEN_HEIGHT-48-TAB_BAR_HEIGHT);
        self.scrollView.contentSize     = CGSizeMake(self.labelNameArray.count*SCREEN_WIDTH, SCREEN_HEIGHT-48-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
        for (UITableView *tableView in self.tableViewAry) {
            tableView.height = SCREEN_HEIGHT-TAB_BAR_HEIGHT-48-NAVIGATION_BAR_HEIGHT;
        }
    }];
}

#pragma mark - 恢复设置Category的Y值
- (void)restoreCategoryViewOrign_y
{
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Header_Height);
        self.categoryTitleView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, 48);
        self.scrollView.frame = CGRectMake(0, Header_Height+48, SCREEN_WIDTH, SCREEN_HEIGHT-48-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-Header_Height);
        self.scrollView.contentSize = CGSizeMake(self.labelNameArray.count*SCREEN_WIDTH, SCREEN_HEIGHT-48-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-Header_Height);
        for (UITableView *tableView in self.tableViewAry) {
            tableView.height = SCREEN_HEIGHT-TAB_BAR_HEIGHT-48-Header_Height-NAVIGATION_BAR_HEIGHT;
        }
    }];
}

@end
