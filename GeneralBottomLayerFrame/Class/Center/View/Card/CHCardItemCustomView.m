//
//  CHCardItemCustomView.m
//  CHCardView
//
//  Created by yaoxin on 16/10/9.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "CHCardItemCustomView.h"
#import "CHCardItemModel.h"
//#import "<UIImageView+WebCache.h>"
#import <CoreText/CoreText.h>

@interface CHCardItemCustomView ()
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIButton *concernBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation CHCardItemCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setItemModel:(CHCardItemModel *)itemModel
{
    _itemModel = itemModel;
//    if (_itemModel.proId) {
        [self.headView sd_setImageWithURL:[NSURL URLWithString:[_itemModel valueForKey:@"userPic"]] placeholderImage:nil options:SDWebImageRetryFailed];
        self.nameLabel.text = [_itemModel valueForKey:@"nickName"];
        self.noteLabel.text = [_itemModel valueForKey:@"userIntro"];
        self.titleLabel.text = [_itemModel valueForKey:@"proName"];
//        if ([_itemModel.isFollow integerValue]) {
//            [self.concernBtn setTitle:@"已关注" forState:UIControlStateNormal];
//            [self.concernBtn setTitleColor:REXADECIMALCOLOR(@"#212121") forState:UIControlStateNormal];
//            [self.concernBtn setImage:nil forState:UIControlStateNormal];
//        }else {
//            [self.concernBtn setTitle:@" 关注" forState:UIControlStateNormal];
//            [self.concernBtn setTitleColor:REXADECIMALCOLOR(@"#ff2469") forState:UIControlStateNormal];
//            [self.concernBtn setImage:ImageWithName(@"添加关注") forState:UIControlStateNormal];
//        }
        self.detailLabel.text = [_itemModel valueForKey:@"designIdea"];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[_itemModel valueForKey:@"proPic"]] placeholderImage:nil options:SDWebImageRetryFailed];
        self.numLabel.text = [NSString stringWithFormat:@"作品数 %@  |  粉丝数 %@",[_itemModel valueForKey:@"proNum"],[_itemModel valueForKey:@"fensNum"]];
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.headView.frame = CGRectMake(ScreenX375(12), ScreenX375(14), ScreenX375(37), ScreenX375(37));
    self.nameLabel.frame = CGRectMake(ScreenX375(59), ScreenX375(16), ScreenX375(150), ScreenX375(16));
    self.noteLabel.frame = CGRectMake(ScreenX375(59), ScreenX375(36), ScreenX375(150), ScreenX375(14));
    self.concernBtn.frame = CGRectMake(ScreenX375(249), ScreenX375(25), ScreenX375(74), ScreenX375(26));
    self.imgView.frame = CGRectMake(ScreenX375(12), ScreenX375(92), SCREEN_WIDTH - ScreenX375(62), ScreenX375(300));
    self.titleLabel.frame = CGRectMake(ScreenX375(12), ScreenX375(72), SCREEN_WIDTH - ScreenX375(62), ScreenX375(17));
    self.numLabel.frame = CGRectMake(ScreenX375(27), ScreenX375(364), ScreenX375(197), ScreenX375(26));
//    self.detailLabel.frame = CGRectMake(ScreenX375(12), ScreenX375(443), SCREEN_WIDTH - ScreenX375(62), ScreenX375(40));
    
    UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenX375(12), ScreenX375(418), ScreenX375(100), ScreenX375(18))];
//    noteL.text = @"设计理念";
    noteL.textColor = REXADECIMALCOLOR(@"#333333");
    noteL.font = Kfont(16);
    [self addSubview:noteL];
}

- (UIImageView *)headView
{
    if (!_headView) {
        UIImageView *headView = [[UIImageView alloc] init];
        headView.layer.cornerRadius = ScreenX375(18.5);
        headView.clipsToBounds = YES;
        [self addSubview:headView];
        _headView = headView;
    }
    return _headView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = REXADECIMALCOLOR(@"#212121");
        label.font = KBlodfont(14);
        [self addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)noteLabel
{
    if (!_noteLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = REXADECIMALCOLOR(@"#888888");
        label.font = KBlodfont(12);
        [self addSubview:label];
        _noteLabel = label;
    }
    return _noteLabel;
}

- (UIButton *)concernBtn
{
    if (!_concernBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:ImageWithName(@"添加关注") forState:UIControlStateNormal];
        [button setTitle:@" 关注" forState:UIControlStateNormal];
        button.titleLabel.font = Kfont(14);
        [button setTitleColor:REXADECIMALCOLOR(@"#ff2469") forState:UIControlStateNormal];
        button.layer.cornerRadius = ScreenX375(13);
        button.layer.borderWidth = 1;
        button.layer.borderColor = REXADECIMALCOLOR(@"#eaeaea").CGColor;
        [self addSubview:button];
        _concernBtn = button;
    }
    return _concernBtn;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *img = [[UIImageView alloc] init];
        img.layer.cornerRadius = ScreenX375(6);
        img.clipsToBounds = YES;
        [self addSubview:img];
        _imgView = img;
        img.clipsToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = RGBACOLOR(255, 255, 255, 0.8);
        label.layer.cornerRadius = ScreenX375(13);
        label.clipsToBounds = YES;
        label.font = Kfont(13);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _numLabel = label;
    }
    return _numLabel;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = REXADECIMALCOLOR(@"#212121");
        label.font = Kfont(15);
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = FONTCOLOR_GRAY;
        label.font = Kfont(14);
        label.numberOfLines = 0;
        [self addSubview:label];
        _detailLabel = label;
    }
    return _detailLabel;
}

@end
