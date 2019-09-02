//
//  OtherViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/16.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "OtherViewController.h"
#import <WebKit/WebKit.h>
#import "HCSStarRatingView.h"
#import "KYGooeyMenu.h"

@interface OtherViewController ()<WKUIDelegate, WKNavigationDelegate,UIWebViewDelegate,menuDidSelectedDelegate>

@property (nonatomic,strong)  WKWebView  * webView;
@property (nonatomic,assign)  CGFloat      webHeight;

@end

@implementation OtherViewController{
    KYGooeyMenu *gooeyMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setStr];
    [self setViewUI];
}

#pragma mark - 设置快递单号查询UI
- (void)setViewUI
{
    HCSStarRatingView *starRatingView = [HCSStarRatingView new];
    starRatingView.maximumValue = 6;
    starRatingView.minimumValue = 0;
    starRatingView.value = 3.5;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.emptyStarImage = [[UIImage imageNamed:@"heart-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    starRatingView.filledStarImage = [[UIImage imageNamed:@"heart-full"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    
    starRatingView.frame = CGRectMake(0, 100, 200, 100);
    
    gooeyMenu = [[KYGooeyMenu alloc] initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 500) andDiameter:100.0f andSuperView:self.view themeColor:[UIColor redColor]];
    gooeyMenu.menuDelegate = self;
    gooeyMenu.radius = 100/5;//大圆的1/4
    gooeyMenu.extraDistance = 20;
    gooeyMenu.MenuCount = 5;
    gooeyMenu.menuImagesArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"tabbarItem_discover highlighted"],[UIImage imageNamed:@"tabbarItem_group highlighted"],[UIImage imageNamed:@"tabbarItem_home highlighted"],[UIImage imageNamed:@"tabbarItem_message highlighted"],[UIImage imageNamed:@"tabbarItem_user_man_highlighted"], nil];
    
}

- (void)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    
    
}

#pragma mark -- 菜单选中的代理方法
-(void)menuDidSelected:(int)index{
    NSLog(@"选中第%d",index);
    switch (index) {
        case 0:{
            
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            
        }
            break;
        case 4:{
            
        }
            break;
            
        default:
            break;
    }
}

-(void)setStr
{
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.webView = YES;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    [self.webView.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.webView];
    //str为我们取出的html数据
    NSString * str = @"&lt;/p&gt;img src= http://tqwconsoleimg.oss-cn-shanghai.aliyuncs.com/d432f8e2-8f47-4e6d-af6c-c683ce5d2cd6.jpg;纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计v纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计纸板数码印刷设计&lt;/p&gt;";//&lt;p&gt;

    //将str转换成标准的html数据
    str = [self htmlEntityDecode:str];
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:%dpx;}\n"// 字体大小，px是像素
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"// 图片宽度
                            "$img[p].style.height ='auto'\n"// 高度自适应
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",50,str];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    self.webHeight = fittingSize.height;
    NSLog(@"******************webView的高度是：%lf******************",self.webHeight);
    if (fittingSize.width > SCREEN_WIDTH) {
        CGSize fittingSize = [webView systemLayoutSizeFittingSize:CGSizeZero];
        self.webHeight = fittingSize.height;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT_LOAD" object:nil userInfo:nil];
    }else{
        webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
        if (_returnHeightBlock) {
            _returnHeightBlock(self.webHeight);
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:@{@"height":[NSString stringWithFormat:@"%f",self.webHeight]} userInfo:nil];
    }
}


@end
