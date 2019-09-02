//
//  LXFileManager.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/13.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "LXFileManager.h"

static NSFileManager *fileManager;

@implementation LXFileManager

+ (NSFileManager *)getNSFileManager {
    if (!fileManager) {
        fileManager = [NSFileManager defaultManager];
    }
    return fileManager;
}

//#pragma mark - >>>>>>>>>判断是否存在<<<<<<<<<<<

#pragma mark 判断文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)aPath {
    BOOL result = NO;
    if (aPath) {
        result = [[self getNSFileManager] fileExistsAtPath:aPath];
    }
    return result;
}

#pragma mark 判断文件是否存在Documents下
+ (BOOL)fileExistsAtDocumentsWithFileName:(NSString *)afileName {
    BOOL result = NO;
    if (afileName) {
        NSString *fullFileName = [self getFullDocumentPathWithName:afileName];
        result = [[self getNSFileManager] fileExistsAtPath:fullFileName];
    }
    return result;
}

#pragma mark - 判断文件夹是否存在
+ (BOOL)dirExistAtPath:(NSString *)aPath {
    BOOL isDir = NO;
    BOOL result = [[self getNSFileManager] fileExistsAtPath:aPath isDirectory:&isDir];
    return result && isDir;
}

#pragma mark - >>>>>>>>>创建<<<<<<<<<<<
#pragma mark - 创建目录
+ (BOOL)createPath:(NSString *)aPath {
    BOOL result = NO;
    result = [self createParentDirectory:aPath];
    if (result) {
        result = [[self getNSFileManager] createDirectoryAtPath:aPath withIntermediateDirectories:YES attributes:nil error:nil ];
    }
    return result;
}

