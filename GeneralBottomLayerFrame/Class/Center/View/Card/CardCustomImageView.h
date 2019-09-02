//
//  CardCustomImageView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/7/17.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCardItemView.h"

@class CHCardItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface CardCustomImageView : CHCardItemView

@property (nonatomic, strong) CHCardItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
