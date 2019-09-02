//
//  SelectPickerView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/22.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "SelectPickerView.h"
#import "GKCover.h"

@interface SelectPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

///只有一列时候的block
@property (nonatomic,copy)    SelectPickerViewBlock  selectBlock;
///有三列时候的block
@property (nonatomic,copy)    SelectMorePickerViewBlock  selectMoreBlock;
@property (nonatomic,copy)    NSString             * selectValue;
@property (nonatomic,copy)    NSString             * selectValue1;
@property (nonatomic,copy)    NSString             * selectValue2;
@property (nonatomic,strong)  NSArray              * dataArray;
@property (nonatomic,strong)  NSArray              * dataArray1;
@property (nonatomic,strong)  NSArray              * dataArray2;
@property (nonatomic,strong)  UIPickerView         * pickerView;
///地址数组
@property (nonatomic, strong, nullable)NSArray        *areaDataSource;


///是否是闰年
//@property (nonatomic,assign)  BOOL  isSpecialYear;

///月份
//@property (nonatomic,assign)  NSInteger  * monthNum;
///日期的年
@property(nonatomic,strong)NSArray *years;
///日期的月
@property(nonatomic,strong)NSArray *months;
///日期的日
@property(nonatomic,strong)NSArray *days;

@property (nonatomic,strong)  NSDictionary *dataDict;
//省份数组
@property (nonatomic, strong, nullable)NSMutableArray *provinceArray;
///城市数组
@property (nonatomic, strong, nullable)NSMutableArray *cityArray;
///城镇区数组
@property (nonatomic, strong, nullable)NSMutableArray *districtArray;

@end

@implementation SelectPickerView

- (NSArray *)areaDataSource
{
    if (!_areaDataSource) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        self.dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        _areaDataSource = [self.dataDict allValues];
    }
    return _areaDataSource;
}

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (NSArray *)dataArray1
{
    if (_dataArray1 == nil) {
        _dataArray1 = [NSArray array];
    }
    return _dataArray1;
}


- (NSArray *)dataArray2
{
    if (_dataArray2 == nil) {
        _dataArray2 = [NSArray array];
    }
    return _dataArray2;
}


+(void)selectPickViewWithDataArray:(NSArray *)dataAry valueBlock:(SelectPickerViewBlock)valueBlock type:(NSString *)typeStr
{
    SelectPickerView * pickView = [[SelectPickerView alloc] init];
    pickView.gk_size = CGSizeMake(SCREEN_WIDTH, 240);
    pickView.selectBlock = valueBlock;
    pickView.typeStr = typeStr;
    pickView.dataArray = dataAry;
    //设置默认选中的是第一个
    pickView.selectValue = dataAry.firstObject;
    [pickView setViewUIWithType:typeStr];
    
    [GKCover bottomCoverFrom:[[UIApplication sharedApplication] keyWindow] contentView:pickView style:GKCoverStyleTranslucent notClick:true animated:true];
  
}

+(void)selectPickViewWithDataArray0:(NSArray *)dataAry0 withDataArray1:(NSArray *)dataAry1 withDataArray2:(NSArray *)dataAry2 valueBlock:(SelectMorePickerViewBlock)valueBlock type:(NSString *)typeStr
{
    SelectPickerView * pickView = [[SelectPickerView alloc] init];
    pickView.gk_size = CGSizeMake(SCREEN_WIDTH, 240);
    pickView.selectMoreBlock = valueBlock;
    pickView.typeStr = typeStr;
    
    pickView.dataArray = dataAry0;
    pickView.dataArray1 = dataAry1;
    pickView.dataArray2 = dataAry2;
    //设置默认选中的是第一个
    pickView.selectValue = dataAry0.firstObject;
    pickView.selectValue1 = dataAry1.firstObject;
    pickView.selectValue2 = dataAry2.firstObject;
    [pickView setViewUIWithType:typeStr];
    
    [GKCover bottomCoverFrom:[[UIApplication sharedApplication] keyWindow] contentView:pickView style:GKCoverStyleTranslucent notClick:true animated:true];
    
}

