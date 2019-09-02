//
//  OtherViewController.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherViewController : BaseViewController

@property (nonatomic,strong)  void(^returnHeightBlock)(CGFloat webHeight);

@end