#pragma mark - 创建目录的上级目录
+ (BOOL)createParentDirectory:(NSString *)aPath {
    //存在上级目录，并且上级目录不存在的创建所有的上级目录
    BOOL result = NO;
    NSString *parentPath = [self getParentPath:aPath];
    if (parentPath && ![self dirExistAtPath:parentPath]) {
        return [[self getNSFileManager] createDirectoryAtPath:parentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else if ([self dirExistAtPath:parentPath]) {
        result = YES;
    }
    return result;
}

#pragma mark 目录下创建文件
+ (BOOL)createFileWithPath:(NSString *)aPath content:(NSData *)aContent {
    BOOL result = NO;
    result = [self createParentDirectory:aPath];
    if (result) {
        result = [[self getNSFileManager] createFileAtPath:aPath contents:aContent attributes:nil];
    }
    return result;
}

#pragma mark documents下创建文件
+ (BOOL)createFileAtDocumentsWithName:(NSString *)aFilename content:(NSData *)aContent {
    NSString *filePath = [self getFullDocumentPathWithName:aFilename];
    BOOL result = [self createFileWithPath:filePath content:aContent];
    return result;
}

+ (NSString *)createFileWithName:(NSString *)aFilename content:(NSData *)aContent {
    NSString *filePath = [self getFullDocumentPathWithName:aFilename];
    BOOL result = [self createFileWithPath:filePath content:aContent];
    if (!result) {
        filePath = nil;
    }
    return filePath;
}

#pragma mark TMP下创建文件
+ (BOOL)createFileWithTmpWithName:(NSString *)aFilename content:(NSData *)aContent {
    NSString *filePath = [self getFullTempPathWithname:aFilename];
    BOOL result = [self createFileWithPath:filePath content:aContent];
    return result;
}

+ (NSString *)createFileAtTmpWithName:(NSString *)aFilename content:(NSData *)aContent {
    NSString *filePath = [self getFullTempPathWithname:aFilename];
    BOOL result = [self createFileWithPath:filePath content:aContent];
    if (!result) {
        filePath = nil;
    }
    return filePath;
}

#pragma mark Caches下创建文件
+ (BOOL)createFileAtCachesWithName:(NSString *)aFilename content:(NSData *)aContent {
    NSString *filePath = [self getFullCachePathWithName:aFilename];
    BOOL result = [self createFileWithName:filePath content:aContent];
    return result;
}

#pragma mark 在Document下创建文件目录
+ (BOOL)createDirectoryAtDocument:(NSString *)aDirectory {
    NSString *directoryAll = [self getFullDocumentPathWithName:aDirectory];
    BOOL result = [[self getNSFileManager] createDirectoryAtPath:directoryAll withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}

#pragma mark - >>>>>>>>>删除<<<<<<<<<
#pragma mark 删除文件
+ (BOOL)deleteFileWithName:(NSString *)aFileName error:(NSError * _Nullable __autoreleasing *)aError {
    NSFileManager *tempManager = [self getNSFileManager];
    return [tempManager removeItemAtPath:aFileName error:aError];
}

#pragma mark - 删除指定路径下的文件
+ (BOOL)deleteFileWithUrl:(NSURL *)aUrl error:(NSError * _Nullable __autoreleasing *)aError {
    return [[self getNSFileManager] removeItemAtURL:aUrl error:aError];
}

#pragma mark 删除文件夹下的所有文件
+ (BOOL)deleteAllFileAtPath:(NSString *)aPath {
    BOOL result = NO;
    NSArray *fileArray = [self getContentsOfDirectoryAtPath:aPath];
    
    NSString *filePath = nil;
    for (int i = 0; i < [fileArray count]; i++) {
        filePath = [aPath stringByAppendingPathComponent:[fileArray objectAtIndex:i]];
        result = [[self getNSFileManager] removeItemAtPath:filePath error:nil];
        if (!result) {
            break;
        }
        filePath = nil;
    }
    return result;
}

#pragma mark 根据文件名删除document下的文件
+ (BOOL)deleteFileAtDocumentsWithName:(NSString *)aFilename error:(NSError **)aError {
    NSString *filePath = [self getFullDocumentPathWithName:aFilename];
    return [self deleteFileWithName:filePath error:aError];
}

#pragma mark 读取文件
+ (NSData *)readFileWithPath:(NSString *)aPath {
    NSData *data = [NSData dataWithContentsOfFile:aPath];
    return data;
}

+ (NSData *)readFileWithURL:(NSURL *)aUrl {
    NSData *data = [NSData dataWithContentsOfURL:aUrl];
    return data;
}

+ (NSData *)readFileAtDocumentsWithFileName:(NSString *)aFileName {
    NSString *fullPathWithName =  [self getFullDocumentPathWithName:aFileName];
    NSData *data = [NSData dataWithContentsOfFile:fullPathWithName];
    return data;
}

#pragma mark - 获取临时目录下的所有文件列表
+ (NSArray *)getContentsOfTmpDirectorByTimeOrder {
    return [self getContentsOfDirectoryByTimeOrderAtPath:[self getTempPath]];
}

#pragma mark - 获取文件大小
+ (unsigned long long)fileSizeAtPaht:(NSString *)aPath {
    return  [[[self getNSFileManager] attributesOfItemAtPath:aPath  error:nil] fileSize];
}

#pragma mark - >>>>>>>>>获取<<<<<<<<<<<
#pragma mark - 获取上级目录
+ (NSString *)getParentPath:(NSString *)aPath {
    //获取最后一个目录
    return [aPath stringByDeletingLastPathComponent];
}

#pragma mark 根据文件名称获取documents的文件名的全路径
+ (NSString *)getFullDocumentPathWithName:(NSString *)aFileName {
    return [[self getDocumentPath] stringByAppendingString:aFileName];
}

#pragma mark 根据文件名称获取tmp的文件名的全路径
+ (NSString *)getFullTempPathWithname:(NSString *)aFileName {
    return [[self getTempPath] stringByAppendingPathComponent:aFileName];
}

#pragma mark 根据文件名称获取Caches的文件名的全路径
+ (NSString *)getFullCachePathWithName:(NSString *)aFileName {
    return [[self getCachePath] stringByAppendingPathComponent:aFileName];
}

+ (NSString *)getHomePath {
    NSString *homePath = [@"~" stringByExpandingTildeInPath];
    return homePath;
}

#pragma mark 获取documents的全路径
+ (NSString *)getDocumentPath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *result = [path objectAtIndex:0];
    return result;
}

#pragma mark 获取tmp路径
+ (NSString *)getTempPath {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    return path;
}

#pragma mark 获取caches路径
+ (NSString *)getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *pathName = [paths objectAtIndex:0];
    return pathName;
}

#pragma mark 遍历文件夹下的所有文件,不含子文件
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)aDirString {
    //contentsOfDirectoryAtPath 返回NSStrings的NSArray，表示目录中项目的文件名。如果此方法返回'nil'，则会在'error'参数中通过引用返回NSError。如果目录不包含任何项，则此方法将返回空数组。
    return [[self getNSFileManager] contentsOfDirectoryAtPath:aDirString error:nil];
}

