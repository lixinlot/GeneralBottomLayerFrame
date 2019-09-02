//
//  SingleSelectPickerView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "SingleSelectPickerView.h"
#import "GKCover.h"

@interface SingleSelectPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,copy)    SelectPickerViewBlock  selectBlock;

@property (nonatomic,copy)    NSString             * selectValue;

@property (nonatomic,strong)  NSArray              * dataArray;

@property (nonatomic,strong)  UIPickerView         * pickerView;


@end

@implementation SingleSelectPickerView

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

+(void)selectPickViewWithDataArray:(NSArray *)dataAry valueBlock:(SelectPickerViewBlock)valueBlock
{
    SingleSelectPickerView * pickView = [[SingleSelectPickerView alloc] init];
    pickView.gk_size = CGSizeMake(SCREEN_WIDTH, 240);
    pickView.selectBlock = valueBlock;
    pickView.dataArray = dataAry;
    //设置默认选中的是第一个
    pickView.selectValue = dataAry.firstObject;
    [pickView setViewUI];
    
    [GKCover coverFrom:[[UIApplication sharedApplication] keyWindow] contentView:pickView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:true];
    
}

-(void)setViewUI
{
    UIView *btnView = [[UIView alloc] init];
    [self addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@43);
    }];
    btnView.backgroundColor = UIColorFromRGB(@"#f5f5f5", 1);
    UIButton *cancelBtn = [[UIButton alloc] init];
    [btnView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@43);
        make.top.equalTo(btnView.mas_top);
        make.left.equalTo(btnView.mas_left).offset(16);
    }];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(@"#008cd6", 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [btnView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@43);
        make.top.equalTo(btnView.mas_top);
        make.right.equalTo(btnView.mas_right).offset(-16);
    }];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(@"#008cd6", 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setPicker];
    
}
-(void)setPicker
{
    UIPickerView *pick = [[UIPickerView alloc] init];
    pick.delegate = self;
    pick.dataSource = self;
    
    pick.backgroundColor = [UIColor whiteColor];
    [self addSubview:pick];
    [pick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@197);
    }];
}

-(void)cancelClick
{
    [GKCover hideCover];
}

-(void)sureClick
{
    if (self.selectBlock) {
        self.selectBlock(self.selectValue);
    }
    [GKCover hideCover];
}

// 返回的列显示的数量。
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回行数在每个组件(每一列)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

//每一列组件的列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH - ScreenX375(40);
}

//每一列组件的行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//// 返回每一列组件的每一行的标题内容
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return self.dataArray[row];
//}

//执行选择某列某行的操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@" row - %ld, com - %ld", row, component);
    self.selectValue = self.dataArray[row];
    NSLog(@"%@",self.selectValue);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = UIColorFromRGB(@"d8d8d8", 1);
        }
    }
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = self.dataArray[row];
    genderLabel.font = Kfont(16);
    genderLabel.textColor = UIColorFromRGB(@"333333", 1);
    
    return genderLabel;
}

@end
