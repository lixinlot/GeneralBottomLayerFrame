//
//  ProgressSliderView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/21.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "ProgressSliderView.h"


@interface ProgressSliderView ()

@property (nonatomic, weak) UIImageView *bubbleImage;
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UILabel *levelLable;
@property (nonatomic, weak) UILabel *persentLable;
@property (nonatomic, weak) UIView *trackView;
@property (nonatomic, weak) UIImageView *thumb;

@end


@implementation ProgressSliderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _score = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        //气泡图片
        UIImageView *bubbleImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 70, 0, 74, 35)];
        bubbleImage.backgroundColor = [UIColor yellowColor];
//        [bubbleImage setImage:[UIImage imageNamed:@"alert_teacherEva_bubbleImage"]];
        [self addSubview:bubbleImage];
        _bubbleImage = bubbleImage;
        
        //分数标签
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 71.5, 0, 74, 28)];
        scoreLabel.text = @"10";
        scoreLabel.textColor = [UIColor blackColor];
        scoreLabel.font = [UIFont systemFontOfSize:15.f];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:scoreLabel];
        _scoreLabel = scoreLabel;
        
        //气泡箭头
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 16.5, 26, 13, 13)];
        [arrowImage setImage:[UIImage imageNamed:@"alert_teacherEva_arrowImage"]];
        [self addSubview:arrowImage];
        _arrowImage = arrowImage;
        
        //轨道可点击视图（轨道只设置了5pt，通过这个视图增加以下点击区域）
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, self.bounds.size.width, 20)];
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        [self addSubview:tapView];
        
        //轨道背景
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, self.bounds.size.width, 8)];
        backView.backgroundColor = [UIColor lightGrayColor];
        backView.layer.cornerRadius = 4.0f;
        backView.layer.masksToBounds = YES;
        [tapView addSubview:backView];
        
        //轨道前景
        UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(1.5, 9, self.bounds.size.width - 3, 5)];
        trackView.backgroundColor = [UIColor greenColor];
        trackView.layer.cornerRadius = 2.5f;
        trackView.layer.masksToBounds = YES;
        [tapView addSubview:trackView];
        _trackView = trackView;
        
        //滑块
        UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, 34, 40, 20)];
        thumb.backgroundColor = [UIColor redColor];
//        [thumb setImage:[UIImage imageNamed:@"alert_teacherEva_sliderImg"]];
        thumb.userInteractionEnabled = YES;
        thumb.contentMode = UIViewContentModeCenter;
        [thumb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
        [self addSubview:thumb];
        _thumb = thumb;
        
        //滑动位置百分比
        UILabel *persentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        persentLable.text = @"";
        persentLable.textColor = [UIColor blackColor];
        persentLable.font = [UIFont systemFontOfSize:10.f];
        persentLable.textAlignment = NSTextAlignmentCenter;
        [thumb addSubview:persentLable];
        _persentLable = persentLable;
        
        //级别标签
        UILabel *levelLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thumb.frame) + 7, self.bounds.size.width, 13)];
        levelLable.text = @"非常满意";
        levelLable.textColor = [UIColor blackColor];
        levelLable.font = [UIFont systemFontOfSize:13.f];
        levelLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:levelLable];
        _levelLable = levelLable;
    }
    
    return self;
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    //刷新视图
    [self reloadViewWithThumbCeneterX:score / 10.0 * self.bounds.size.width];
}

//点击滑动条
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    //刷新视图
    [self reloadViewWithThumbCeneterX:[sender locationInView:self].x];
}

//滑动滑块
- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    //获取偏移量
    CGFloat moveX = [sender translationInView:self].x;
    
    //重置偏移量，避免下次获取到的是原基础的增量
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    //计算当前中心值
    CGFloat centerX = _thumb.centerX + moveX;
    
    //防止瞬间大偏移量滑动影响显示效果
    if (centerX < 10) centerX = 10;
    if (centerX > self.bounds.size.width - 10) centerX = self.bounds.size.width - 10;
    
    //刷新视图
    [self reloadViewWithThumbCeneterX:centerX];
}

- (void)reloadViewWithThumbCeneterX:(CGFloat)thumbCeneterX
{
    //更新轨道前景色
    _trackView.width = thumbCeneterX;
    
    //更新滑块位置
    _thumb.centerX = thumbCeneterX;
    if (_thumb.centerX < 10) {
        _thumb.centerX = 10;
    }else if (_thumb.centerX > self.bounds.size.width - 10) {
        _thumb.centerX = self.bounds.size.width - 10;
    }
    
    //更新箭头位置
    _arrowImage.centerX = _thumb.centerX;
    
    //更新气泡标签位置（气泡图片宽度74，实际内容宽度66）
    _bubbleImage.centerX = _thumb.centerX;
    if (_bubbleImage.centerX < 33) {
        _bubbleImage.centerX = 33;
    }else if (_bubbleImage.centerX > self.bounds.size.width - 33) {
        _bubbleImage.centerX = self.bounds.size.width - 33;
    }
    
    //更新分数标签位置和百分比位置
    _scoreLabel.centerX = _bubbleImage.centerX;
    //分数，四舍五入取整
    _score = round(thumbCeneterX / self.bounds.size.width * 10);
    CGFloat persent = thumbCeneterX / self.bounds.size.width;
    //更新标签内容
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
    _persentLable.text = [[NSString stringWithFormat:@"%.2f", persent] stringByAppendingString:@"%"];
    if (_score <= 3) {
        _levelLable.text = @"极不满意";
    }else if (_score <= 5) {
        _levelLable.text = @"不满意";
    }else if (_score <= 7) {
        _levelLable.text = @"一般";
    }else if (_score <= 9) {
        _levelLable.text = @"满意";
    }else if (_score == 10) {
        _levelLable.text = @"非常满意";
    }
}


@end
