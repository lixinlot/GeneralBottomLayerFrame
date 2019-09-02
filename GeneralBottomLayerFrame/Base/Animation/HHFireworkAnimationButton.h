//
//  HHFireworkAnimationButton.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/7/22.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHFireworkAnimationButton : UIButton

@property (nonatomic, strong) UIImage *particleImage;
@property (nonatomic, assign) CGFloat particleScale;
@property (nonatomic, assign) CGFloat particleScaleRange;

- (void)animate;
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
