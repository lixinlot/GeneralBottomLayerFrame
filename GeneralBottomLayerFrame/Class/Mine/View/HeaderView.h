//
//  HeaderView.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIView           * headTopView;
@property(nonatomic,strong) UICollectionView * menuView;


-(void)changAlpha:(CGFloat)alpha;

@end
