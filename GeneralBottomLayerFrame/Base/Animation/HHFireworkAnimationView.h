//
//  HHFireworkAnimationView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/7/22.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHFireworkAnimationView : UIView

@property (nonatomic, strong) UIImage *particleImage;
@property (nonatomic, assign) CGFloat  particleScale;
@property (nonatomic, assign) CGFloat  particleScaleRange;

- (void)animate;

@end

NS_ASSUME_NONNULL_END
