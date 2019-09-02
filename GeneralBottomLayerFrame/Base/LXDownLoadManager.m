//
//  LXDownLoadManager.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/28.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "LXDownLoadManager.h"
#import "LXDownLoadModel.h"

#define LXDownloadDirectory self.downloadedFilesDirectory ?: [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
stringByAppendingPathComponent:NSStringFromClass([self class])]
//通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：
//NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
//NSClassFromString()利用一个字符串创建一个类
//NSStringFromClass() 获取与类型名称同名的字符串  它的应用场景一般是动态的创建类

#define LXFileName(URL) [URL lastPathComponent] // 从路径中获得完整的'文件名'（带后缀） 作为文件名
//获得文件名（不带后缀）exestr = [exestr stringByDeletingPathExtension];
//获得文件的扩展类型（不带'.'）exestr = [filePath pathExtension]; 例如：NSString *path = @"~/textFile.txt"; NSString *pathExtension = [path pathExtension]; pathExtension这个字符串的值将是“txt”。句点将被去掉了。如果没有句点指明扩展名，将返回一个空串。如果文件不存在，也将返回空串
//[[fileName componentsSeparatedByString:@"."] objectAtIndex:0] 用.分开， objectAtIndex:0为文件名， objectAtIndex:1为后缀

#define LXFilePath(URL) [LXDownloadDirectory stringByAppendingPathComponent:LXFileName(URL)]

#define LXFilesTotalLengthPlistPath [LXDownloadDirectory stringByAppendingPathComponent:@"LXFilesTotalLength.plist"]
//stringByAppendingString是字符串拼接，拼接路径时要在名称前加“/”
//stringByAppendingPathComponent是路径拼接，会在字符串前自动添加“/”，成为完整路径

@interface LXDownLoadManager() <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
// 存放下载中和等待下载模型的字典
@property (nonatomic, strong) NSMutableDictionary *downloadModelsDic;
// 下载中的Models
@property (nonatomic, strong) NSMutableArray *downloadingModels;
// 等待下载的models
@property (nonatomic, strong) NSMutableArray *waitingModels;

@end

@implementation LXDownLoadManager
- (NSMutableDictionary *)downloadModelsDic
{
    if (_downloadModelsDic == nil) {
        _downloadModelsDic = [[NSMutableDictionary alloc] init];
    }
    return _downloadModelsDic;
}

- (NSMutableArray *)downloadingModels
{
    if (_downloadingModels == nil) {
        _downloadingModels = [[NSMutableArray alloc] init];
    }
    return _downloadingModels;
}

- (NSMutableArray *)waitingModels
{
    if (_waitingModels == nil) {
        _waitingModels = [[NSMutableArray alloc] init];
    }
    return _waitingModels;
}

+ (instancetype)sharedManager
{
    static LXDownLoadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[LXDownLoadManager alloc] init];
        downloadManager.maxConcurrentDownloadCount = -1;
        downloadManager.waitingQueueMode = LXWaitingQueueFIFO;
    });
    
    return downloadManager;
}

