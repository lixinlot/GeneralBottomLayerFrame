//
//  WorksDetailViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/18.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "WorksDetailViewController.h"
#import "UIViewController+Extension.h"
#import <SDCycleScrollView.h>
#import "CycleCell.h"
#import "GetWKWebViewController.h"

@interface WorksDetailViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)  BaseTableView   * tableView;

///轮播图
@property (nonatomic, strong) SDCycleScrollView * cycleBannerView;


@end

@implementation WorksDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"作品详情"];
    
    [self setNavigationRightBarButtonWithImage:nil withTitle:@"右" withTitleColor:[UIColor whiteColor] withTitleFont:[UIFont systemFontOfSize:16] withButtonFrame:CGRectMake(0, 0, 40, 40) withSelector:@selector(rightClick) withTarget:self];
    
    [self setTableViewUI];
}

- (void)rightClick
{
    NSLog(@"currentQueue -- %@",[NSThread currentThread]);
    NSLog(@"Dispatch - asyn - Beigin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
//        [HttpManager showNoteMsg:@"currentQueue 1"];
        [self nslog:1];
        NSLog(@"currentQueue 1 --%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [self nslog:2];
//        [HttpManager showNoteMsg:@"currentQueue 2"];
        NSLog(@"currentQueue 2 --%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [self nslog:3];
//        [HttpManager showNoteMsg:@"currentQueue 3"];
        NSLog(@"currentQueue 3 --%@",[NSThread currentThread]);
    });
    
    NSLog(@"Dispatch - asyn - End");
}

- (void)nslog:(NSInteger)number
{
    NSLog(@"%ld",(long)number);
}

#pragma mark - 设置tableView的UI
-(void)setTableViewUI
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, ScreenX375(0), SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];//-ScreenX375(200)
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    
    UIView *topBjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(200))];
    topBjView.backgroundColor = [UIColor whiteColor];
    self.cycleBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(ScreenX375(15), ScreenX375(15), SCREEN_WIDTH - ScreenX375(30), ScreenX375(170)) delegate:self placeholderImage:[UIImage imageNamed:@"背景"]];
    self.cycleBannerView.localizationImageNamesGroup = @[@"13",@"14",@"16"];
    self.cycleBannerView.autoScrollTimeInterval = 3.0;
    self.cycleBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleBannerView.pageDotColor = [UIColor whiteColor];
    self.cycleBannerView.currentPageDotColor = [UIColor redColor];
    self.cycleBannerView.titleLabelBackgroundColor = UIColorFromRGB(@"ffffff", 0.8);
    self.cycleBannerView.titlesGroup = @[@"第一张",@"第二张",@"第三张"];
    self.cycleBannerView.titleLabelTextColor = [UIColor cyanColor];
    self.cycleBannerView.layer.masksToBounds = YES;
    self.cycleBannerView.layer.cornerRadius = 8.0;
    [topBjView addSubview:self.cycleBannerView];
    
    self.tableView.tableHeaderView = topBjView;
}

#pragma mark - 实现轮播图的代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个",index);
    GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - 实现tableView的代理和数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenX375(230);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CycleCell *cell = [CycleCell cellWithTableView:tableView andIndexPath:indexPath];
    
    cell.selectPicsBlock = ^(NSInteger index) {
        NSLog(@"点击了添加图片按钮");
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //            GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
            //            vc.typeValue = @"1";
            //            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }else{
            //            GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
            //            vc.typeValue = @"2";
            //            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }
    }else{
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //                GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
                //                vc.typeValue = @"3";
                //                [self.navigationController pushViewController:vc animated:true];
                NSLog(@"第1区第%ld行",indexPath.row);
            }else{
                //                GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
                //                vc.typeValue = @"4";
                //                [self.navigationController pushViewController:vc animated:true];
                NSLog(@"第1区第%ld行",indexPath.row);
            }
        }
    }
}

@end
