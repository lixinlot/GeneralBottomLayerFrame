//
//  GetWKWebViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/17.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "GetWKWebViewController.h"
#import "AFNetworking.h"
#import <WebKit/WebKit.h>

@interface GetWKWebViewController ()<WKUIDelegate, WKNavigationDelegate,UIWebViewDelegate>

@property (nonatomic,strong)  WKWebView  * oneWebView;

@end

@implementation GetWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self oneWebViewClick];
}

-(void)oneWebViewClick
{
    self.oneWebView = [[WKWebView alloc] init];
    self.oneWebView.tag = 1002;
    self.oneWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
    self.oneWebView.UIDelegate = self;
    self.oneWebView.navigationDelegate = self;
    self.oneWebView.scrollView.bounces = NO;
    
    NSString *str = @"1";
    if ([self.typeValue isEqualToString:@"1"]) {
        str = @"https://www.baidu.com/";
    }else if ([self.typeValue isEqualToString:@"2"]){
        str = @"http://www.cocoachina.com/";
    }else if ([self.typeValue isEqualToString:@"3"]){
        str = @"https://www.jianshu.com/p/e6b1d903c871";
    }else{
        str = @"https://blog.csdn.net/kurrygo/article/details/53408637m";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [self.oneWebView loadRequest:request];
    [self.view addSubview:self.oneWebView];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //NSURLRequest的一个属性，HTTPShouldHandleCookies，表示Http请求是否自动处理Cookie，默认值为YES。设置代表session保持/默认为YES
    [sessionManager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    //获取cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%@", cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    //注意：cookie不能直接转换为NSData类型，否则会引起崩溃。所以先进行归档处理，再转换为Data
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    //存储cookiesData
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:cookiesData forKey:@"cookie"];
    
    NSArray *unarchiverCookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault valueForKey:@"cookie"]];
    if (unarchiverCookies) {
        NSLog(@"有cookie");
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in unarchiverCookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        NSLog(@"无cookie");
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用1");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成之后调用1");
    //    [self hideLoadingView];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用失败");
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后调用1");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"在收到响应后，决定是否跳转%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}


@end


