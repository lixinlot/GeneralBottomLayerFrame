//
//  HomeNewsDetailViewController.m
//  RongMei
//
//  Created by 郑洲 on 2018/12/18.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HomeNewsDetailViewController.h"
#import <WebKit/WebKit.h>

@interface HomeNewsDetailViewController ()<UIWebViewDelegate ,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)  CGFloat   webViewHeight;//webView Cell的高度

@property (nonatomic,strong)  UIWebView      * webView;

@property (nonatomic,strong)  BaseTableView  * tableView;

///标题
@property (nonatomic,strong)  UILabel  * titleLabel;
///来源
@property (nonatomic,strong)  UILabel  * sourceLabel;
///时间
@property (nonatomic,strong)  UILabel  * timeLabel;
///作者
@property (nonatomic,strong)  UILabel  * authorLabel;
///内容
@property (nonatomic, copy)  NSString  * contentStr;


@end

@implementation HomeNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setTableViewUI];
//    self.webViewHeight = 100;
    
    [self setWebView];
    
    [self setNavigationRightBarButtonWithImage:ImageWithName(@"更多") withTitle:nil withTitleColor:nil withTitleFont:nil withButtonFrame:CGRectMake(0, 0, 44, 44) withSelector:@selector(reportPost) withTarget:self];
}

- (void)setWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    webView.delegate = self;
    
    NSString *link = self.allModel.homeNewsListModel.url;
    link = [link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}

- (void)reportPost
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择举报理由" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancel setValue:UIColorFromRGB(@"999999", 1) forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    
    NSArray *reportArr = @[@"色情、暴力、赌博",@"敏感信息",@"民族、宗教歧视",@"恶意广告",@"谣言",@"人身攻击"];
    for (int i = 0; i < reportArr.count; i++) {
        NSString *reportString = reportArr[i];
        UIAlertAction *one = [UIAlertAction actionWithTitle:reportString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//@"色情，暴力，赌博"
            [HttpManager showNoteMsg:@"您已举报成功，我们将快速处理"];
        }];
        [alert addAction:one];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

//#pragma mark- 设置tableView
//- (void)setTableViewUI
//{
//    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-ScreenX375(54)-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//}
//
//- (NSString *)getWithString:(NSString *)string
//{
//    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
//                                                                                    options:0
//                                                                                      error:nil];
//    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
//    return string;
//}
//
//#pragma mark- 实现TableView的代理和数据源
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//}
//
//- (CGSize)contentWithString:(NSString *)string
//{
//    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenX375(22)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(15)} context:nil].size;
//
//    return size;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize title = [HandelTools contentWithString:self.allModel.homeNewsListModel.title withWidth:SCREEN_WIDTH-Space20*2 withHeight:MAXFLOAT withFont:Mfont(24)];
//    return self.webViewHeight+title.height+ScreenX375(10)+ScreenX375(8)+ScreenX375(10)+ScreenX375(22);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//        for (UIView *subViews in cell.subviews) {
//            [subViews removeFromSuperview];
//        }
//
//        CGSize title = [HandelTools contentWithString:self.allModel.homeNewsListModel.title withWidth:SCREEN_WIDTH-Space20*2 withHeight:MAXFLOAT withFont:Mfont(24)];
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space20, ScreenX375(10), SCREEN_WIDTH-Space20*2, title.height)];
//        self.titleLabel.text = self.allModel.homeNewsListModel.title;
//        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.textColor = UIColorFromRGB(@"212121", 1);
//        self.titleLabel.font = Mfont(24);
//        [cell addSubview:self.titleLabel];
//
//        self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space20, title.height+ScreenX375(8), SCREEN_WIDTH-ScreenX375(40), ScreenX375(22))];
//        self.sourceLabel.text = [NSString stringWithFormat:@"%@ %@",self.allModel.homeNewsListModel.author_name,self.allModel.homeNewsListModel.date];
//        self.sourceLabel.textColor = UIColorFromRGB(@"999999", 1);
//        self.sourceLabel.textAlignment = NSTextAlignmentLeft;
//        self.sourceLabel.font = Rfont(15);
//        [cell addSubview:self.sourceLabel];
//
//        return cell;
//    }else {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"webCell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//        for (UIView *subViews in cell.subviews) {
//            [subViews removeFromSuperview];
//        }
//
//        if (!self.webView) {
//            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenX375(10), 0, SCREEN_WIDTH-ScreenX375(20), self.webViewHeight)];
//            self.webView.backgroundColor = [UIColor whiteColor];
//            self.webView.scrollView.scrollEnabled = NO;
//            self.webView.delegate = self;
//            self.webView.mediaPlaybackRequiresUserAction = NO;
//            self.webView.allowsInlineMediaPlayback = YES;
//            if (IS_PhoneXAll) {
//                if (@available(iOS 11.0, *)) {
//                    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//                }else {// Fallback on earlier versions
//                    self.automaticallyAdjustsScrollViewInsets = NO;
//                }
//            }
////            NSString *result = [NSString stringWithFormat:@"<%@ %@",@"img",@"style='display: block; max-width: 100%;'"];
////            NSString*contentStr = self.allModel.homeNewsListModel.url;
//            self.webView.mediaPlaybackRequiresUserAction = NO;
//            self.webView.allowsInlineMediaPlayback=YES;
//            NSString *link = self.allModel.homeNewsListModel.url;
//            link = [link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
//            [self.webView loadRequest:request];
//
////            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<img" withString:result];
////            [self.webView loadHTMLString:contentStr baseURL:nil];
//            [self.webView setBackgroundColor:[UIColor clearColor]];
//            [self.webView setOpaque:NO];
//        }
//        [cell addSubview:self.webView];
//        return cell;
//    }
//}
//
//#pragma mark - webviewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [HttpManager showWait];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [HttpManager hideWait];
//    NSString *js = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
//    js = [NSString stringWithFormat:js, SCREEN_WIDTH-ScreenX375(40)];
//
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
//
//    CGFloat htmlheight = self.webView.scrollView.contentSize.height;
//    if (self.webView.scrollView.contentSize.width > 0) {
//        htmlheight = htmlheight * (SCREEN_WIDTH-ScreenX375(20)) /self.webView.scrollView.contentSize.width;
//    }
//    if (self.webViewHeight != htmlheight) {
//        self.webViewHeight = htmlheight;
//        self.webView.frame = CGRectMake(ScreenX375(10), 0, SCREEN_WIDTH-ScreenX375(20), self.webViewHeight);
//        [self.tableView reloadData];
//    }else{
//        self.webView.frame = CGRectMake(ScreenX375(10), 0, SCREEN_WIDTH-ScreenX375(20), self.webViewHeight);
//        [self.tableView reloadData];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat htmlheight = self.webView.scrollView.contentSize.height;
//    if (self.webView.scrollView.contentSize.width > 0) {
//        htmlheight = htmlheight * (SCREEN_WIDTH-ScreenX375(20)) /self.webView.scrollView.contentSize.width;
//    }
//    if (self.webViewHeight != htmlheight) {
//        self.webViewHeight = htmlheight;
//        self.webView.frame = CGRectMake(ScreenX375(10), 0, SCREEN_WIDTH-ScreenX375(20), self.webViewHeight);
//        [self.tableView reloadData];
//    }
//}
//
//- (void)ifNotAuthenticationShowAlert
//{
//    if (![kNSUDefaultReadKey(@"isLogin") integerValue]) {
////        kKeyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//    }
//}

@end
