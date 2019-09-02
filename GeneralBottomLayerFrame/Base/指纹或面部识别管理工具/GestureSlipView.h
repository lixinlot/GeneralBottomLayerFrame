//
//  GestureSlipView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/14.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GestureRoundButton;

NS_ASSUME_NONNULL_BEGIN

@protocol ResetGetureDelegate <NSObject>

- (BOOL)resetGeture:(NSString *)result;

@end

@protocol BeginTouchDelegate <NSObject>

- (void)beginTouch;

@end

@protocol VertifacationDelegate <NSObject>

- (BOOL)vertifate:(NSString *)result;

@end


@interface GestureSlipView : UIView

@property (nonatomic,strong)  NSArray<GestureRoundButton *>  * buttonArray;
@property (nonatomic,weak)   id<BeginTouchDelegate> beginTouchDelegate;
@property (nonatomic,weak)   id<ResetGetureDelegate> resetDelegate;
@property (nonatomic,weak)   id<VertifacationDelegate> vertifacationDelegate;
@property (nonatomic,assign) NSInteger style;

- (void)enterAgin;

@end

NS_ASSUME_NONNULL_END
