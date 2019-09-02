//
//  CardCustomImageView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/7/17.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "CardCustomImageView.h"
#import "CHCardItemModel.h"
#import <CoreText/CoreText.h>
//#import "NSString+MD5.h"

@interface CardCustomImageView ()

@property (nonatomic, weak) UIImageView *imgView;

@end


@implementation CardCustomImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setItemModel:(CHCardItemModel *)itemModel {
    _itemModel = itemModel;
    
    if (itemModel.image_url) {
//        NSString *imagename = itemModel.imagename;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.image_url]];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _imgView = img;
        img.clipsToBounds = YES;
    }
    return _imgView;
}


@end
