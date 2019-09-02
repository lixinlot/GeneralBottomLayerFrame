//
//  HTTPManager.m
//  ForestPack
//
//  Created by Jimmy on 2018/7/3.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
#import "NSDate+Extension.h"

#define HUDTIME                       2.0f

@implementation HttpManager

+ (void)postHttpRequestByPost:(NSString *)requestUrl andParameter:(NSDictionary *)requestDict success:(void (^)(id))successBlock andFailure:(void (^)(id))failureBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript",@"text/html",@"text/plain", nil];
    
    [manager POST:requestUrl parameters:requestDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            failureBlock(error);
        }
    }];
}

+ (void)postHttpRequestByGet:(NSString *)requestUrl andParameter:(NSDictionary *)requestDict success:(void (^)(id))successBlock andFailure:(void (^)(id))failureBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript",@"text/html",@"text/plain", nil];
    
    [manager GET:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:requestDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

//+ (void)uploadImageArr:(NSMutableArray<UIImage *> *)imgArr success:(SUCCESSBLOCK) successBlock
//{
//    NSMutableArray * imageDataArray = [NSMutableArray array];
//    if (imgArr) {
//        for (int i = 0; i < imgArr.count; i ++) {
//            NSData * imageData = UIImageJPEGRepresentation(imgArr[i], kUploadImageCompressionRatio);
//            if (imageData == nil) {
//                [HttpManager showNoteMsg:@"请重新更换图片上传"];
//                return;
//            }
//            [imageDataArray addObject:imageData];
//        }
//    }
//    // 将本地的文件上传至服务器
//    NSString *urlStr = [NSString stringWithFormat:@"%@app/ajax_file_upload",REQUESTHEADER];
//    [HttpManager showWait];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil,nil];
//    [manager POST:urlStr parameters:@{@"files[]":imageDataArray} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (int i = 0; i < imageDataArray.count; i ++) {
//            [formData appendPartWithFileData:imageDataArray[i] name:@"files[]" fileName:[[NSString stringWithFormat:@"%d",i] stringByAppendingString:@"photo.jpg"] mimeType:@"image/jpeg"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [HttpManager hideWait];
//        if ([responseObject[@"status"] integerValue] == 1) {
//            NSArray *picUrlAry = responseObject[@"pic"];
//            if (successBlock) {
//                successBlock(picUrlAry);
//            }
//        }else{
//            [HttpManager showNoteMsg:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [HttpManager hideWait];
//        [HttpManager showNoteMsg:@"上传失败"];
//    }];
//}



+ (void)showWait {
    [HttpManager hideWait];
    [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
}

+ (void)hideWait {
    [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
}

+ (void)showFail{
    [HttpManager hideWait];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"网络似乎有点问题,请重试", nil);
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUDTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.hidden = YES;
    });
}

+ (void)showWaitMsg:(NSString *)message {
    [HttpManager hideWait];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 5;
}

+ (void)showNoteMsg:(NSString *)message {
    [HttpManager hideWait];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 5;
    
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));// 2.0/*延迟执行时间*/
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUDTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.hidden = YES;
    });
    
}

+ (NSString *)getTime:(NSString *)inTime {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:inTime];
    
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = kCFCalendarUnitYear |
    kCFCalendarUnitMonth |
    kCFCalendarUnitDay |
    kCFCalendarUnitHour |
    kCFCalendarUnitMinute;
    NSDateComponents *cmps = [calender components:unit fromDate:date toDate:now options:0];
    
    if ([date isThisYear]) {
        if ([date isYesterday]) {
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:date];
        }else if ([date isToday]) {
            if (cmps.hour > 0) {
                return [NSString stringWithFormat:@"%d小时前",(int)cmps.hour];
            }else if (cmps.minute > 1) {
                return [NSString stringWithFormat:@"%d分钟前",(int)cmps.minute];
            }else {
                return @"刚刚";
            }
        }else {
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:date];
        }
    }else {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }
    return inTime;
}

+ (NSString *)TimeStamp:(NSString *)strTime{
    
    if (strTime.length) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //设定时间格式,这里可以设置成自己需要的格式
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[strTime substringToIndex:strTime.length] integerValue]]];
        
        return currentDateStr;
    }
    return nil;
}

@end
