//
//  HomeVideoLittleCell.m
//  RongMei
//
//  Created by jimmy on 2019/3/18.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "HomeVideoLittleCell.h"

@interface HomeVideoLittleCell()

///置顶
@property (nonatomic,strong)  UILabel  * topLabel;
///来源
@property (nonatomic,strong)  UILabel  * sourceLabel;
///评论数
@property (nonatomic,strong)  UILabel  * commentCountLabel;
///视频
@property (nonatomic,strong)  UIImageView  * videoImage;
@property (nonatomic,strong)  UIImageView  * videoPlayButton;//UIButton

@end


@implementation HomeVideoLittleCell

+ (HomeVideoLittleCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"HomeVideoLittleCell";
    HomeVideoLittleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HomeVideoLittleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell createChildView];
    }
    return cell;
}


-(void)createChildView
{
    CGSize content = [HandelTools contentWithString:@"项城广播电视台家装节—为爱打造幸福家" withWidth:SCREEN_WIDTH-Space12*2 withHeight:MAXFLOAT withFont:Rfont(18)];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space12, Space12, SCREEN_WIDTH-ScreenX375(142), content.height)];
    self.contentLabel.text = @"项城广播电视台家装节—为爱打造幸福家";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = UIColorFromRGB(@"212121", 1);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.font = Rfont(18);
    [self addSubview:self.contentLabel];
    
    CGSize top = [HandelTools contentWithString:@"置顶" withWidth:MAXFLOAT withHeight:ScreenX375(22) withFont:Rfont(12)];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenX375(12), self.contentLabel.bottom+ScreenX375(8), top.width, ScreenX375(22))];
    self.topLabel.text = @"置顶";
    self.topLabel.textColor = UIColorFromRGB(@"#E31504", 1);
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = Rfont(12);
    self.topLabel.hidden = YES;
    [self addSubview:self.topLabel];
    
    CGSize source = [HandelTools contentWithString:@"科技网" withWidth:MAXFLOAT withHeight:ScreenX375(22) withFont:Rfont(12)];
    self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space12, self.contentLabel.bottom+ScreenX375(8), source.width+ScreenX375(15), ScreenX375(22))];
    self.sourceLabel.text = @"科技网";
    self.sourceLabel.textColor = UIColorFromRGB(@"#B8B8B8", 1);
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.font = Rfont(12);
    [self addSubview:self.sourceLabel];
    
    CGSize comment = [HandelTools contentWithString:@"1234评论" withWidth:MAXFLOAT withHeight:ScreenX375(22) withFont:Rfont(12)];
    self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sourceLabel.right+ScreenX375(12), self.contentLabel.bottom+ScreenX375(8), comment.width, ScreenX375(22))];
    self.commentCountLabel.text = @"1234评论";
    self.commentCountLabel.textColor = UIColorFromRGB(@"#B8B8B8", 1);
    self.commentCountLabel.textAlignment = NSTextAlignmentCenter;
    self.commentCountLabel.font = Rfont(12);
    [self addSubview:self.commentCountLabel];
   
    self.videoImage = [[UIImageView alloc] init];
    self.videoImage.frame = CGRectMake(SCREEN_WIDTH-ScreenX375(130), ScreenX375(12), ScreenX375(117), ScreenX375(73));
    self.videoImage.clipsToBounds = YES;
    self.videoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImage.userInteractionEnabled = YES;
    [self addSubview:self.videoImage];
    self.videoImage.hidden = YES;
    
    self.videoPlayButton = [[UIImageView alloc] init];
    self.videoPlayButton.frame = CGRectMake((ScreenX375(117)-ScreenX375(28))/2, (ScreenX375(73)-ScreenX375(28))/2, ScreenX375(28), ScreenX375(28));
    self.videoPlayButton.image = [UIImage imageNamed:@"视频播放"];
    self.videoPlayButton.contentMode = UIViewContentModeScaleAspectFill;
    self.videoPlayButton.userInteractionEnabled = YES;
    [self.videoImage addSubview:self.videoPlayButton];
    
    self.line = [[UIView alloc] init];
    self.line.frame = CGRectMake(0, ScreenX375(96.2), SCREEN_WIDTH, 0.8);
    self.line.backgroundColor = LineColor;
    [self addSubview:self.line];
}

@end
