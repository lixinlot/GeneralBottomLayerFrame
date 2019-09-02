//
//  NewLocalHomeTopCell.h
//  RongMei
//
//  Created by jimmy on 2019/5/10.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NewLocalHomeTopCell : UIView //UICollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame withCurrentNav:(UINavigationController *)currentNav;

@property (nonatomic,strong)  void(^didSelectCycleScrollViewBlock)(NSInteger index);

@property (nonatomic,strong)  void(^didEnterGroupBlock)(NSInteger index);

///设置轮播图图片
- (void)setCycleBannerViewBackImage:(NSArray *)imageArray;
#pragma mark - 设置跑马灯的数据
- (void)setVerticalLampDataSourceWith:(NSArray *)array;

- (void)setScrollViewCollectViewWith:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
