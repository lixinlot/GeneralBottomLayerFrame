//
//  LXDownLoadManager.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/28.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXDownLoadModel.h"

typedef NS_ENUM(NSInteger, LXWaitingQueueMode) {
    LXWaitingQueueFIFO,
    LXWaitingQueueFILO
};


NS_ASSUME_NONNULL_BEGIN

@interface LXDownLoadManager : NSObject

///Directory where the downloaded files are saved, default is .../Library/Caches/SRDownloadManager if not setted.
@property (nonatomic, copy) NSString *downloadedFilesDirectory;

///当前最大下载数量 默认是-1 即没有限制
@property (nonatomic, assign) NSInteger maxConcurrentDownloadCount;

///Mode of waiting downloads queue, default is FIFO.
@property (nonatomic, assign) LXWaitingQueueMode waitingQueueMode;

+ (instancetype)sharedManager;

/**
 Download a file and provide state、progress、completion callback.
 
 @param URL        The URL of the file which want to download.
 @param state      Callback block when the download state changed.
 @param progress   Callback block when the download progress changed.
 @param completion Callback block when the download completion.
 */
- (void)downloadFileOfURL:(NSURL *)URL state:(void (^)(LXDownloadState state))state progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progress completion:(void (^)(BOOL success, NSString *filePath, NSError *error))completion;

- (BOOL)isDownloadCompletedOfURL:(NSURL *)URL;

#pragma mark - Files
///链接的全路径
- (NSString *)fileFullPathOfURL:(NSURL *)URL;

- (CGFloat)fileHasDownloadedProgressOfURL:(NSURL *)URL;

#pragma mark - Operation

///删除某一个下载
- (void)deleteFileOfURL:(NSURL *)URL;
///删除所有下载
- (void)deleteAllFiles;

#pragma mark - Downloads
///暂停某一个下载
- (void)suspendDownloadOfURL:(NSURL *)URL;
///暂停某所有下载
- (void)suspendAllDownloads;

///恢复某一个下载
- (void)resumeDownloadOfURL:(NSURL *)URL;
///恢复所有下载
- (void)resumeAllDownloads;

///取消某一个下载
- (void)cancelDownloadOfURL:(NSURL *)URL;
///取消所有下载
- (void)cancelAllDownloads;

@end

NS_ASSUME_NONNULL_END
