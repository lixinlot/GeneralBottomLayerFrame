//
//  YYLabelTextViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/12/3.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "YYLabelTextViewController.h"
#import <YYKit.h>

@interface YYLabelTextViewController ()

@end

@implementation YYLabelTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"YYKit之YYLabel排版"];
    [self setViewUI];
}

- (void)setViewUI
{
    NSString *title = @"It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。\n点击复制QQ450351763进行在线咨询";
    
    //    NSString *str = @"这是黑暗的季节";
    //    if ([title rangeOfString:str].location != NSNotFound) {
    //        NSLog(@"YES");
    //    }else{
    //        NSLog(@"NO");
    //    }
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 800);//SCREEN_HEIGHT*1.5
    textView.editable = NO;
    [self.view addSubview:textView];
    
    YYLabel *label = [YYLabel new];
    label.backgroundColor = [UIColor whiteColor];
    //异步显示
    label.displaysAsynchronously = YES;
    label.numberOfLines = 0;
    //创建容器
    YYTextContainer *titleContainer = [YYTextContainer new];
    //限制宽度
    titleContainer.size = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, CGFLOAT_MAX);
    //设置富文本
    NSMutableAttributedString *resultAttr = [self getAttr:title];
    //根据容器和文本创建布局对象
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContainer text:resultAttr];
    //得到文本高度CGFloat
    CGFloat titleLabelHeight = titleLayout.textBoundingSize.height;
    //设置frame
    label.frame= CGRectMake(0,0,SCREEN_WIDTH-20,titleLabelHeight);
    
    label.attributedText = resultAttr;
    
    [textView addSubview:label];
    
}

- (NSMutableAttributedString *)getAttr:(NSString*)attributedString
{
    NSMutableAttributedString *resultAtt = [[NSMutableAttributedString alloc]initWithString:attributedString];
    //    一、 格式设置//对齐方式 这里是 两边对齐
    resultAtt.alignment = NSTextAlignmentCenter;
    //设置行间距
    resultAtt.lineSpacing = 3;
    resultAtt.font = [UIFont systemFontOfSize:20];
    {
        NSRange range = [attributedString rangeOfString:@"it was the worst of times"];
        [resultAtt setFont:[UIFont boldSystemFontOfSize:30] range:range];
        
    }
    //描边
    {
        NSRange range = [attributedString rangeOfString:@"it was the age of wisdom"];
        //文字描边（空心字）默认黑色，必须设置width
        [resultAtt setStrokeColor:[UIColor orangeColor] range:range];
        [resultAtt setStrokeWidth:@(2) range:range];
        
    }
    //划线
    {
        NSRange range = [attributedString rangeOfString:@"it was the age of foolishness, it was the season of light" options:NSCaseInsensitiveSearch];
        YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1) color:[UIColor blueColor]];
        //删除样式
        [resultAtt setTextStrikethrough:decoration range:range];
        //下划线
        [resultAtt setTextUnderline:decoration range:range];
        
    }
    //设置边框
    {
        NSRange range = [attributedString rangeOfString:@"这是最好的时代，这是最坏的时代" options:NSCaseInsensitiveSearch];
        //边框
        YYTextBorder*border = [YYTextBorder new];
        border.strokeColor = [UIColor redColor];
        border.strokeWidth = 4;
        
        border.lineStyle = YYTextLineStylePatternDashDotDot;
        border.cornerRadius = 1;
        border.insets = UIEdgeInsetsMake(0, -2,0, -2);
        [resultAtt setTextBorder:border range:range];
        
    }
    //设置阴影
    {
        NSRange range = [attributedString rangeOfString:@"这是智慧的时代，这是愚蠢的时代" options:NSCaseInsensitiveSearch];
        //阴影
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowColor:[UIColor redColor]];
        [shadow setShadowBlurRadius:1.0];
        [shadow setShadowOffset:CGSizeMake(2,2)];
        [resultAtt setShadow:shadow range:range];
        
    }
    //高亮显示文本
    {
        NSRange range = [attributedString rangeOfString:@"这是希望之春，这是失望之冬" options:NSCaseInsensitiveSearch];//NSCaseInsensitiveSearch 不区分大小写
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius=50;
        border.insets = UIEdgeInsetsMake(0, -10,0, -10);
        border.strokeWidth = 0.5;
        border.strokeColor = [UIColor yellowColor];
        border.lineStyle = YYTextLineStyleSingle;
        [resultAtt setTextBorder:border range:range];
        [resultAtt setTextBackgroundBorder:border range:range];
        [resultAtt setColor:[UIColor greenColor] range:range];
        YYTextBorder *highlightBorder = border.copy;
        highlightBorder.strokeWidth = 0;
        highlightBorder.strokeColor = [UIColor purpleColor];
        highlightBorder.fillColor = [UIColor purpleColor];
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor whiteColor]];
        [highlight setBackgroundBorder:highlightBorder];
        highlight.tapAction=  ^(UIView*containerView,NSAttributedString*text, NSRange range, CGRect rect) {
            UIPasteboard *pboard=[UIPasteboard generalPasteboard];
            pboard.string = @"这是希望之春，这是失望之冬";
            //            [self alertShow:@"复制成功"];
            [self alertShow:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
        };
        
        [resultAtt setTextHighlight:highlight range:range];
        // 点击复制
        [resultAtt setTextHighlightRange:[attributedString rangeOfString:@"450351763"] color:[UIColor greenColor] backgroundColor:[UIColor whiteColor] tapAction:^(UIView*containerView,NSAttributedString*text, NSRange range, CGRect rect){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = @"450351763";
            [self alertShow:@"复制成功"];
            
        }];
        
    }
    // 图文混排
    {
        for(int i = 1; i < 13; i++) {
            NSString *path;
            //            if(i == 4){
            //                path = [[NSBundle mainBundle] pathForScaledResource:[NSString stringWithFormat:@"%d",i] ofType:@"gif"];
            //            }else{
            path = [[NSBundle mainBundle] pathForScaledResource:[NSString stringWithFormat:@"%d",i] ofType:@"jpg"];
            
            //            }
            NSData *data = [NSData dataWithContentsOfFile:path];
            //修改表情大小
            YYImage *image = [YYImage imageWithData:data scale:3];
            image.preloadAllAnimatedImageFrames = YES;
            YYAnimatedImageView*imageView = [[YYAnimatedImageView alloc] initWithImage:image];
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:18] alignment:YYTextVerticalAlignmentCenter];
            [resultAtt appendAttributedString:attachText];
        }
        
    }
    return resultAtt;
    
}

-(void)alertShow:(NSString*)str
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleActionSheet];
    [self.navigationController presentViewController:vc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:YES completion:^{}];
        });
    }];
}


@end
