//
//  FindReporterCallPhoneCell.h
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindReporterCallPhoneCell : UITableViewCell

+ (FindReporterCallPhoneCell *)cellWithTableView:(UITableView *)tableView;

- (void)setPhoneNumWith:(NSString *)phoneNum;

@property (nonatomic,strong)  void(^dialPhoneNum)(void);

@end

NS_ASSUME_NONNULL_END
