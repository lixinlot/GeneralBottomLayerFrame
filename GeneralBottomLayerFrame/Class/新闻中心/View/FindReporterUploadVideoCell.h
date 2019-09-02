//
//  FindReporterUploadVideoCell.h
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindReporterUploadVideoCell : UITableViewCell

+ (FindReporterUploadVideoCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)  void(^selectVideoOrPicBlock)(void);

- (void)setImageWith:(id )imageData;

@end

NS_ASSUME_NONNULL_END
