//
//  DGHttpPostManager.h
//  tutu
//
//  Created by Jimmy on 2017/7/27.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HttpManager : NSObject

#define SUCCESSBLOCK void(^)(id successResponse)
#define FAILUREBLOCk void(^)(id failureResponse)


+ (void)postHttpRequestByPost:(NSString *)requestUrl andParameter:(NSDictionary *)requestDict success:(SUCCESSBLOCK) successBlock andFailure:(FAILUREBLOCk)failureBlock;

+ (void)postHttpRequestByGet:(NSString *)requestUrl andParameter:(NSDictionary *)requestDict success:(SUCCESSBLOCK) successBlock andFailure:(FAILUREBLOCk)failureBlock;

/// 上传图片
+ (void)uploadImageArr:(NSMutableArray<UIImage *> *)imgArr success:(SUCCESSBLOCK) successBlock;

+ (void)showWait;

+ (void)hideWait;

+ (void)showFail;

+ (void)showWaitMsg:(NSString *)message;

+ (void)showNoteMsg:(NSString *)message;

+ (NSString *)TimeStamp:(NSString *)strTime;

+ (NSString *)getTime:(NSString *)inTime;

@end