- (NSURLSession *)urlSession
{
    if (_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                    delegate:self
                                               delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _urlSession;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *downloadDirectory = LXDownloadDirectory;
        BOOL isDirectory = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExists = [fileManager fileExistsAtPath:downloadDirectory isDirectory:&isDirectory];
        if (!isExists || !isDirectory) {
            [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

#pragma mark - 下载回调
- (void)downloadFileOfURL:(NSURL *)URL state:(void (^)(LXDownloadState state))state progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progress completion:(void (^)(BOOL success, NSString *filePath, NSError *error))completion
{
    if (!URL) {
        return;
    }
    if ([self isDownloadCompletedOfURL:URL]) { // If this URL has been downloaded.
        if (state) {
            state(LXDownloadStateCompleted);
        }
        if (completion) {
            completion(YES, [self fileFullPathOfURL:URL], nil);
        }
        return;
    }
    LXDownLoadModel *downloadModel = self.downloadModelsDic[LXFileName(URL)];
    if (downloadModel) { // If the download model of this URL has been added in downloadModelsDic.
        return;
    }
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:URL];
    [requestM setValue:[NSString stringWithFormat:@"bytes=%lld-", (long long int)[self hasDownloadedLength:URL]] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:requestM];
    dataTask.taskDescription = LXFileName(URL);
    
    downloadModel = [[LXDownLoadModel alloc] init];
    downloadModel.dataTask = dataTask;
    downloadModel.outputStream = [NSOutputStream outputStreamToFileAtPath:[self fileFullPathOfURL:URL] append:YES];
    downloadModel.URL = URL;
    downloadModel.state = state;
    downloadModel.progress = progress;
    downloadModel.completion = completion;
    self.downloadModelsDic[dataTask.taskDescription] = downloadModel;
    
    LXDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [dataTask resume];
        downloadState = LXDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = LXDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    LXDownLoadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    [downloadModel openOutputStream];
    
    NSInteger thisTotalLength = response.expectedContentLength; // Equals to [response.allHeaderFields[@"Content-Length"] integerValue]
    NSInteger totalLength = thisTotalLength + [self hasDownloadedLength:downloadModel.URL];
    downloadModel.totalLength = totalLength;
    NSMutableDictionary *filesTotalLength = [NSMutableDictionary dictionaryWithContentsOfFile:LXFilesTotalLengthPlistPath] ?: [NSMutableDictionary dictionary];
    filesTotalLength[LXFileName(downloadModel.URL)] = @(totalLength);
    [filesTotalLength writeToFile:LXFilesTotalLengthPlistPath atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    LXDownLoadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel.outputStream write:data.bytes maxLength:data.length];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.progress) {
            NSUInteger receivedSize = [self hasDownloadedLength:downloadModel.URL];
            NSUInteger expectedSize = downloadModel.totalLength;
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            downloadModel.progress(receivedSize, expectedSize, progress);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error && error.code == -999) { // Cancelled!
        return;
    }
    
    LXDownLoadModel *downloadModel = self.downloadModelsDic[task.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel closeOutputStream];
    
    [self.downloadModelsDic removeObjectForKey:task.taskDescription];
    [self.downloadingModels removeObject:downloadModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isDownloadCompletedOfURL:downloadModel.URL]) {
            if (downloadModel.state) {
                downloadModel.state(LXDownloadStateCompleted);
            }
            if (downloadModel.completion) {
                downloadModel.completion(YES, [self fileFullPathOfURL:downloadModel.URL], error);
            }
        } else {
            if (downloadModel.state) {
                downloadModel.state(LXDownloadStateFailed);
            }
            if (downloadModel.completion) {
                downloadModel.completion(NO, nil, error);
            }
        }
    });
    
    [self resumeNextDowloadModel];
}

- (NSInteger)totalLength:(NSURL *)URL
{
    NSDictionary *filesTotalLenth = [NSDictionary dictionaryWithContentsOfFile:LXFilesTotalLengthPlistPath];
    if (!filesTotalLenth) {
        return 0;
    }
    if (!filesTotalLenth[LXFileName(URL)]) {
        return 0;
    }
    return [filesTotalLenth[LXFileName(URL)] integerValue];
}

- (NSInteger)hasDownloadedLength:(NSURL *)URL {
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self fileFullPathOfURL:URL] error:nil];
    if (!fileAttributes) {
        return 0;
    }
    return [fileAttributes[NSFileSize] integerValue];
}

- (void)resumeNextDowloadModel {
    
    if (self.maxConcurrentDownloadCount == -1) {
        return;
    }
    if (self.waitingModels.count == 0) {
        return;
    }
    
    LXDownLoadModel *downloadModel;
    switch (self.waitingQueueMode) {
        case LXWaitingQueueFIFO:
            downloadModel = self.waitingModels.firstObject;
            break;
        case LXWaitingQueueFILO:
            downloadModel = self.waitingModels.lastObject;
            break;
    }
    [self.waitingModels removeObject:downloadModel];
    
    LXDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [downloadModel.dataTask resume];
        downloadState = LXDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = LXDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
}

#pragma mark - 判断是否可以恢复
- (BOOL)canResumeDownload
{
    if (self.maxConcurrentDownloadCount == -1) {
        return NO;
    }
    if (self.downloadingModels.count >= self.maxConcurrentDownloadCount) {
        return NO;
    }
    return YES;
}

