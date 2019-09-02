//
//  LXProgressStepView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/26.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "LXProgressStepView.h"

static const float imgBtnWidth=18;

@interface LXProgressStepView ()

@property (nonatomic,strong) UIProgressView *progressView;

//用UIButton防止以后有点击事件
@property (nonatomic,strong) NSMutableArray *imgBtnArray;

@end

@implementation LXProgressStepView

+(instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray
{
    LXProgressStepView *stepProgressView=[[LXProgressStepView alloc]initWithFrame:frame];
    //进度条
    stepProgressView.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, 5)];
    stepProgressView.progressView.progressViewStyle=UIProgressViewStyleBar;
    stepProgressView.progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    stepProgressView.progressView.progressTintColor = [UIColor cyanColor];
    stepProgressView.progressView.trackTintColor=[UIColor lightGrayColor];
    stepProgressView.progressView.progress=0.5;
    [stepProgressView addSubview:stepProgressView.progressView];
    
    
    stepProgressView.imgBtnArray=[[NSMutableArray alloc]init];
    float _btnWidth=frame.size.width/(titleArray.count);
    for (int i=0; i<titleArray.count; i++) {
        //图片按钮
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
        btn.frame=CGRectMake(_btnWidth/2+_btnWidth*i-imgBtnWidth/2, -2, imgBtnWidth, imgBtnWidth);
        btn.selected=YES;
        
        [stepProgressView addSubview:btn];
        [stepProgressView.imgBtnArray addObject:btn];
        
        //文字
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn.center.x-_btnWidth/2, frame.size.height-20, _btnWidth, 20)];
        titleLabel.text=[titleArray objectAtIndex:i];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:15];
        [stepProgressView addSubview:titleLabel];
    }
    stepProgressView.stepIndex=-1;
    return stepProgressView;
    
}
-(void)setStepIndex:(NSInteger)stepIndex
{
    //  默认为－1 小于－1为－1 大于总数为总数
    stepIndex=stepIndex<-1?-1:stepIndex;
    _stepIndex = stepIndex >= (NSInteger)(_imgBtnArray.count-1) ? _imgBtnArray.count-1:stepIndex;
//    _stepIndex=stepIndex<-1?-1:stepIndex;
//    _stepIndex=stepIndex >=_imgBtnArray.count-1?_imgBtnArray.count-1:stepIndex;
    float _btnWidth=self.bounds.size.width/(_imgBtnArray.count);
    for (int i=0; i<_imgBtnArray.count; i++) {
        UIButton *btn=[_imgBtnArray objectAtIndex:i];
        if (i<=_stepIndex) {
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
    if (_stepIndex==-1) {
        self.progressView.progress=0.0;
    }else if (_stepIndex==_imgBtnArray.count-1){
        self.progressView.progress=1.0;
    }else{
        self.progressView.progress=(0.5+_stepIndex)*_btnWidth/self.frame.size.width;
    }
}


@end
