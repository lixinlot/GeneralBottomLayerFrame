//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()

//@property (nonatomic, weak) UILabel *label;

@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = self.borderWidth;
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.borderColor = self.borderColor.CGColor;
        [self addLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = self.borderWidth;
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.borderColor = self.borderColor.CGColor;
        [self addLabel];
    }
    return self;
}


- (void)addLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.width-40, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    _acountLabel = label;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((self.width)/2-50, label.bottom+30, 100, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = 10;
    label1.backgroundColor = [UIColor blackColor];
    [self addSubview:label1];
    _seeDetailLabel = label1;
    label1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeDetailClick)];
    [label1 addGestureRecognizer:tap];
}

- (void)seeDetailClick {
    if (_seeDetailBlock) {
        _seeDetailBlock();
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _acountLabel.frame = self.bounds;
//}

@end
