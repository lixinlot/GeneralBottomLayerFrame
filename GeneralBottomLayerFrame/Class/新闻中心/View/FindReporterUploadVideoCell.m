//
//  FindReporterUploadVideoCell.m
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "FindReporterUploadVideoCell.h"

@interface FindReporterUploadVideoCell ()

@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UIImageView * picsImage;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * videoPlayBtn;

@end


@implementation FindReporterUploadVideoCell

+ (FindReporterUploadVideoCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"FindReporterUploadVideoCell";
    FindReporterUploadVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindReporterUploadVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI
{
    CGRect picsImage_frame = CGRectMake(20, 40, SCREEN_WIDTH-40, 191);
    self.picsImage = [[UIImageView alloc] initWithFrame:picsImage_frame];
    self.picsImage.image = ImageWithName(@"上传视频:图片");
    self.picsImage.userInteractionEnabled = YES;
    self.picsImage.layer.masksToBounds = YES;
    self.picsImage.layer.cornerRadius = ScreenX375(4);
    self.picsImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.picsImage];
    
    CGRect selectBtn_frame = CGRectMake(20, 40, SCREEN_WIDTH-40, 191);
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = selectBtn_frame;
    [self.selectBtn addTarget:self action:@selector(addbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    
    self.videoPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.selectBtn.size.width-ScreenX375(50))/2, (self.selectBtn.size.height-ScreenX375(40))/2, ScreenX375(50), ScreenX375(40))];
    [self.videoPlayBtn setImage:ImageWithName(@"视频播放") forState:UIControlStateNormal];
    self.videoPlayBtn.hidden = YES;
    [self.videoPlayBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
//    [self.selectBtn addSubview:self.videoPlayBtn];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(0, 270, SCREEN_WIDTH, 1);
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self addSubview:self.lineView];
}

- (void)addbtnClick
{
    if (self.selectVideoOrPicBlock) {
        self.selectVideoOrPicBlock();
    }
}

- (void)setImageWith:(id )imageData
{
    if ([imageData isKindOfClass:[UIImage class]]) {
        self.picsImage.image = imageData;
    }else if ([imageData isKindOfClass:[NSData class]]){
        self.picsImage.image = [UIImage imageWithData:imageData];
    }else if ([imageData isKindOfClass:[NSString class]]){
        [self.picsImage sd_setImageWithURL:[NSURL URLWithString:imageData]];
    }
}

@end
