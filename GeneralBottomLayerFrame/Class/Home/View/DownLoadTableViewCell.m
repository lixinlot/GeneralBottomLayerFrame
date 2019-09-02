//
//  DownLoadTableViewCell.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/27.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "DownLoadTableViewCell.h"

@interface DownLoadTableViewCell()

@property (nonatomic,strong)  UIProgressView  * progressView;
@property (nonatomic,strong)  UILabel         * progressLabel;
@property (nonatomic,strong)  UIButton        * downloadButton;

@end

@implementation DownLoadTableViewCell

+ (DownLoadTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownLoadCell"];
    if (!cell) {
        cell = [[DownLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownLoadCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell createView];
    }
    return cell;
}

- (void)createView
{
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.frame = CGRectMake(0, ScreenX375(50), ScreenX375(60), ScreenX375(20));
    [self.downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downloadButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.downloadButton addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.downloadButton];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(ScreenX375(60), ScreenX375(60), SCREEN_WIDTH-ScreenX375(110), ScreenX375(20))];
    self.progressView.tintColor = [UIColor blueColor];//UIColorFromRGB(@"#0C234F", 1);
    [self addSubview:self.progressView];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ScreenX375(50), ScreenX375(50), ScreenX375(50), ScreenX375(20))];
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.progressLabel];
    
}

- (void)setProgressLabelText:(CGFloat )text
{
    self.progressView.progress = text;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", text * 100];
}

- (void)operationClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected == YES) {//[button.titleLabel.text isEqualToString:@"开始"]
        if (self.beginBlock) {
            self.beginBlock(self.progressLabel,self.progressView);
        }
        [self.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        if (self.resumeBlock) {
            self.resumeBlock(self.progressLabel,self.progressView);
        }
        [self.downloadButton setTitle:@"开始" forState:UIControlStateNormal];
    }
}

@end
