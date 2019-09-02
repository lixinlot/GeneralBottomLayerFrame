//
//  SingleSelectPickerView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectPickerView : UIView

typedef void(^SelectPickerViewBlock)(NSString *value);

///选择器只有一列时候的类方法
+(void)selectPickViewWithDataArray:(NSArray *)dataAry valueBlock:(SelectPickerViewBlock)valueBlock;

@end
