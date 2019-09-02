//
//  TYCyclePagerViewCell.h
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCyclePagerViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *acountLabel;
@property (nonatomic, weak, readonly) UILabel *seeDetailLabel;

@property (nonatomic, assign) CGFloat          borderWidth;
@property (nonatomic, assign) UIColor         *borderColor;
@property (nonatomic, assign) CGFloat          cornerRadius;

@property (nonatomic,strong)  void(^seeDetailBlock)(void);

@end
