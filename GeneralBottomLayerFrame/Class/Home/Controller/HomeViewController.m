//
//  HomeViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HomeViewController.h"
#import "WeatherVC.h"
#import <WebKit/WebKit.h>
#import "GetWKWebViewController.h"
#import "PayMethodView.h"
#import "SubViewController.h"
#import "PayViewController.h"
#import "SWRevealViewController.h"
#import "ProgressViewController.h"
#import "DownLoadViewController.h"
#import "YYLabelTextViewController.h"
#import "RLMObjectModelDemo.h"
#import "BankNumberCheckController.h"

//@protocol RACSubscriber;

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic,strong)  SubViewController * viewController;
@property (nonatomic,strong)  BaseTableView  * tableView;
@property (nonatomic,strong)  WKWebView      * oneWebView;
@property (nonatomic,strong)  NSMutableArray * dataArray;
@property (nonatomic,strong)  NSMutableArray  * deleteIndex;
///订阅
@property (nonatomic,weak)  id<RACSubscriber>   subScriber;


@end

@implementation HomeViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)deleteIndex
{
    if (_deleteIndex == nil) {
        _deleteIndex = [[NSMutableArray alloc] init];
    }
    return _deleteIndex;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.dataArray = [@[@"11111",@"22222",@"33333",@"44444",@"55555",@"66666",@"77777",@"88888",@"99999"] mutableCopy];
    
    [self setTitle:@"新闻"];
    
    [self setTableViewUI];
    [self.tableView reloadData];
    
    //注册该页面可以执行滑动切换
//    SWRevealViewController *revealController = [[SWRevealViewController alloc] init];
//    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
//
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT-NAV_HEIGHT);
//    [self.view addSubview:leftBtn];
//
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT-NAV_HEIGHT);
//    [self.view addSubview:rightBtn];
//
//    // 注册该页面可以执行点击切换
//    [leftBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setSignal];
    [self arrayTuple];
    [self dictTuple];
}

#pragma mark -
- (void)setSignal
{
    //三步：1.创建信号  2.订阅信号  3.发送信号
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"");
        self->_subScriber = subscriber;
        //3. 发送信号
        [self->_subScriber sendNext:@1];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
    }];
    //2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //取消订阅
    [disposable dispose];
}

#pragma mark - rac遍历数组
- (void)arrayTuple
{
    NSArray *array = @[@1,@2,@3];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"数组Tuple***%@",x);
    }];
}

#pragma mark - rac遍历字典
- (void)dictTuple
{
    NSDictionary *dict = @{@"name":@"小明",@"age":@"18岁",@"sex":@"男"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        //RACTupleUnpack宏 解包元组，会将元组里的值 按顺序给参数赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"字典Tuple****%@---%@",key,value);
    }];
}

#pragma mark - rac字典转模型
- (void)racDictToModel
{
    [HttpManager postHttpRequestByGet:@"" andParameter:@{} success:^(id successResponse) {
        NSInteger status = [successResponse[@"code"] integerValue];
        if (status == 200) {            
            
            
        }else {
            [HttpManager showNoteMsg:@"不知道"];
        }
    } andFailure:^(id failureResponse) {
        [HttpManager showFail];
    }];
}

#pragma mark - 设置tableView的UI
-(void)setTableViewUI
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
}

#pragma mark - 实现tableView的代理和数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    WeakObj(self);
    if (self.viewController) {
        self.viewController.deleteSelectRow = ^(NSIndexPath *indexpath) {
            [selfWeak.deleteIndex addObject:indexpath];
        };
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.font = Kfont(20);

    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, cell.bottom - 1, SCREEN_WIDTH, 1);
    lineLabel.backgroundColor = LineColor;
    [cell addSubview:lineLabel];
    
    /// 先判断3DTouch是否可用
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {// 3DTouch可用
        // 注册3DTouch协议
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    } else{
        NSLog(@"3DTouch不可用");
    }
    return cell;
}

