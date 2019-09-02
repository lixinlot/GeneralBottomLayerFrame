//
//  VideoNewsTitleCell.m
//  RongMei
//
//  Created by jimmy on 2018/12/7.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "VideoNewsTitleCell.h"

@interface VideoNewsTitleCell()

@property (nonatomic,strong)  UILabel      * titleLabel;
@property (nonatomic,strong)  UIImageView  * timeImageV;
@property (nonatomic,strong)  UIImageView  * countImageV;
@property (nonatomic,strong)  UILabel      * timeLabel;
@property (nonatomic,strong)  UILabel      * countLabel;
@property (nonatomic,strong)  UILabel      * authorLabel;

@end


@implementation VideoNewsTitleCell

+ (VideoNewsTitleCell *)cellWithTableView:(UITableView *)tableView
{
    VideoNewsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoNewsTitleCell"];
    if (cell == nil) {
        cell = [[VideoNewsTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoNewsTitleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatChildView];
    }
    return cell;
}

- (void)setVideoTitleTextModel:(VideoTitleTextModel *)videoTitleTextModel
{
//    _videoTitleTextModel = videoTitleTextModel;
//    
//    CGSize titleSize = [HandelTool contentWithString:videoTitleTextModel.title withWidth:SCREEN_WIDTH-ScreenX375(40) withHeight:MAXFLOAT withFont:Mfont(17)];
//    CGSize timeSize = [HandelTool contentWithString:videoTitleTextModel.createTime withWidth:MAXFLOAT withHeight:ScreenX375(15) withFont:Rfont(12)];
//    self.titleLabel.frame = CGRectMake(Space20, ScreenX375(15),SCREEN_WIDTH-ScreenX375(40),titleSize.height);
//    self.timeImageV.frame = CGRectMake(ScreenX375(20), self.titleLabel.bottom+ScreenX375(6), ScreenX375(15), ScreenX375(15));
//    self.timeLabel.frame = CGRectMake(ScreenX375(40), self.titleLabel.bottom+ScreenX375(6),timeSize.width,ScreenX375(15));
//    self.countImageV.frame = CGRectMake(self.timeLabel.right+ScreenX375(20), self.titleLabel.bottom+ScreenX375(6), ScreenX375(15), ScreenX375(15));
//    self.countLabel.frame = CGRectMake(self.countImageV.right+ScreenX375(5), self.titleLabel.bottom+ScreenX375(6),ScreenX375(70),ScreenX375(15));
//    self.titleLabel.text = videoTitleTextModel.title;
//    self.timeLabel.text = videoTitleTextModel.createTime;//[HttpManager getTime:[HttpManager TimeStamp:videoTitleTextModel.createTime]];
//    self.countLabel.text = videoTitleTextModel.lookNum;
//    NSString *authorStr = @"";
//    if ([videoTitleTextModel.editor length] > 0) {
//        authorStr = [NSString stringWithFormat:@"责任编辑：%@  ",videoTitleTextModel.editor];
//    }
//    if ([videoTitleTextModel.author length] > 0) {
//        authorStr = [NSString stringWithFormat:@"%@作者：%@  ",authorStr,videoTitleTextModel.author];
//    }
//    self.authorLabel.text = authorStr;
//    self.authorLabel.frame = CGRectMake(ScreenX375(20), self.timeLabel.bottom+ScreenX375(4),ScreenX375(270),ScreenX375(19));
}

- (void)creatChildView
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(Space20, ScreenX375(15),SCREEN_WIDTH-ScreenX375(40),ScreenX375(50));
    self.titleLabel.text = @"无力的黎明，把夕阳的忧郁，倾洒在田野上面";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = REXADECIMALCOLOR(@"#212121");
    self.titleLabel.font = Mfont(17);
    [self addSubview:self.titleLabel];
    
    self.timeImageV = [[UIImageView alloc] init];
    self.timeImageV.frame = CGRectMake(ScreenX375(20), ScreenX375(73), ScreenX375(15), ScreenX375(15));
    self.timeImageV.image = [UIImage imageNamed:@"最近搜索"];
    [self addSubview:self.timeImageV];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.frame = CGRectMake(ScreenX375(40), ScreenX375(73), SCREEN_WIDTH-ScreenX375(70), ScreenX375(15));
    self.timeLabel.text = @"2018.12.12 15:21";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textColor = REXADECIMALCOLOR(@"#999999");
    self.timeLabel.font = Rfont(12);
    [self.timeLabel sizeToFit];
    [self addSubview:self.timeLabel];
    
    self.countImageV = [[UIImageView alloc] init];
    self.countImageV.frame = CGRectMake(self.timeLabel.right+ScreenX375(25), ScreenX375(73), ScreenX375(15), ScreenX375(15));
    self.countImageV.image = [UIImage imageNamed:@"直播未选"];
    [self addSubview:self.countImageV];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.text = @"59990";
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    self.countLabel.frame = CGRectMake(self.countImageV.right+ScreenX375(5), ScreenX375(73),ScreenX375(70),ScreenX375(15));
    self.countLabel.textColor = REXADECIMALCOLOR(@"#999999");
    self.countLabel.font = Rfont(12);
    [self addSubview:self.countLabel];
    
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.frame = CGRectMake(ScreenX375(20), self.timeLabel.bottom+ScreenX375(4),ScreenX375(270),ScreenX375(19));
    self.authorLabel.textColor = REXADECIMALCOLOR(@"#999999");
    self.authorLabel.font = Rfont(12);
    [self addSubview:self.authorLabel];
    
}



@end
