//
//  HandelTools.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/6/4.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "HandelTools.h"

@implementation HandelTools

+ (CGSize)boundingRectWith:(NSString *)content andWidth:(CGFloat)width font:(UIFont *)font
{
    return [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

// !!!: 颜色转图片
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

/// !!!: 将URL转为image
+(UIImage *)getImageFromURL:(NSString *)url
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

/// !!!: 将URL转为image再转为data
+ (NSData *)changeUrlToDataWith:(NSString *)urlImage
{
    UIImage *image = [HandelTools getImageFromURL:urlImage];
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    return imageData;
}

/// !!!: 链接生成二维码
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
    return [HandelTools createNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREEN_WIDTH-ScreenX375(70)];//重绘二维码,使其显示清晰
}

#pragma mark - 判断手机号合法性
+ (BOOL)checkPhone:(NSString *)phoneNumber
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch){
        return NO;
    }
    return YES;
}

#pragma mark - 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
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

///13位时间戳转换为年月日24小时制
+(NSString *)changeTime:(NSString *)timeString
{
    
    NSString *dateString ;
    
    if (timeString!=nil) {
        // timeStampString 是服务器返回的13位时间戳
        NSString *timeStampString  = timeString;
        
        // iOS 生成的时间戳是10位
        NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
        NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString       = [formatter stringFromDate: date];
        NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    }
    
    return dateString;
}

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

//获取当前时间戳(以秒为单位)
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

+ (CGSize)contentWithString:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFont:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size;
}

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

+ (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView
{
    // 开始划线 划线的frame
    CGRect frame = imageView.frame;
    UIGraphicsBeginImageContext(frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    CGContextSetStrokeColorWithColor(line, UIColorFromRGB(@"#806F29", 1).CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    CGContextMoveToPoint(line, 0.0, 2.0);
    CGContextAddLineToPoint(line, frame.size.width, frame.size.height);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    
    return UIGraphicsGetImageFromCurrentImageContext();
    
}

+ (NSString *)arrayToJsonStr:(NSArray *)array
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted  error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)dicToJsonStr:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";
    }else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(CGFloat)autoLayoutContentHeight:(NSString *)content withFont:(CGFloat)fontSize
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange allRange = [content rangeOfString:content];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)options:options context:nil];
    titleHeight = ceilf(rect.size.height);
    
    return titleHeight;
}

+(CAGradientLayer *)layerFrame:(CGRect)frame start:(NSString *)startColor end:(NSString *)endColor{
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame =frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.3),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)UIColorFromRGB(startColor, 1).CGColor,(id)UIColorFromRGB(endColor, 1).CGColor]];//渐变数组
    
    return gradientLayer;
    
}

+(CAGradientLayer *)layerFrame:(CGRect)frame start:(NSString *)startColor startGradien:(NSInteger )startGradien end:(NSString *)endColor endGradien:(NSInteger )endGradien
{
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame =frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.3),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)UIColorFromRGB(startColor, startGradien).CGColor,(id)UIColorFromRGB(endColor, endGradien).CGColor]];//渐变数组
    
    return gradientLayer;
    
}

+ (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    
    NSLog(@"---%@----%@",time1,time2);
    
    
    NSLog(@"%ld小时%ld分钟",  cmps.hour, cmps.minute);
    
    return [NSString stringWithFormat:@"%ld,%ld分钟",cmps.hour, cmps.minute];
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

#pragma mark - 获取当前日期 格式 ：时:分:秒
+(NSString*)getCurrentExazactTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

//计算当前时间与订单生成时间的时间差，转化成分钟
+(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startDate =[formatter dateFromString:startTime];
    NSString *nowstr = [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [nowDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    NSInteger time;//剩余时间为多少分钟
    
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        time = day*24*60+house*60+minute;
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
        time = house*60+minute;
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
        time = minute;
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return str;
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

#pragma mark - NSScanner去除标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark - 正则去除标签
-(NSString *)getZZwithString:(NSString *)string
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

//获取Window当前显示的ViewController
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

//1. 获取缓存文件的大小
-( float )readCacheSize
{
    NSString *cachePaths = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePaths];
}

//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
- ( float )folderSizeAtPath:( NSString *)folderPath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}

// 计算 单个文件的大小
- ( long long )fileSizeAtPath:( NSString *)filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

//2. 清除缓存
- (void)clearFile
{
    NSString * cachePaths = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePaths];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePaths stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    //读取缓存大小
    //    float cacheSizes = [self readCacheSize] *1024;
}

/*获取当前设备的唯一编号*/
+ (NSString *)getDeviceTerminalId
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *vendor = [[device identifierForVendor] UUIDString];
    return [NSString stringWithFormat:@"%@",vendor];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
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

+ (NSArray *)getArrayWithJsonString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

//获取文件大小
+ (NSString *)getFileSize:(NSString *)url
{
    NSFileManager *file = [NSFileManager defaultManager];
    
    NSDictionary *dict = [file attributesOfItemAtPath:url error:nil];
    
    unsigned long long size = [dict fileSize];
    
    NSString *fileSize;
    if (size >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
        fileSize = [NSString stringWithFormat:@"%.2lluM",size/1024/1024];
    }else{
        fileSize = [NSString stringWithFormat:@"%.1lluKB",size/1024];
    }
    return fileSize;
}

///单位换算
+ (NSString *)shortedNumberDesc:(NSUInteger)number
{
    // should be localized
    if (number <= 9999) return [NSString stringWithFormat:@"%d", (int)number];
    if (number <= 9999999) return [NSString stringWithFormat:@"%.1lf万", (float)(number / 10000)];
    if (number <= 99999999) return [NSString stringWithFormat:@"%.1lf千万", (float)(number / 10000000)];
    
    return [NSString stringWithFormat:@"%d亿", (int)(number / 100000000)];
}

#pragma mark --获取当前日期 格式 ：时分秒
+(NSString*)getCurrentTimeNums
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"HHmmss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

@end
