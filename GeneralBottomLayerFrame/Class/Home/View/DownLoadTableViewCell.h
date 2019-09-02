//
//  DownLoadTableViewCell.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/27.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadTableViewCell : UITableViewCell

+ (DownLoadTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)setProgressLabelText:(CGFloat )text;
@property (nonatomic,strong)  void(^beginBlock)(UILabel *progressLabel,UIProgressView *progressView);
@property (nonatomic,strong)  void(^resumeBlock)(UILabel *progressLabel,UIProgressView *progressView);

@end

NS_ASSUME_NONNULL_END
