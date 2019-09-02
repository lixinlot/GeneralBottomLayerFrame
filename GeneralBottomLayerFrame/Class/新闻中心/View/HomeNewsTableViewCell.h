//
//  HomeNewsTableViewCell.h
//  RongMei
//
//  Created by jimmy on 2018/12/5.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeNewsTableViewCell : UITableViewCell

+ (HomeNewsTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)  HomeNewsAllModel  * allModel;
///内容
@property (nonatomic,strong)  UILabel  * contentLabel;

//@property (nonatomic,strong)  void(^playVideoBlock)(void);
///匹配关键字 修改字体颜色
//- (void)matchKeyWordsWith:(NSString *)keyWords;

@property (nonatomic,assign)  BOOL  isSearch;
@property (nonatomic,copy)  NSString  *keyWords;

@property (nonatomic,strong)  UIView  * line;

- (void)notAllowContentHaveRows;

@end

NS_ASSUME_NONNULL_END
