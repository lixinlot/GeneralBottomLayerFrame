//
//  HandelTools.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/6/4.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandelTools : NSObject

/// !!!: 自适应 高度
+ (CGSize)boundingRectWith:(NSString *)content andWidth:(CGFloat)width font:(UIFont *)font;
// !!!: 颜色转图片
+ (UIImage *)createImageWithColor:(UIColor*)color;
/// !!!: 将URL转为image
+(UIImage *)getImageFromURL:(NSString *)url;
/// !!!: 将URL转为image再转为data
+ (NSData *)changeUrlToDataWith:(NSString *)urlImage;
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


///13位时间戳转换为年月日24小时制
+(NSString *)changeTime:(NSString *)timeString;

@property (nonatomic,strong)  void(^sureBlock)(void);
@property (nonatomic,strong)  void(^cancelBlock)(void);

+ (BOOL)checkAllString:(NSString *)string;


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

+ (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView;

+ (NSString *)arrayToJsonStr:(NSArray *)array;

+ (NSString *)dicToJsonStr:(NSDictionary *)dic;

+(CGFloat)autoLayoutContentHeight:(NSString *)content withFont:(CGFloat)fontSize;

+(CAGradientLayer *)layerFrame:(CGRect)frame start:(NSString *)startColor end:(NSString *)endColor;

+(CAGradientLayer *)layerFrame:(CGRect)frame start:(NSString *)startColor startGradien:(NSInteger )startGradien end:(NSString *)endColor endGradien:(NSInteger )endGradien;

+ (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2;

#pragma mark - 获取当前日期 格式 ：年-月-日 时:分:秒
+(NSString*)getCurrentTimes;

#pragma mark - 获取当前日期 格式 ：时:分:秒
+(NSString*)getCurrentExazactTimes;

#pragma mark - 获取当前日期 格式 ：年月
+ (NSString *)getCurrentDate;

#pragma mark - 获取Window当前显示的ViewController
+ (UIViewController *)currentViewController;

/*获取当前设备的唯一编号*/
+ (NSString *)getDeviceTerminalId;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSArray *)getArrayWithJsonString:(NSString *)jsonString;

//获取文件大小
+ (NSString *)getFileSize:(NSString *)url;

+ (NSString *)shortedNumberDesc:(NSUInteger)number;

#pragma mark --获取当前日期 格式 ：时分秒
+(NSString*)getCurrentTimeNums;


@end

NS_ASSUME_NONNULL_END
