//
//  MineViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "MineViewController.h"
#import "HeaderView.h"
#import "SingleSelectPickerView.h"
#import "SelectPickerView.h"
#import "ScanViewController.h"
#import "ThreeSelectPickerView.h"
#import "GKCover.h"
#import "ToolClass.h"

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///最上方的最后出来的View
@property (nonatomic,strong)  UIView        * coverNavView;
///最上方的先显示的View
@property (nonatomic,strong)  UIView        * mainNavView;
///naviBar下面的View
@property (nonatomic,strong)  HeaderView    * headerView;

@property (nonatomic,strong)  UITableView   * tableView;

@property (nonatomic,strong)  UIView        * bjView;
///日期选择器
@property (nonatomic,strong)  UIDatePicker  * datePicker;
///naviBar下面的View
@property (nonatomic,strong)  HeaderView    * childView;
@property (nonatomic,strong)  NSArray       * typeArray;
@property (nonatomic,strong)  NSArray       * titleArray;
@property (nonatomic,strong)  UILabel       * contentL;

@property (nonatomic,strong)  NSDictionary  * dataDict;


@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];
    [self setDatePicker];
    self.titleArray = @[@"姓      名:",@"性      别:",@"出生年月:",@"所在地区:",@"学      历:",@"1",@"2",@"3",@"4"];
    self.typeArray = @[@"姓名",@"性别",@"出生年月",@"所在地区",@"学历"];
}

#pragma mark - 扫一扫的实现方法
-(void)ScanClick
{
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - 设置头部的UI
-(void)buildUI
{
    self.coverNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.coverNavView.alpha = 0;
    self.coverNavView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.coverNavView];
    
    UIButton *scan_mini = [UIButton buttonWithType:UIButtonTypeCustom];
    scan_mini.frame = CGRectMake(10,(64 - 35) / 2,35,35);
    [scan_mini setImage:[UIImage imageNamed:@"扫一扫小"] forState:UIControlStateNormal];
    [self.coverNavView addSubview:scan_mini];
    
    UIButton *pay_mini = [UIButton buttonWithType:UIButtonTypeCustom];
    pay_mini.frame = CGRectMake(60,(64 - 35) / 2,35,35);
    [pay_mini setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [self.coverNavView addSubview:pay_mini];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(SCREEN_WIDTH - 60,(64 - 35) / 2,35,35);
    [add setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [self.coverNavView addSubview:add];
    
    self.mainNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.mainNavView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.mainNavView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 20, 300, 34)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.text = @"搜索";
    [self.mainNavView addSubview:searchBar];
    
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    contact.frame = CGRectMake(SCREEN_WIDTH - 50,20,35,35);
    [contact setImage:[UIImage imageNamed:@"相机小"] forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(ScanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainNavView addSubview:contact];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT) style: UITableViewStylePlain];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.headerView = [[HeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(325));
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
}

-(void)setDatePicker
{
    self.bjView = [[UIView alloc] init];
    self.bjView.gk_size = CGSizeMake(SCREEN_WIDTH, ScreenX375(243));
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(43))];
    [self.bjView addSubview:btnView];
    btnView.backgroundColor = UIColorFromRGB(@"#f5f5f5", 1);
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX375(16), 0, ScreenX375(32), ScreenX375(43))];
    [btnView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(@"#008cd6", 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ScreenX375(48), 0, ScreenX375(32), ScreenX375(43))];
    [btnView addSubview:sureBtn];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(@"#008cd6", 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    //创建DatePicker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenX375(43), SCREEN_WIDTH, ScreenX375(200))];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.bjView addSubview:self.datePicker];
}

-(void)cancelClick
{
    [GKCover hideCover];
}

-(void)sureClick
{
    //获取挑选的日期
    NSDate *date =_datePicker.date;
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    //设定转换格式
    dateForm.dateFormat =@"yyy年MM月dd日";//h时mm分
    //由当前获取的NSDate数据，转换为日期字符串，显示在私有成员变量_textField上
    self.contentL.text = [dateForm stringFromDate:date];
    [GKCover hideCover];
}

#pragma mark - 实现TableView的代理和数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.titleArray.count;
    }else{
        return 1;
    }
}

static NSString* cellID = @"cellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (tableViewCell == nil) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        for (UIView *view in tableViewCell.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.frame = CGRectMake(ScreenX375(10), ScreenX375(10), ScreenX375(80), ScreenX375(24));
        titleL.text = self.titleArray[indexPath.row];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.font = KBlodfont(16);
        [tableViewCell addSubview:titleL];
        
        self.contentL = [[UILabel alloc] init];
        self.contentL.frame = CGRectMake(ScreenX375(90), ScreenX375(10), ScreenX375(200), ScreenX375(24));
        self.contentL.font = Kfont(16);
        self.contentL.textColor = FONTCOLOR_BLACK;
        self.contentL.textAlignment = NSTextAlignmentCenter;
        [tableViewCell addSubview:self.contentL];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(0, ScreenX375(43.5), SCREEN_WIDTH, ScreenX375(0.5));
        lineLabel.backgroundColor = FONTCOLOR_LIGHTGRAY;
        [tableViewCell addSubview:lineLabel];
        
        return tableViewCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"清除缓存--%.2fMB",[self folderSizeAtPath:cachePath]];//@"清除缓存";
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakObj(self);
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
            NSArray *dataArray = @[@"男",@"女"];
            [SingleSelectPickerView selectPickViewWithDataArray:dataArray valueBlock:^(NSString *value) {
                selfWeak.contentL.text = value;
            }];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (indexPath.row == 2){
            
            [GKCover coverFrom:self.view contentView:self.bjView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:true];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (indexPath.row == 3){
            
            [ThreeSelectPickerView selectPickViewWithValueBlock:^(NSString *value, NSString *value1, NSString *value2) {
                NSString *str = [NSString stringWithFormat:@"%@-%@-%@",value,value1,value2 ];
                selfWeak.contentL.text = str;
            }];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            
            NSArray *dataArray = @[@"高中及高中以下",@"大专以下",@"本科",@"研究生",@"博士"];
            [SingleSelectPickerView selectPickViewWithDataArray:dataArray valueBlock:^(NSString *value) {
                selfWeak.contentL.text = value;
            }];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }else{
        [self cleanCaches:cachePath];
        [HttpManager showNoteMsg:@"清理成功"];
        [self.tableView reloadData];
    }
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

//实现滚动UIScrollViewDelegate协议
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0 && offsetY < 24){
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if(offsetY >= 24 && offsetY < 95){
        [self.tableView setContentOffset:CGPointMake(0, 95) animated:true];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY <= 0){
        self.headerView.frame = CGRectMake(0, offsetY, SCREEN_WIDTH, 305);
        [self.headerView changAlpha:1];
        self.coverNavView.alpha = 0;
        self.mainNavView.alpha = 1;
    }
    else if(offsetY > 0 && offsetY < 95){
        CGFloat alpha = (1 - offsetY / 95) > 0 ? (1 - offsetY / 95) : 0;
        [self.headerView changAlpha:alpha / 3];
        
        if(alpha > 0.9){
            self.coverNavView.alpha = 0;
            self.mainNavView.alpha = alpha / 5;
        }else{
            self.mainNavView.alpha = 0;
            self.coverNavView.alpha = 1 - alpha;
            if(alpha <= 0.75){
                [self.headerView changAlpha:0];
            }
        }
    }
}

@end
