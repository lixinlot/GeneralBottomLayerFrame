//
//  FPCustomButton.m
//  ForestPack
//
//  Created by jimmy on 2018/7/6.
//  Copyright © 2018年 郑洲. All rights reserved.
//


#import "FPCustomButton.h"
#import "UIView+Utils.h"


#pragma mark - 这是自定义的图片在上边 文字在下边的按钮
@implementation FPCustomButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.top = 5;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.height * 0.35;
    // 设置标题位置
    self.titleLabel.top = self.imageView.bottom + 5;
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width * 0.5;
}

@end

#pragma mark - 这是自定义的文字在左边 图片在右边的按钮
@interface FPLeftRightButton()

@end

@implementation FPLeftRightButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置标题位置
    self.titleLabel.top = self.height * 0.5;
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = self.height * 0.5;
    
    // 设置图片位置
    self.imageView.top = 0;
    self.imageView.left = self.titleLabel.right + 5;
    self.imageView.centerY = self.height * 0.5;
}

@end


#pragma mark - 这是自定义的图片在左边 文字在右边的按钮
@interface FPRightLeftButton()

@end

@implementation FPRightLeftButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.top = 0;
    self.imageView.left = self.width * 0.275;
    self.imageView.centerY = self.height * 0.5;
    // 设置标题位置
    self.titleLabel.top = self.imageView.top;
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = self.height * 0.5;
    self.titleLabel.left = self.imageView.right + 5;
    
}

@end