#pragma mark - 获取路径下通过时间排序的文件列表
+ (NSArray *)getContentsOfDirectoryByTimeOrderAtPath:(NSString *)aDireString {
    NSArray *files = [self getAllFilesAtPath:(NSString *)aDireString];
    
    NSMutableArray *iUrls = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *sortedFiles = nil;
    
    if([files count] > 0) {
        sortedFiles = [files sortedArrayUsingComparator:^(NSString *url1, NSString *url2) {
            //返回键/值对的NSDictionary，其中包含相关路径中项目（文件，目录，符号链接等）的属性。如果此方法返回'nil'，则会在'error'参数中通过引用返回NSError。此方法不会遍历终端符号链接。
            NSDictionary *fileAttributes1 = [[self getNSFileManager] attributesOfItemAtPath:url1 error:nil];
            NSDictionary *fileAttributes2 = [[self getNSFileManager] attributesOfItemAtPath:url2 error:nil];
            NSDate *date1 = [fileAttributes1 objectForKey:NSFileCreationDate] ;
            NSDate *date2 = [fileAttributes2 objectForKey:NSFileCreationDate] ;
            return [date2 compare:date1];
        }];
    }
    
    for (int i = 0; i < [sortedFiles count]; i++) {
        NSURL *url = [NSURL fileURLWithPath:[sortedFiles objectAtIndex:i]];
        [iUrls addObject:url];
    }
    return iUrls;
}

#pragma mark - 遍历文件夹下的所有文件,包含子文件
+ (NSArray *)getAllFilesAtPath:(NSString *)aDirString {
    NSMutableArray *tempPathArray = [NSMutableArray array];
    NSArray *tempArray =[self getContentsOfDirectoryAtPath:aDirString];
    NSString *fullPath = nil;
    
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        fullPath = [aDirString stringByAppendingPathComponent:fileName];
        //判断是否存在
        if ([[self getNSFileManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            //不是目录,直接添加
            if (![[fileName substringToIndex:1]isEqualToString:@"."]) {
                [tempPathArray addObject:fullPath];
            }else{//如果是目录,一当前文件夹为key,文件夹下的子文件名为value,递归调用
                NSArray *subPathArray = [self getAllFilesAtPath:fullPath];
                [tempPathArray addObjectsFromArray:subPathArray];
            }
        }
        fullPath = nil;
    }
    NSArray *resultArray = [NSArray arrayWithArray:tempPathArray];
    return resultArray;
}


#pragma mark 复制一个目录下的文件到另外一个目录,前后两个必须一致，要么都是目录，要么都是文件
+ (BOOL) copyItemAtPath:(NSString *)aPath toPath:(NSString *)aDestinationPath error:(NSError **)aError {
    NSFileManager *tempFileManager = [self getNSFileManager];
    return [tempFileManager copyItemAtPath:aPath toPath:aDestinationPath error:aError];
}

#pragma mark 重命名文件
+ (BOOL)renameFileNameFrom:(NSString *)aOldName toPath:(NSString *)aNewName error:(NSError **)aError {
    NSFileManager *tempFileManager = [self getNSFileManager];
    BOOL result =  [tempFileManager moveItemAtPath:aOldName toPath:aNewName error:aError];
    return result;
}


@end


//- (NSString *)stringByExpandingTildeInPath   将路径中的代字符扩展成用户主目录(~)或指定用户的主目录(~user)
//- (NSString *)stringByAppendingPathComponent（NSString*)path  将path添加到现有路径末尾
//- (NSString *)pathExtension  从路径中最后一个组成部分中提取扩展名
//- (NSString *)lastPathComponent  提取路径中的最后一个组成部分
//- (NSArray *)pathComponents    解析路径,返回构成路径的各个部分.
//+ (NSString *)pathWithComponents（NSArray *)components  根据components中的元素来构建路径.
//- (NSString *)stringByAppendingPathExtension（NSString *)ext  将指定的扩展名添加到现有路径的最后一个组成部分上
//- (NSString *)stringByDeletingLastPathComponent   删除路径中的最后一个组成部分
//- (NSString *)stringByDeletingPathExtension   从文件的最后一部分删除扩展名
//- (NSString *)stringByResolvingSymlinksInPath  尝试解析路径中的符号链接
//- (NSString *)stringByStandardizingPath   解析路径中的~,(..)父目录,(.)当前目录和符号链接来标准化路径.







