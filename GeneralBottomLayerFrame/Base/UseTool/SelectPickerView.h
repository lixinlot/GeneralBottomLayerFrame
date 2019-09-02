//
//  SelectPickerView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/22.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPickerView : UIView

typedef void(^SelectPickerViewBlock)(NSString *value);
typedef void(^SelectMorePickerViewBlock)(NSString *value,NSString *value1,NSString *value2);

///选择器只有一列时候的类方法
+(void)selectPickViewWithDataArray:(NSArray *)dataAry valueBlock:(SelectPickerViewBlock)valueBlock type:(NSString *)typeStr;
///选择器有三列时候的类方法
+(void)selectPickViewWithDataArray0:(NSArray *)dataAry0 withDataArray1:(NSArray *)dataAry1 withDataArray2:(NSArray *)dataAry2 valueBlock:(SelectMorePickerViewBlock)valueBlock type:(NSString *)typeStr;

@property (nonatomic,strong)  NSString             * typeStr;

@end