- (void)setModelDemo
{
    RLMObjectModelDemo *modelDemo = [[RLMObjectModelDemo alloc] init];
    modelDemo.ages = 22;
    modelDemo.dogName = @"***";
    modelDemo.allData = nil;
}


#pragma mark - 给即将跳转的控制器传值，并且控制按压的视图周围的模糊背景大小等等
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    /// 需要创建的控制器
    self.viewController = [[SubViewController alloc] init];
    /// 传值
    self.viewController.textStr = [NSString stringWithFormat:@"这是第%li行", indexPath.row];
//    self.viewController.indexpath = indexPath;
//    /// 没有毛玻璃的大小(44.f就是每一个cell的高度，大家可以改变高度来看看效果)
//    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 44.f);
//    previewingContext.sourceRect = rect;
    
    WeakObj(self);
    UIPreviewAction *confirmAction = [UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSString *firstStr = [selfWeak.dataArray objectAtIndex:indexPath.row];
        [selfWeak.dataArray  removeObjectAtIndex:indexPath.row];
        [selfWeak.dataArray insertObject:firstStr atIndex:0];
        [selfWeak.tableView reloadData];
        NSLog(@"置顶");
    }];
    
    UIPreviewAction *defaultAction = [UIPreviewAction actionWithTitle:@"标为未读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"标为未读");
    }];
    
    UIPreviewAction *cancelAction = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {

        [selfWeak.dataArray  removeObjectAtIndex:indexPath.row];
        [selfWeak.tableView reloadData];
        NSLog(@"删除了第%ld行",indexPath.row);
    }];
    
    self.viewController.actions = @[confirmAction, defaultAction,cancelAction];
    
    return self.viewController;
}

#pragma mark - 控制跳转的方法push & present
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    /// 这里根据大家的需求处理，除了跳转方式也可以添加逻辑
    [self showViewController:viewControllerToCommit sender:self];
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    WeakObj(self);
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加点击事件
        [selfWeak.dataArray  removeObjectAtIndex:indexPath.row];
        [selfWeak.tableView reloadData];
        NSLog(@"删除了第%ld行",indexPath.row);
    }];
    // 添加一个编辑按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加编辑事件
//        NSString *editStr = @"雷松是条狗";
        [selfWeak showListWithIndexPath:indexPath];
        
    }];
    topRowAction.backgroundColor = UIColorFromRGB(@"0x54a9dd", 1);
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
}

- (void)showListWithIndexPath:(NSIndexPath *)indexPath{
    //提示框添加文本输入框
    WeakObj(self);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * action) {
        //响应事件  得到文本信息
        for(UITextField *text in alert.textFields){
            NSLog(@"text = %@", text.text);
            [selfWeak.dataArray  removeObjectAtIndex:indexPath.row];
            [selfWeak.dataArray insertObject:text.text atIndex:indexPath.row];
            [selfWeak.tableView reloadData];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel   handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"action = %@", alert.textFields);
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"登录";
    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"密码";
//        textField.secureTextEntry = YES;
//    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PayViewController *vc = [[PayViewController alloc] init];
            //vc.typeValue = @"1";
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }else if(indexPath.row == 1){
            GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
            vc.typeValue = @"2";
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }else if (indexPath.row == 2){
            DownLoadViewController *vc = [[DownLoadViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }else if (indexPath.row == 3){
            YYLabelTextViewController *vc = [[YYLabelTextViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }else if (indexPath.row == 4){
            ProgressViewController *vc = [[ProgressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }else if (indexPath.row == 5){
            ProgressViewController *vc = [[ProgressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }else {
            BankNumberCheckController *vc = [[BankNumberCheckController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第0区第%ld行",indexPath.row);
        }
    }else{
        if (indexPath.row == 0) {
            WeatherVC *vc = [[WeatherVC alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }else{
            GetWKWebViewController *vc = [[GetWKWebViewController alloc] init];
            vc.typeValue = @"4";
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"第1区第%ld行",indexPath.row);
        }
    }
}

@end
