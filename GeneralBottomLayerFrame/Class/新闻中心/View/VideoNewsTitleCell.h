//
//  VideoNewsTitleCell.h
//  RongMei
//
//  Created by jimmy on 2018/12/7.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTitleTextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoNewsTitleCell : UITableViewCell

+ (VideoNewsTitleCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)  VideoTitleTextModel  * videoTitleTextModel;

@end

NS_ASSUME_NONNULL_END
