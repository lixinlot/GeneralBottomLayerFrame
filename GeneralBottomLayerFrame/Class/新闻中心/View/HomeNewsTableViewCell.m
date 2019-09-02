//
//  HomeNewsTableViewCell.m
//  RongMei
//
//  Created by jimmy on 2018/12/5.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HomeNewsTableViewCell.h"

@interface HomeNewsTableViewCell()

///置顶
@property (nonatomic,strong)  UILabel  * topLabel;
///来源
@property (nonatomic,strong)  UILabel  * sourceLabel;
///评论数
//@property (nonatomic,strong)  UILabel  * commentCountLabel;
///图片
@property (nonatomic,strong)  UIImageView  * contentImage;
///视频
@property (nonatomic,strong)  UIImageView  * videoImage;
@property (nonatomic,strong)  UIView  * imageBjView;
@property (nonatomic,strong)  UIImageView  * videoPlayButton;//UIButton

@end

@implementation HomeNewsTableViewCell

+ (HomeNewsTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"HomeNewsTableViewCell";
    HomeNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HomeNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell createChildView];
    }
    return cell;
}

- (void)setAllModel:(HomeNewsAllModel *)allModel
{
    _allModel = allModel;
    
    NSArray *picsUrls = [NSArray array];
        
    self.contentLabel.text = allModel.homeNewsListModel.title;
    self.sourceLabel.text = [NSString stringWithFormat:@"%@ %@",allModel.homeNewsListModel.author_name,allModel.homeNewsListModel.date];
    
    CGSize content = [HandelTools contentWithString:allModel.homeNewsListModel.title withWidth:SCREEN_WIDTH-12*2 withHeight:MAXFLOAT withFont:Rfont(18)];
    
    if (allModel.type == 0) {//0是没有图片
        self.contentImage.hidden = YES;
        self.imageBjView.hidden = YES;
        self.videoImage.hidden = YES;
        self.contentLabel.frame = CGRectMake(Space12, Space12, SCREEN_WIDTH-Space12*2, ScreenX375(22));
        self.sourceLabel.frame = CGRectMake(Space12, self.contentLabel.bottom+ScreenX375(8), SCREEN_WIDTH-ScreenX375(24), ScreenX375(22));
        self.line.frame = CGRectMake(Space12, ScreenX375(69.2), SCREEN_WIDTH-2*Space12, 0.8);
    }else if (allModel.type == 1) {//1是只有一张图片
        picsUrls = @[allModel.homeNewsListModel.thumbnail_pic_s];
        self.contentImage.hidden = NO;
        self.imageBjView.hidden = YES;
        self.videoImage.hidden = YES;
        [self.contentImage sd_setImageWithURL:[NSURL URLWithString:picsUrls[0]]];
        CGSize content = [HandelTools contentWithString:allModel.homeNewsListModel.title withWidth:SCREEN_WIDTH-Space12*2-ScreenX375(117)-ScreenX375(8) withHeight:MAXFLOAT withFont:Rfont(18)];
        if (content.height>ScreenX375(48)) {
            self.contentLabel.frame = CGRectMake(Space12, ScreenX375(6), SCREEN_WIDTH-Space12*2-ScreenX375(117)-ScreenX375(8), ScreenX375(55));
        }else {
            self.contentLabel.frame = CGRectMake(Space12, Space12, SCREEN_WIDTH-Space12*2-ScreenX375(117)-ScreenX375(8), content.height);
        }
        self.sourceLabel.frame = CGRectMake(Space12, self.contentLabel.bottom+ScreenX375(8), SCREEN_WIDTH-ScreenX375(24), ScreenX375(22));
        
        self.line.frame = CGRectMake(Space12, ScreenX375(99.2), SCREEN_WIDTH-2*Space12, 0.8);
    }else {//2是有三张图片
        picsUrls = @[allModel.homeNewsListModel.thumbnail_pic_s,allModel.homeNewsListModel.thumbnail_pic_s02,allModel.homeNewsListModel.thumbnail_pic_s03];
        self.contentImage.hidden = YES;
        self.imageBjView.hidden = NO;
        self.videoImage.hidden = YES;
        content = [HandelTools contentWithString:allModel.homeNewsListModel.title withWidth:SCREEN_WIDTH-Space12*2 withHeight:MAXFLOAT withFont:Rfont(18)];
        if (content.height>ScreenX375(48)) {
            self.contentLabel.frame = CGRectMake(Space12, ScreenX375(6), SCREEN_WIDTH-Space12*2, ScreenX375(55));
            self.line.frame = CGRectMake(Space12, ScreenX375(174.2), SCREEN_WIDTH-Space12*2, 0.8);
        }else {
            self.contentLabel.frame = CGRectMake(Space12, Space12, SCREEN_WIDTH-Space12*2, content.height);
            self.line.frame = CGRectMake(Space12, ScreenX375(154.2), SCREEN_WIDTH-Space12*2, 0.8);
        }
        self.imageBjView.frame = CGRectMake(0, self.contentLabel.bottom+ScreenX375(8), SCREEN_WIDTH, ScreenX375(73));
        self.sourceLabel.frame = CGRectMake(Space12, self.imageBjView.bottom+ScreenX375(8), SCREEN_WIDTH-ScreenX375(24), ScreenX375(22));
        
        NSMutableArray *array = [NSMutableArray array];
        for (UIImageView *imageV in self.imageBjView.subviews) {
            [array addObject:imageV];
        }
        for (int i = 0; i < 3; i++) {
            UIImageView *imageV = array[i];
            [imageV sd_setImageWithURL:[NSURL URLWithString:picsUrls[i]]];
        }
    }
}

