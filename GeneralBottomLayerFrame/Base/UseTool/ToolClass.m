//
//  ToolClass.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/22.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "ToolClass.h"

@implementation ToolClass

#pragma mark -  自适应 高度
+ (CGSize)boundingRectWith:(NSString *)content andWidth:(CGFloat)width font:(UIFont *)font
{
    return [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark -  颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -  将URL转为image
+(UIImage *)getImageFromURL:(NSString *)url
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

#pragma mark -  链接生成二维码
+ (UIImage *)getUrlToErWeiCodePic:(NSString *)string
{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    return [ToolClass createNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREEN_WIDTH-ScreenX375(70)];//重绘二维码,使其显示清晰
}

#pragma mark - 根据CIImage生成指定大小的UIImage(处理模糊的方法)
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 判断手机号合法性
+ (BOOL)checkPhone:(NSString *)phoneNumber
{
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNumber.length != 11){
        return NO;
    }else{
        NSString * MOBILE = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        BOOL isMatch = [regextestmobile evaluateWithObject:phoneNumber];
        return isMatch;
    }
}

#pragma mark - 正则匹配用户密码
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";//6-18位数字和字母组合
//    NSString *pattern = @"[0-9 | A-Z | a-z]{6,16}";//6-16位数字和字母组合,不含其它字符，如_，&等。
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}

#pragma mark - 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    
    return isMatch;
}

#pragma mark - 判断邮箱
+ (BOOL)checkEmail:(NSString *)email
{
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 判断
+ (BOOL)checkAllString:(NSString *)string
{
    if (string == nil) {
        return NO;
    }
    //提示 标签不能输入特殊字符
    NSString *str =@"^[a-zA-Z]*$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL result = [emailTest evaluateWithObject:string];
    return result;
}

#pragma mark - 压缩图片方法(压缩尺寸)  这里的maxLength 入参 可以这样写 比如指定 压缩成400kb  400.f * 1024.f 即可
+(NSData *)compressBySizeWithImage:(UIImage *)image withLengthLimit:(NSUInteger)maxLength
{
    //    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(image.size.width * sqrtf(ratio)),
                                 (NSUInteger)(image.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(image, 1);
    }
    return data;
}

#pragma mark - 13位时间戳转换为年月日24小时制 yyyy-MM-dd HH:mm:ss
+(NSString *)changeTime:(NSString *)timeString
{
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString  = timeString;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    
    return dateString;
}

#pragma mark - 判断字符串，不存在就用空字符串代替
+(NSString*)changeNullToBlank:(NSString*)str
{
    if (!str) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}

#pragma mark - 判断字符串，不存在就用0代替
+(NSString*)changeNullToZero:(NSString*)str
{
    if (!str || [str isEqualToString:@""]) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%@",str];
}

#pragma mark - 6位验证码
+ (BOOL)checkYzmField:(NSString *)yzmField
{
    NSString *pattern = @"^\\d{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:yzmField];
    return isMatch;
}

#pragma mark - 获取token
+(NSString*)getToken
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [SaveDefaults objectForKey:@"token"];
    return [ToolClass changeNullToBlank:token];
}

#pragma mark - /*获取当前设备的唯一编号*/
+ (NSString *)getDeviceTerminalId
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *vendor = [[device identifierForVendor] UUIDString];
    return [NSString stringWithFormat:@"%@",vendor];
}

#pragma mark - Json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    else{
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
}

#pragma mark - 获取当前时间戳(以秒为单位)
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"]; // YYYY-MM-dd  ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSinceNow]];
    
    return timeSp;
}

#pragma mark - 自适应 高度
+ (CGSize)contentWithString:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFont:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size;
}

#pragma mark - 给控件边框加虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark --获取当前日期 格式 ：年-月-日 时:分:秒
+(NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

#pragma mark --获取当前日期 格式 ：年月
+ (NSString *)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY.MM"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

#pragma mark - 获取Window当前显示的ViewController
+ (UIViewController*)currentViewController
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

+ (void)removeDirectoryPath:(NSString *)directoryPath {
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectoey;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectoey];
    
    if (!isExist || !isDirectoey) {
        NSException *exception = [NSException exceptionWithName:@"PathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        [exception raise];
    }
    //获取cache文件夹下所有文件，不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString *subPath in subPaths) {
        //拼接完整路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        //删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
}

+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion {
    NSFileManager *mgr =[NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExist) {
        NSException *exception = [NSException exceptionWithName:@"PathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        [exception raise];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取文件夹下所有文件，包括子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger totalSize = 0;
        for (NSString *subPath in subPaths) {
            //获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            //判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            //判断是否文件夹
            BOOL isDircetory;
            
            //判断文件是否存在，并判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDircetory];
            if (isDircetory || !isExist) continue;
            
            //获取文件属性
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            NSInteger size = [attr fileSize];
            
            totalSize += size;
        }
        
        //计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}

#pragma mark - 显示文字
+ (void)drawText:(NSString *)str frame:(CGRect )frame font:(UIFont *)font textColor:(UIColor *)textColor {
    [str drawInRect:frame withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
}


@end