#pragma mark - Files
- (BOOL)isDownloadCompletedOfURL:(NSURL *)URL
{
    NSInteger totalLength = [self totalLength:URL];
    if (totalLength != 0) {
        if (totalLength == [self hasDownloadedLength:URL]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)fileFullPathOfURL:(NSURL *)URL
{
    return LXFilePath(URL);
}

- (CGFloat)fileHasDownloadedProgressOfURL:(NSURL *)URL {
    
    if ([self isDownloadCompletedOfURL:URL]) {
        return 1.0;
    }
    if ([self totalLength:URL] == 0) {
        return 0.0;
    }
    return 1.0 * [self hasDownloadedLength:URL] / [self totalLength:URL];
}

- (void)setDownloadedFilesDirectory:(NSString *)downloadedFilesDirectory
{
    _downloadedFilesDirectory = downloadedFilesDirectory;
    
    if (!downloadedFilesDirectory) {
        return;
    }
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:downloadedFilesDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:downloadedFilesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - Downloads
#pragma mark - 删除某一个下载
- (void)deleteFileOfURL:(NSURL *)URL
{
    [self cancelDownloadOfURL:URL];
    
//    dictionaryWithContentsOfFile:方法的功能是创建一个字典，将字典中的内容设置为指定文件中的所有内容
//    dictionaryWithContentsOfFile和arryWithContentsOfFile都可以用来读取文件中的内容 array更强大 因为数组里面可以放字典
//    https://www.cnblogs.com/zhyios/p/3622277.html
    
    NSMutableDictionary *fileTotalLength = [NSMutableDictionary dictionaryWithContentsOfFile:LXFilesTotalLengthPlistPath];
    [fileTotalLength removeObjectForKey:LXFileName(URL)];
    [fileTotalLength writeToFile:LXFilesTotalLengthPlistPath atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self fileFullPathOfURL:URL];
    if (![fileManager fileExistsAtPath:filePath]) {
        return;
    }
    if ([fileManager removeItemAtPath:filePath error:nil]) {
        return;
    }
    NSLog(@"删除下载文件的路径%@",filePath);
}
#pragma mark - 删除所有下载
- (void)deleteAllFiles
{
    [self cancelAllDownloads];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNameArray = [fileManager contentsOfDirectoryAtPath:LXDownloadDirectory error:nil];
    for (NSString *fileName in fileNameArray) {
        NSString *filePath = [LXDownloadDirectory stringByAppendingPathComponent:fileName];
        if ([fileManager removeItemAtPath:filePath error:nil]) {
            continue;
        }
        NSLog(@"删除下载的文件路径%@",filePath);
    }
}

#pragma mark - 暂停某一个下载
- (void)suspendDownloadOfURL:(NSURL *)URL
{
    LXDownLoadModel *downloadModel = self.downloadModelsDic[LXFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(LXDownloadStateSuspended);
        }
    });
    if ([self.waitingModels containsObject:downloadModel]) {
        [self.waitingModels removeObject:downloadModel];
    } else {
        [downloadModel.dataTask suspend];
        [self.downloadingModels removeObject:downloadModel];
    }
    
    [self resumeNextDowloadModel];
}
#pragma mark - 暂停某所有下载
- (void)suspendAllDownloads
{
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    
    if (self.waitingModels.count > 0) {
        for (NSInteger i = 0; i < self.waitingModels.count; i++) {
            LXDownLoadModel *downloadModel = self.waitingModels[i];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadModel.state) {
                    downloadModel.state(LXDownloadStateSuspended);
                }
            });
        }
        [self.waitingModels removeAllObjects];
    }
    
    if (self.downloadingModels.count > 0) {
        for (NSInteger i = 0; i < self.downloadingModels.count; i++) {
            LXDownLoadModel *downloadModel = self.downloadingModels[i];
            [downloadModel.dataTask suspend];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadModel.state) {
                    downloadModel.state(LXDownloadStateSuspended);
                }
            });
        }
        [self.downloadingModels removeAllObjects];
    }
}

#pragma mark - 恢复某一个下载
- (void)resumeDownloadOfURL:(NSURL *)URL
{
    LXDownLoadModel *downloadModel = self.downloadModelsDic[LXFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    LXDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [downloadModel.dataTask resume];
        downloadState = LXDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = LXDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
}
#pragma mark - 恢复所有下载
- (void)resumeAllDownloads
{
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    
    NSArray *downloadModels = self.downloadModelsDic.allValues;
    for (LXDownLoadModel *downloadModel in downloadModels) {
        LXDownloadState downloadState;
        if ([self canResumeDownload]) {
            [self.downloadingModels addObject:downloadModel];
            [downloadModel.dataTask resume];
            downloadState = LXDownloadStateRunning;
        } else {
            [self.waitingModels addObject:downloadModel];
            downloadState = LXDownloadStateWaiting;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadModel.state) {
                downloadModel.state(downloadState);
            }
        });
    }
}

#pragma mark - 取消某一个下载
- (void)cancelDownloadOfURL:(NSURL *)URL
{
    LXDownLoadModel *downloadModel = self.downloadModelsDic[LXFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel closeOutputStream];
    [downloadModel.dataTask cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(LXDownloadStateCanceled);
        }
    });
    if ([self.waitingModels containsObject:downloadModel]) {
        [self.waitingModels removeObject:downloadModel];
    } else {
        [self.downloadingModels removeObject:downloadModel];
    }
    [self.downloadModelsDic removeObjectForKey:LXFileName(URL)];
    
    [self resumeNextDowloadModel];
}
#pragma mark - 取消所有下载
- (void)cancelAllDownloads
{
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    NSArray *downloadModels = self.downloadModelsDic.allValues;
    for (LXDownLoadModel *downloadModel in downloadModels) {
        [downloadModel closeOutputStream];
        [downloadModel.dataTask cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadModel.state) {
                downloadModel.state(LXDownloadStateCanceled);
            }
        });
    }
    [self.waitingModels removeAllObjects];
    [self.downloadingModels removeAllObjects];
    [self.downloadModelsDic removeAllObjects];
}



@end