-(void)setViewUIWithType:(NSString *)typeStr
{
    UIView *btnView = [[UIView alloc] init];
    [self addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@43);
    }];
    btnView.backgroundColor = UIColorFromRGB(@"ffffff", 1);
    UIButton *cancelBtn = [[UIButton alloc] init];
    [btnView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@43);
        make.top.equalTo(btnView.mas_top);
        make.left.equalTo(btnView.mas_left).offset(16);
    }];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(@"4a90e2", 1) forState:UIControlStateNormal];
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
    [sureBtn setTitleColor:UIColorFromRGB(@"4a90e2", 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setPickerWithType:typeStr];
    
}
-(void)setPickerWithType:(NSString *)typeStr
{
    UIPickerView *pick = [[UIPickerView alloc] init];
    pick.delegate = self;
    pick.dataSource = self;
    
    [self addSubview:pick];
    [pick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@197);
    }];
    pick.backgroundColor = UIColorFromRGB(@"f4f4f4", 1);
}
        
//        //显示当前日期
//        NSDate *now = [NSDate date];
//        //分解日期
//        NSCalendar  *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSCalendarUnit unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
//        NSDateComponents *components = [calendar components:unitFlags fromDate:now];
//
//        //设置pickerView显示当前日期
//        NSInteger year = [components year];
//        [self.pickerView selectRow:year-2000-1 inComponent:0 animated:NO];
//        NSInteger month = [components month];
//        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
//        NSInteger day = [components day];
//        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
//    }else{
//        if ([typeStr isEqualToString:@"所在地区"]) {
//            for (NSDictionary *dic in self.areaDataSource) {
//                NSArray *arr = [dic allValues];
//                [self.provinceArray addObject:[dic allKeys]];
//                for (NSDictionary *dict in arr) {
//                    NSArray *cityArr = [dict allValues];
//                    for (NSDictionary *cityDict in cityArr) {
//                        [self.cityArray addObject:[cityDict allKeys]];
//                        [self.districtArray addObject:[cityDict allValues]];
//                    }
//                }
//            }
//        }
//    }

-(void)cancelClick
{
    [GKCover hideCover];
}

-(void)sureClick
{
    if ([self.typeStr isEqualToString:@"出生年月"] || [self.typeStr isEqualToString:@"所在地区"]) {
        if (self.selectMoreBlock) {
            self.selectMoreBlock(self.selectValue,self.selectValue1,self.selectValue2);
        }
    }else{
        if (self.selectBlock) {
            self.selectBlock(self.selectValue);
        }
    }
    [GKCover hideCover];
}

// 返回的列显示的数量。
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //@[@"姓名",@"性别",@"出生年月",@"所在地区",@"学历"];
    if ([self.typeStr isEqualToString:@"姓名"]) {
        return 1;
    }else if ([self.typeStr isEqualToString:@"性别"]) {
        return 1;
    }else if ([self.typeStr isEqualToString:@"出生年月"]) {
        return 3;
    }else if ([self.typeStr isEqualToString:@"所在地区"]) {
        return 3;
    }else{
        return 1;
    }
}

//返回行数在每个组件(每一列)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dataArray.count;
    }else if (component == 1){
        return self.dataArray1.count;
    }else{
        return self.dataArray2.count;
    }
}

//每一列组件的列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([self.typeStr isEqualToString:@"姓名"]) {
        return SCREEN_WIDTH - ScreenX375(40);
    }else if ([self.typeStr isEqualToString:@"性别"]) {
        return SCREEN_WIDTH - ScreenX375(40);
    }else if ([self.typeStr isEqualToString:@"出生年月"]) {
        return (SCREEN_WIDTH - ScreenX375(40))/3;
    }else if ([self.typeStr isEqualToString:@"所在地区"]) {
        return (SCREEN_WIDTH - ScreenX375(40))/3;
    }else{
        return SCREEN_WIDTH - ScreenX375(40);
    }
}

//每一列组件的行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

// 返回每一列组件的每一行的标题内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dataArray[row];
    }else if (component == 1){
        return self.dataArray1[row];
    }else{
        return self.dataArray2[row];
    }
}

