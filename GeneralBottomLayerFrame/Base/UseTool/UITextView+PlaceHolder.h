//
//  UITextView+PlaceHolder.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)

///占位文字
@property (copy, nonatomic) NSString *placeHolderString;

///占位文字颜色
@property (copy, nonatomic) UIColor *placeHolderColor;

///占位文字字体
@property (copy, nonatomic) UIFont  *placeHolderFont;

@end
