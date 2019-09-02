//
//  TestViewController1.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject

+ (NSArray *)tableViewDatas;

@end

@interface DrawTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^block)(UITableViewCell *cell);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@interface TestViewController1 : BaseViewController



@end

NS_ASSUME_NONNULL_END
