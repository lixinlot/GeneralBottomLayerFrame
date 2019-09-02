//
//  TestViewController3.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController3 : BaseViewController

typedef  void(^btnClickBlock)(NSString *);

@property (nonatomic, copy)btnClickBlock clicked;

@end

NS_ASSUME_NONNULL_END
