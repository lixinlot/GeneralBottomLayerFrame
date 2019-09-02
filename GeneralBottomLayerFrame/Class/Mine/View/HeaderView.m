//
//  HeaderView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HeaderView.h"
#import "FPCustomButton.h"

@implementation HeaderView

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{
    NSLog(@"26-----------");
    //构建头部视图容器
    self.headTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    self.headTopView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.headTopView];
    
    FPCustomButton* scanBtn = [FPCustomButton buttonWithType:UIButtonTypeCustom];
    scanBtn.frame = CGRectMake((SCREEN_WIDTH - 320)/5, 7.5, 80, 80);
    [scanBtn setImage:[UIImage imageNamed:@"扫一扫大"] forState:UIControlStateNormal];
    [scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headTopView addSubview:scanBtn];
    
    FPCustomButton* payBtn = [FPCustomButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake((SCREEN_WIDTH - 320)/5*2+80, 7.5, 80, 80);
    [payBtn setImage:[UIImage imageNamed:@"支付大"] forState:UIControlStateNormal];
    [payBtn setTitle:@"付钱" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headTopView addSubview:payBtn];
    
    FPCustomButton* getMBtn = [FPCustomButton buttonWithType:UIButtonTypeCustom];
    getMBtn.frame = CGRectMake((SCREEN_WIDTH - 320)/5*3+160, 7.5, 80, 80);
    [getMBtn setImage:[UIImage imageNamed:@"收钱"] forState:UIControlStateNormal];
    [getMBtn setTitle:@"收钱" forState:UIControlStateNormal];
    [getMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headTopView addSubview:getMBtn];
    
    FPCustomButton* cardBtn = [FPCustomButton buttonWithType:UIButtonTypeCustom];
    cardBtn.frame = CGRectMake((SCREEN_WIDTH - 320)/5*3+240, 7.5, 80, 80);
    [cardBtn setImage:[UIImage imageNamed:@"卡片"] forState:UIControlStateNormal];
    [cardBtn setTitle:@"卡包" forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headTopView addSubview:cardBtn];
  
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, 240) collectionViewLayout:layout];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self.menuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self addSubview:self.menuView];
    
}

-(void)changAlpha:(CGFloat)alpha
{
    self.headTopView.alpha = alpha;
}

//实现协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 100) / 4;
    return CGSizeMake(width, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

@end
