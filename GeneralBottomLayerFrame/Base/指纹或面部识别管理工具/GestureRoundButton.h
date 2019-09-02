//
//  GestureRoundButton.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/14.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GestureRoundButton : UIView

@property (nonatomic,assign) BOOL  selected;
@property (nonatomic,assign) BOOL  success;
@property (nonatomic,assign) BOOL  thumb;

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