- (void)matchKeyWordsWith:(NSString *)keyWord
{
    if (self.keyWords) {
        if ([keyWord containsString:self.keyWords]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:keyWord];
            NSRange range = NSMakeRange([[attributedString string] rangeOfString:self.keyWords].location, self.keyWords.length);
            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(@"#FF6103", 1) range:range];
            [self.contentLabel setAttributedText:attributedString];
        }
    }
}

 -(void)createChildView
{
    CGSize content = [HandelTools contentWithString:@"项城广播电视台家装节—为爱打造幸福家" withWidth:SCREEN_WIDTH-Space12*2 withHeight:MAXFLOAT withFont:Rfont(18)];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space12, Space12, SCREEN_WIDTH-Space12*2, content.height)];
    self.contentLabel.text = @"项城广播电视台家装节—为爱打造幸福家";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = UIColorFromRGB(@"212121", 1);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.font = Rfont(18);
    [self addSubview:self.contentLabel];
    
    self.imageBjView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentLabel.bottom+ScreenX375(8), SCREEN_WIDTH, ScreenX375(73))];
    self.imageBjView.hidden = YES;
    [self addSubview:self.imageBjView];
    
    for (int i = 0; i < 3; i++) {
        CGFloat width = (SCREEN_WIDTH-Space12*2-6)/3;
        UIImageView * moreContentImage = [[UIImageView alloc] init];
        moreContentImage.tag = 100+i;
        if (i == 0) {
            moreContentImage.frame = CGRectMake(Space12, 0, width, ScreenX375(73));
        }else if (i == 1){
            moreContentImage.frame = CGRectMake(Space12+width+ScreenX375(3), 0, width, ScreenX375(73));
        }else{
            moreContentImage.frame = CGRectMake(SCREEN_WIDTH-width-Space12, 0, width, ScreenX375(73));
        }
        moreContentImage.clipsToBounds = YES;
        moreContentImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageBjView addSubview:moreContentImage];
//        moreContentImage.hidden = YES;
    }
    
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
    self.sourceLabel.textAlignment = NSTextAlignmentLeft;
    self.sourceLabel.font = Rfont(12);
    [self addSubview:self.sourceLabel];
    
    self.contentImage = [[UIImageView alloc] init];
    self.contentImage.frame = CGRectMake(SCREEN_WIDTH-Space12-ScreenX375(117), Space12, ScreenX375(117), ScreenX375(73));
    self.contentImage.clipsToBounds = YES;
    self.contentImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.contentImage];
    self.contentImage.hidden = YES;
    
    self.videoImage = [[UIImageView alloc] init];
    self.videoImage.frame = CGRectMake(12, self.contentLabel.bottom+ScreenX375(23), SCREEN_WIDTH-2*ScreenX375(12), ScreenX375(180));
    self.videoImage.clipsToBounds = YES;
    self.videoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImage.userInteractionEnabled = YES;
    [self addSubview:self.videoImage];
    self.videoImage.hidden = YES;
    
    self.videoPlayButton = [[UIImageView alloc] init];
    self.videoPlayButton.frame = CGRectMake((self.videoImage.width-ScreenX375(56))/2, (self.videoImage.height-56)/2, ScreenX375(56), ScreenX375(56));
    self.videoPlayButton.image = [UIImage imageNamed:@"视频播放"];
    self.videoPlayButton.contentMode = UIViewContentModeScaleAspectFill;
    self.videoPlayButton.userInteractionEnabled = YES;
    [self.videoImage addSubview:self.videoPlayButton];
    
    self.line = [[UIView alloc] init];
    self.line.frame = CGRectMake(0, ScreenX375(99.2), SCREEN_WIDTH, 0.8);
    self.line.backgroundColor = LineColor;
    [self addSubview:self.line];
}

- (void)notAllowContentHaveRows
{
    self.contentLabel.numberOfLines = 1;
}


@end