//执行选择某列某行的操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@" row - %ld, com - %ld", row, component);
    if ([self.typeStr isEqualToString:@"出生年月"]){
        if (component == 0) {
            self.selectValue = self.dataArray[row];
        }else if (component == 1) {
            self.selectValue1 = self.dataArray1[row];
            [self reloadDateWith:row];
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:true];
        }else{
           self.selectValue2 = self.dataArray2[row];
        }
    }
    else if ([self.typeStr isEqualToString:@"所在地区"]){
        if (component == 0) {
            self.selectValue = self.dataArray[row];
        }else if (component == 1) {
            self.selectValue1 = self.dataArray1[row];
            
            if (row == 1) {
                self.dataArray2 = @[@"1日", @"2日", @"28"];
            }else{
                self.dataArray2 = @[@"1日", @"2日", @"28", @"30"];
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:true];
        }else{
            self.selectValue2 = self.dataArray2[row];
        }
    }
    else{
        self.selectValue = self.dataArray[row];
    }
    NSLog(@"%@",self.selectValue);
}

- (void)reloadDateWith:(NSInteger)row
{
    BOOL  isSpecialYear = NO;
    NSMutableArray *multYears = [NSMutableArray array];//年
    NSInteger num = 80;
    for(int i=1; i<=num/2; i++)
    {
        NSString *year = [NSString stringWithFormat:@"19%02d年",i + 59];
        [multYears addObject:year];
        
        if ([year integerValue] % 400 == 0 || ([year integerValue] % 100 != 0 && [year integerValue] % 4 == 0)) {
            isSpecialYear = YES;
        }else{
            isSpecialYear = NO;
        }
    }
    NSMutableArray *multYears1 = [NSMutableArray array];//年
    multYears1 = multYears;
    for (int i = 41; i <= num; i ++) {
        NSString *year = [NSString stringWithFormat:@"20%02d年",i - 41];
        [multYears1 addObject:year];
        if ([year integerValue] % 400 == 0 || ([year integerValue] % 100 != 0 && [year integerValue] % 4 == 0)) {
            isSpecialYear = YES;
        }else{
            isSpecialYear = NO;
        }
    }
    self.dataArray = multYears1;
    
    NSInteger    daysNum = 0 ;
    NSInteger  monthsNum = 0;
    NSMutableArray *multMonths = [NSMutableArray arrayWithCapacity:12];//月
    for(int i=1; i<=12; i++)
    {
        NSString *month = [NSString stringWithFormat:@"%d月",i];
        [multMonths addObject:month];
        monthsNum = i;
    }
    self.dataArray1 = multMonths;
    
    NSString *monthStr;
    for (NSString *month in self.dataArray1) {
        monthStr = month;
    }
    
    if ([monthStr isEqualToString:@"1月"] || [monthStr isEqualToString:@"3月"] || [monthStr isEqualToString:@"5月"] || [monthStr isEqualToString:@"7月"] || [monthStr isEqualToString:@"8月"] || [monthStr isEqualToString:@"10月"] || [monthStr isEqualToString:@"12月"]) {
        daysNum = 31;
        [self initDateData:daysNum];
    }else if ([monthStr isEqualToString:@"2月"]){
        if (isSpecialYear == YES) {
            daysNum = 29;
            [self initDateData:daysNum];
        }else{
            daysNum = 28;
            [self initDateData:daysNum];
        }
    }else {
        if ([monthStr isEqualToString:@"4月"] || [monthStr isEqualToString:@"6月"] || [monthStr isEqualToString:@"9月"] || [monthStr isEqualToString:@"11月"]){
            daysNum = 30;
            [self initDateData:daysNum];
        }
    }
}

-(void)initDateData:(NSInteger)daysNum
{
    NSMutableArray *multDays = [NSMutableArray arrayWithCapacity:daysNum];
    for (int i = 1; i <= daysNum; i ++) {
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        [multDays addObject:day];
    }
    self.dataArray2 = multDays;
}

/*
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
    if ([self.typeStr isEqualToString:@"出生年月"]){
        switch (component){
            case 0:
                genderLabel.text = self.dataArray[row];
                break;
            case 1:
                genderLabel.text = self.dataArray1[row];
                break;
            case 2:
                genderLabel.text = self.dataArray2[row];
                break;
        }
    }
    else if ([self.typeStr isEqualToString:@"所在地区"]){
        switch (component){
            case 0:
                genderLabel.text = self.dataArray[row];
                break;
            case 1:
                genderLabel.text = self.dataArray1[row];
                break;
            case 2:
                genderLabel.text = self.dataArray2[row];
                break;
        }
    }
    else{
        genderLabel.text = self.dataArray[row];
    }
    
    genderLabel.font = Kfont(16);
    genderLabel.textColor = UIColorFromRGB(@"333333", 1);
    
    return genderLabel;
}
*/

@end
