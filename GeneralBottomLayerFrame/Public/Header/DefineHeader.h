//
//  DefineHeader.h
//  RongMei
//
//  Created by jimmy on 2018/12/3.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

//本地
//#define REQUESTHEADER                 @"http://192.168.1.68:7979/"  //黄文转

//#define REQUESTHEADER                 @"http://192.168.1.82:7979/" //家辉

//#define REQUESTHEADER                 @"http://192.168.1.11:3000/"

//#define REQUESTHEADER                 @"http://xiangcheng.fanyin1036.com/webapi/"
///测试服务器
#define REQUESTHEADER                 @"http://47.97.211.86/webapi/"
//线上
//#define REQUESTHEADER                 @"http://47.110.52.118/webapi/"
#define IMAGEHEADER                   @""


//控件修改坐标参数
#define kChangeViewFrameX(view,x) view.frame = CGRectMake((x), view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define kChangeViewFrameY(view,y) view.frame = CGRectMake(view.frame.origin.x, (y), view.frame.size.width, view.frame.size.height)
#define kChangeViewFrameWidth(view,width) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, (width), view.frame.size.height)
#define kChangeViewFrameHeight(view,height) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, (height))

//获取文字高度
#define kGetStringHeight(string,maxSize,font) [(string) boundingRectWithSize:(maxSize) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:(font)} context:nil].size.height
//获取文字宽度
#define kGetStringWidth(string,maxSize,font) [(string) boundingRectWithSize:(maxSize) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:(font)} context:nil].size.width

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//获取版本号
#define kSofterViewsion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//获取手机的UUID标识
#define kUUIDString   [[UIDevice currentDevice].identifierForVendor UUIDString]

//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

//[NSUserDefaults standardUserDefaults]
//存储数据  存储的对象全是不可变的
#define kNSUDefaultSaveVauleAndKey(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
//读取数据
#define kNSUDefaultReadKey(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]

// 弱引用
#define WeakObj(o) __weak typeof(o) o##Weak = o

/// 随机色
#define Testrandom(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define TestrandomColor Testrandom(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))



///第三方sdk定义



#define  ORDER_CANCEL               @"取消订单"
#define  ORDER_LOGISTICS            @"查看物流"
#define  ORDER_DELETE               @"删除订单"
#define  ORDER_GO_PAY               @"去付款"
#define  ORDER_NOTICE_GOODS         @"提醒发货"
#define  ORDER_SURE_GOODS           @"确认收货"
#define  ORDER_REFUNDING            @"退款中"
#define  ORDER_JUDGE                @"去评价"
#define  ORDER_NEW_PAY              @"再次购买"



#define  ShopOrder_NotificationName       @"ShopOrder_NotificationName"
#define  ALIPAY_CALLBACK_NOTIFICATION       @"ALIPAY_CALLBACK_NOTIFICATION"


#define     OssAccessKeyId             kNSUDefaultReadKey(@"ossAccessKeyId")
#define     OssAccessKeySecret         kNSUDefaultReadKey(@"ossAccessKeySecret")
#define     OssBucket                  kNSUDefaultReadKey(@"ossBucket")
#define     OssEndpoint                kNSUDefaultReadKey(@"ossEndpoint")

//qq
//#define kQQAppKey   kNSUDefaultReadKey(@"qqAppId")
#define kQQAppKey     @"101549092"
//@"101549092"//1994729cc873369af22c2e22e1e1deee


//微信
#define kWechatUrl    @"https://api.weixin.qq.com/sns"
//#define kWechatAppId @"wx08ed0cfa29ea024f"
//#define kWechatSecret @"047be7302e98748717ddfed952a49b33"
#define kWechatAppId    kNSUDefaultReadKey(@"wxAppId")
#define kWechatSecret   kNSUDefaultReadKey(@"wxAppSecret")


//微博
//#define kWeiboAppkey @"3891949877"
#define kWeiboAppkey kNSUDefaultReadKey(@"weiboAppId")
#define kWeiboAppRedirectURL @"https://api.weibo.com/oauth2/default.html"
//App Secret：4b9e2a15f31646b6a789620147bd6037




#endif /* DefineHeader_h */
