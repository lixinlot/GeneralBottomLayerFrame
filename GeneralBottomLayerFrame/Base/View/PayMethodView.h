//
//  PayMethodView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodView : UIView

+(PayMethodView *)payMethodViewWithFrame:(CGRect)rect;
@property (nonatomic,strong)  void(^selectPayMethodBlock)(NSInteger methodIndexPath);
@property (nonatomic,strong)  void(^backBlock)(void);

@end
