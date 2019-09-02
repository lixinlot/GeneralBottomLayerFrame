//
//  SubViewController.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "BaseViewController.h"

@interface SubViewController : BaseViewController

@property (nonatomic,copy)  NSString  * textStr;
@property (nonatomic,strong)  NSArray  * actions;

@property (nonatomic,strong) NSIndexPath  * indexpath;
@property (nonatomic,strong)  void(^deleteSelectRow)(NSIndexPath *indexpath);

@end
