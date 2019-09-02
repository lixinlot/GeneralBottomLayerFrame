//
//  HomeVideoLittleCell.h
//  RongMei
//
//  Created by jimmy on 2019/3/18.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeVideoLittleCell : UITableViewCell

///内容
@property (nonatomic,strong)  UILabel  * contentLabel;

+ (HomeVideoLittleCell *)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,strong)  HomeNewsListModel  * newsModel;


- (void)notAllowContentHaveRows;

@property (nonatomic,strong)  UIView  * line;

@end

NS_ASSUME_NONNULL_END
