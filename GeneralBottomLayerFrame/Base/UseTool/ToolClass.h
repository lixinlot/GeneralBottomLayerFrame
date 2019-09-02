//
//  ToolClass.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/22.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolClass : NSObject

/// !!!: 自适应 高度
+ (CGSize)boundingRectWith:(NSString *)content andWidth:(CGFloat)width font:(UIFont *)font;
// !!!: 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color;
/// !!!: 将URL转为image
+(UIImage *)getImageFromURL:(NSString *)url;
/// !!!: 链接生成二维码
+ (UIImage *)getUrlToErWeiCodePic:(NSString *)string;

#pragma mark - 判断手机号合法性
+ (BOOL)checkPhone:(NSString *)phoneNumber;

#pragma mark - 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;

#pragma mark - 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard;

#pragma mark - 判断邮箱
+ (BOOL)checkEmail:(NSString *)email;

///压缩图片方法(压缩尺寸)  这里的maxLength 入参 可以这样写 比如指定 压缩成400kb  400.f * 1024.f 即可
+(NSData *)compressBySizeWithImage:(UIImage *)image withLengthLimit:(NSUInteger)maxLength;

///根据CIImage生成指定大小的UIImage(处理模糊的方法)
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

///获取当前时间戳(以秒为单位)
+(NSString *)getNowTimeTimestamp;

///自适应宽度
+ (CGSize)contentWithString:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFont:(UIFont *)font;

///给控件边框加虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

#pragma mark - 获取Window当前显示的ViewController
+ (UIViewController *)currentViewController;

/// !!!: /*获取当前设备的唯一编号*/
+ (NSString *)getDeviceTerminalId;
/// !!!: Json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/// !!!:判断字符串，不存在就用空字符串代替
+(NSString*)changeNullToBlank:(NSString*)str;
/// !!!:判断字符串，不存在就用0代替
+(NSString*)changeNullToZero:(NSString*)str;
/// !!!: 验证码验证
+ (BOOL)checkYzmField:(NSString *)yzmField;
///获取token
+ (NSString*)getToken;

+ (void)removeDirectoryPath:(NSString *)directoryPath;

+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion;



/// !!!: 13位时间戳转换为年月日24小时制
+(NSString *)changeTime:(NSString *)timeString;

#pragma mark - 显示文字
+ (void)drawText:(NSString *)str frame:(CGRect )frame font:(UIFont *)font textColor:(UIColor *)textColor;

@end
