//
//  HandelTool.m
//  RongMei
//
//  Created by jimmy on 2018/12/5.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HandelTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HandelTool

- (NSString *) md5 : (NSString *) str {
    // 判断传入的字符串是否为空
    if (! str) return nil;
    // 转成utf-8字符串
    const char *cStr = str.UTF8String;
    // 设置一个接收数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 对密码进行加密
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    // 转成32字节的16进制
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}


    
@end
