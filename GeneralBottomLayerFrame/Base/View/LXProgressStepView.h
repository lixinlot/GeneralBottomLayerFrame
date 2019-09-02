//
//  LXProgressStepView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/26.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXProgressStepView : UIView

@property (nonatomic,assign) NSInteger stepIndex;

+(instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray;

@end

NS_ASSUME_NONNULL_END
