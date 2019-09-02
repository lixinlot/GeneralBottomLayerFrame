//
//  ThreeSelectPickerView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/10.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeSelectPickerView : UIView

typedef void(^ThreeSelectPickerViewBlock)(NSString *value,NSString *value1,NSString *value2);

///有三列时候的block
@property (nonatomic,copy)    ThreeSelectPickerViewBlock  selectMoreBlock;

///选择器有三列时候的类方法
+(void)selectPickViewWithValueBlock:(ThreeSelectPickerViewBlock)valueBlock;


@end
