//
//  LXDownLoadModel.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/28.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LXDownloadState) {
    LXDownloadStateWaiting,
    LXDownloadStateRunning,
    LXDownloadStateSuspended,
    LXDownloadStateCanceled,
    LXDownloadStateCompleted,
    LXDownloadStateFailed
};

NS_ASSUME_NONNULL_BEGIN

@interface LXDownLoadModel : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSOutputStream *outputStream; // For write datas to file.

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, copy) void (^state)(LXDownloadState state);//

@property (nonatomic, copy) void (^progress)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);

@property (nonatomic, copy) void (^completion)(BOOL isSuccess, NSString *filePath, NSError *error);

- (void)openOutputStream;

- (void)closeOutputStream;

@end

NS_ASSUME_NONNULL_END
