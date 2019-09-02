//
//  FrameHeader.h
//  RongMei
//
//  Created by jimmy on 2018/12/3.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#ifndef FrameHeader_h
#define FrameHeader_h


//#define IS_iPhoneX ([UIApplication sharedApplication].statusBarFrame.size.height != 20)
#define STATUS_BAR_HEIGHT               (IS_iPhoneX ? 44.0f : 20.0f)
#define NAVIGATION_BAR_HEIGHT           (IS_iPhoneX ? 88.0f : 64.0f)
#define TAB_BAR_HEIGHT                  (IS_iPhoneX ? 83.0f : 49.0f)
#define FOOT_HEIGHT                     (IS_iPhoneX ? 34.f  : 0.0f)
//#define NAV_HEIGHT                      48.0f
//#define APP_STATUSBAR_HEIGHT ((IS_iPhoneX) ? 44 : 20) //如果显示则高度为20 否则为0
#define APP_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define IS_IPHONE_Small (ScreenWidth == 320 ? YES : NO)
//判断是否是ipad
#define isIPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isIPad : NO)

//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)


#define VERSION  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kKeyWindow [[UIApplication sharedApplication] keyWindow]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define ScreenX375(x)   (x) * SCREEN_WIDTH / 375
#define ScreenY375(y)   (y) * SCREEN_HEIGHT / 375

#define WidthMultiper   SCREEN_WIDTH / 375

///间隔 20
#define Space20  ScreenX375(20)
///间隔 12
#define Space12  ScreenX375(12)

#define Kfont(f)   [UIFont systemFontOfSize:ScreenX375(f)]
#define Wfont(f,g)   [UIFont systemFontOfSize:f weight:g]
#define Rfont(f)   [UIFont fontWithName:@"PingFangSC-Regular" size:ScreenX375(f)]
#define Mfont(f)   [UIFont fontWithName:@"PingFangSC-Medium" size:ScreenX375(f)]
#define Lfont(f)   [UIFont fontWithName:@"PingFangSC-Light" size:ScreenX375(f)]
#define KBlodfont(f)   [UIFont fontWithName:@"PingFangSC-Semibold" size:ScreenX375(f)]
#define Ffont(f)   [UIFont fontWithName:@"MicrosoftYaHei" size:(f)];
#define ImageWithName(s)   [UIImage imageNamed:s]

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y

#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

//Color
#define RGBACOLOR(r,g,b,a)            [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
#define REXADECIMALCOLOR(str)         [UIColor colorWithHexString:str]
#define ThemeColor                    REXADECIMALCOLOR(@"#17B68D")
#define FONTCOLOR_BLACK               REXADECIMALCOLOR(@"#222222")
#define FONTCOLOR_GRAY                REXADECIMALCOLOR(@"#666666")
#define FONTCOLOR_LIGHTGRAY           REXADECIMALCOLOR(@"#999999")

#define TABLEVIEW_BACKGROUNDCOLOR     RGB_COLOR(254, 254, 254)
#define LineColor                     REXADECIMALCOLOR(@"#efefef")

#define UIColorFromRGB(rgbValue,A) [UIColor colorWithHexString:rgbValue alpha:A]
#define HeaderColor                    RGBACOLOR(237,34,59,1)

#define BACKGROUND_GRAY           REXADECIMALCOLOR(@"#F5F6F9")



#endif /* FrameHeader_h */
