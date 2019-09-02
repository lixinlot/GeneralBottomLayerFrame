//
//  PayMethodView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "PayMethodView.h"

@interface PayMethodView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)  UITableView  * tableView;
@property (nonatomic,strong)  UIImageView  * rightImage;
//@property (nonatomic, assign)   BOOL         isSelected;//是否选中
//@property (assign, nonatomic) NSIndexPath  * selIndex;
@property (assign, nonatomic) NSInteger  selIndex;//选中的行

@end

@implementation PayMethodView

+(PayMethodView *)payMethodViewWithFrame:(CGRect)rect
{
    PayMethodView *view = [[PayMethodView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selIndex = 0;
        [self setTableViewUI];
    }
    return self;
}

-(void)setTableViewUI
{
//    self.isSelected = NO;//是否被选中 默认为NO
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (ScreenX375(44)*7), SCREEN_WIDTH, ScreenX375(44)*7)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = false;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self addSubview:self.tableView];
}

-(void)sureClick
{
    WeakObj(self);
    if (_selectPayMethodBlock) {
        _selectPayMethodBlock(selfWeak.selIndex);
    }
}

-(void)backClick
{
    if (_backBlock) {
        _backBlock();
    }
    self.rightImage.image = [UIImage imageNamed:@"未选择"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenX375(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenX375(15), ScreenX375(7), ScreenX375(30), ScreenX375(30));
    [button setImage:[UIImage imageNamed:@"返回灰色"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((SCREEN_WIDTH - ScreenX375(200))/2, 0, ScreenX375(200), 44);
    label.text = @"请选择支付方式";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = FONTCOLOR_BLACK;
    label.font = Kfont(20);
    [view addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(-ScreenX375(180)/2, label.bottom - 1, SCREEN_WIDTH, 1);
    lineLabel.backgroundColor = LineColor;
    [label addSubview:lineLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ScreenX375(44);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(ScreenX375(15), ScreenX375(22), SCREEN_WIDTH - ScreenX375(30), ScreenX375(44));
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 22.0;
    button.backgroundColor = ThemeColor;
    [button setTitle:@"支付" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *methodImageNameArray = @[@"支付宝支付",@"微信支付",@"银行卡支付",@"其他支付方式"];
    NSArray *methodNameArray = @[@"支付宝支付",@"微信支付",@"银行卡支付",@"其他支付方式"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    
    [cell removeAllSubviews];
    
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.frame = CGRectMake(ScreenX375(15), ScreenX375(11), ScreenX375(22), ScreenX375(22));
    leftImage.image = [UIImage imageNamed:methodImageNameArray[indexPath.row]];
    [cell addSubview:leftImage];
    
    UILabel *methodNameL = [[UILabel alloc] init];
    methodNameL.frame = CGRectMake((SCREEN_WIDTH - ScreenX375(220))/2, 0, ScreenX375(200), 44);
    methodNameL.text = methodNameArray[indexPath.row];
    methodNameL.textAlignment = NSTextAlignmentLeft;
    methodNameL.textColor = FONTCOLOR_BLACK;
    methodNameL.font = Kfont(16);
    [cell addSubview:methodNameL];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, methodNameL.bottom - 1, SCREEN_WIDTH, 1);
    lineLabel.backgroundColor = LineColor;
    [cell addSubview:lineLabel];
    
    self.rightImage = [[UIImageView alloc] init];
    self.rightImage.frame = CGRectMake(SCREEN_WIDTH - ScreenX375(32), ScreenX375(15), ScreenX375(14), ScreenX375(14));
    
    //当前选择的打勾
    if (self.selIndex == indexPath.row) {
        self.rightImage.image = [UIImage imageNamed:@"选择"];
    }else{
        self.rightImage.image = [UIImage imageNamed:@"未选择"];
    }
    [cell addSubview:self.rightImage];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    self.selIndex = indexPath.row;
    
    [self.tableView reloadData];
    
//    NSIndexPath * temp = self.lastSelIndex;//暂存上一次选中的行
//    if (temp && temp != indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一行,则让上一行不选中
//    {
//        self.isSelected = NO;//修改之前选中的cell的数据为不选中
//        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新该行
//    }
//    self.lastSelIndex = indexPath;//选中的修改为当前行
//    self.isSelected = YES;//修改这个被选中的一行
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新该行

}

@end
