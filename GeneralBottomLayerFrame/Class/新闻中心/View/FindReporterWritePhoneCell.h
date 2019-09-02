//
//  FindReporterWritePhoneCell.h
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindReporterWritePhoneCell : UITableViewCell

+ (FindReporterWritePhoneCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)  void(^phoneWriteBlock)(NSString *phone);


@end

NS_ASSUME_NONNULL_END
