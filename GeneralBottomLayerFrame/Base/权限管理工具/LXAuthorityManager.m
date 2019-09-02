//
//  LXAuthorityManager.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/13.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "LXAuthorityManager.h"
#import <CoreLocation/CoreLocation.h>           //定位
#import <AddressBook/AddressBook.h>             //通讯录
#import <Photos/Photos.h>                       //获取相册状态权限
#import <AVFoundation/AVFoundation.h>           //相机麦克风权限
#import <EventKit/EventKit.h>                   //日历\备提醒事项权限
#import <Contacts/Contacts.h>                   //通讯录权限
#import <SafariServices/SafariServices.h>
#import <Speech/Speech.h>                       //语音识别
#import <HealthKit/HealthKit.h>                 //运动与健身
#import <MediaPlayer/MediaPlayer.h>             //媒体资料库
#import <UserNotifications/UserNotifications.h> //推送权限
#import <CoreBluetooth/CoreBluetooth.h>         //蓝牙权限
#import <Speech/Speech.h>                       //语音识别

static NSString *authorityStr =@"authority";
static CLLocationManager  * managerAlways;
static CLLocationManager  * managerWhenUsed;
typedef NS_ENUM(NSInteger, LXAuthorizationStatus) {
    LXAuthorizationStatusNotDetermined = 0,
    LXAuthorizationStatusRestricted,
    LXAuthorizationStatusDenied,
    LXAuthorizationStatusAuthorized,
};
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface LXAuthorityManager()



@end

@implementation LXAuthorityManager

#pragma mark - 请求所有权限
+ (void)requestAllAuthority {
    
    //只请求一次
    NSUserDefaults *defaut =[NSUserDefaults standardUserDefaults];
    NSString *authority = [defaut objectForKey:authorityStr];
    if (authority) return;
    [defaut setObject:@"authority" forKey:authorityStr];
    
    if (![self isObtainPhPhotoAuthority]) {
        //相册权限
        [self obtainPHPhotoAuthorizedStaus];
    }
    if (![self isObtainAVVideoAuthority]) {
        //相机
        [self isObtainAVVideoAuthority];
    }
    if (![self isObtainAVAudioAuthority]) {
        //麦克风
        [self obtainAVMediaAudioAuthorizedStatus];
    }
    if (![self isObtainLocationAuthority]) {
        //定位权限
        [self obtainCLLocationAlwaysAuthorizedStatus];
        [self obtainCLLocationWhenInUseAuthorizedStatus];
    }
    if (![self isObtainCNContactAuthority]) {
        //通讯录
        [self obtainCNContactAuthorizedStatus];
    }
    if (![self isObtainSpeechRecognizer]) {
        //语音识别
        [self obtainSFSpeechAuthorizedStatus];
    }
}

#pragma mark - 是否开启定位权限
+ (BOOL)isObtainLocationAuthority {
    //定位权限
    if ([self statusOfCurrentLocation] == kCLAuthorizationStatusAuthorizedAlways || [self statusOfCurrentLocation] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }else {
        return NO;
    }
}

+ (CLAuthorizationStatus)statusOfCurrentLocation
{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        DLog(@"定位权限:未起开定位开关(not turn on the location)");
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            DLog(@"定位权限:同意一直使用(Always Authorized)");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            DLog(@"定位权限:使用期间同意使用(AuthorizedWhenInUse)");
            break;
        case kCLAuthorizationStatusDenied:
            DLog(@"定位权限:拒绝(Denied)");
            break;
        case kCLAuthorizationStatusNotDetermined:
            DLog(@"定位权限:未进行授权选择(not Determined)");
            break;
        case kCLAuthorizationStatusRestricted:
            DLog(@"定位权限:未授权(Restricted)");
            break;
        default:
            break;
    }
    return status;
}

//始终访问位置信息
+ (void)obtainCLLocationAlwaysAuthorizedStatus {
    managerAlways = [[CLLocationManager alloc] init];
    [managerAlways requestAlwaysAuthorization];
    if ([managerAlways locationServicesEnabled] == YES) {
        [self isObtainWithStatus:3];
    }else {
        [self isObtainWithStatus:2];
    }
    
}

//使用时访问位置信息
+ (void)obtainCLLocationWhenInUseAuthorizedStatus {
    managerWhenUsed = [[CLLocationManager alloc] init];
    [managerWhenUsed requestWhenInUseAuthorization];
    if ([managerAlways locationServicesEnabled] == YES) {
        [self isObtainWithStatus:3];
    }else {
        [self isObtainWithStatus:2];
    }
}

#pragma mark - 推送
+ (void)obtainUserNotificationAuthorizedStatus {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *userNotiCenter = [UNUserNotificationCenter currentNotificationCenter];
        [userNotiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            [self ShowGranted:granted];
        }];
    } else {
        // Fallback on earlier versions
    }
}


#pragma mark - 是否开启媒体资料库权限
+ (BOOL)isObtainMediaAuthority {
    MPMediaLibraryAuthorizationStatus mediaStatus = [MPMediaLibrary authorizationStatus];
    return [self isObtainWithStatus:mediaStatus];
}

+ (void)obtainMPMediaAuthorizedStatus {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus mediaStatus = [MPMediaLibrary authorizationStatus];
        if (mediaStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                [self isObtainWithStatus:mediaStatus];
            }];
        }
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 是否开启语音识别权限
+ (BOOL)isObtainSpeechAuthority {
    SFSpeechRecognizerAuthorizationStatus speechStatus = [SFSpeechRecognizer authorizationStatus];
    return [self isObtainWithStatus:speechStatus];
}

+ (void)obtainSFSpeechAuthorizedStatus {
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            [self isObtainWithStatus:status];
        }];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 是否开启日历权限
+ (BOOL)isObtainEKEventAuthority {
    EKAuthorizationStatus ekStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    return [self isObtainWithStatus:ekStatus];
}

//开启日历权限
+ (void)obtainEKEventAuthorizedStatus {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        [self ShowGranted:granted];
    }];
}

#pragma mark - 是否开启相册权限
+ (BOOL)isObtainPhPhotoAuthority {
    //相册权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    return [self isObtainWithStatus:photoAuthorStatus];
}

//开启相册权限
+ (void)obtainPHPhotoAuthorizedStaus {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == 3) {
            DLog(@"相册开启权限:获取");
        }else {
            DLog(@"相册开启权限:暂无");
        }
    }];
}

#pragma mark - 是否开启相机权限
+ (BOOL)isObtainAVVideoAuthority {
    //相机权限
    AVAuthorizationStatus avstatus =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return [self isObtainWithStatus:avstatus];
}

+ (void)obtainAVMediaVideoAuthorizedStatus {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        [self ShowGranted:granted];
    }];
}

#pragma mark - 是否开启通讯录权限
+ (BOOL)isObtainCNContactAuthority {
    //通讯录 ios9之前
    if (IOS9_OR_LATER) {
        CNAuthorizationStatus abstatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return [self isObtainWithStatus:abstatus];
    }else {
        ABAuthorizationStatus abstatus = ABAddressBookGetAuthorizationStatus();
        return [self isObtainWithStatus:abstatus];
    }
}

+ (void)obtainCNContactAuthorizedStatus {
    if (IOS9_OR_LATER) {
        CNContactStore *contactStore = [CNContactStore new];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            [self ShowGranted:granted];
        }];
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [self ShowGranted:granted];
        });
    }
}

#pragma mark - 是否开启麦克风权限
+ (BOOL)isObtainAVAudioAuthority {
    //麦克风
    AVAuthorizationStatus micstatus =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return [self isObtainWithStatus:micstatus];
}

+ (void)obtainAVMediaAudioAuthorizedStatus {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        [self ShowGranted:granted];
    }];
}

#pragma mark - 是否开启提醒事项权限
+ (BOOL)isObtainReminder {
    EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    return [self isObtainWithStatus:status];
}

+ (void)obtainEKReminderAuthorizedStatus {
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        [self ShowGranted:granted];
    }];
}

#pragma mark - 开启运动与健身权限(需要的运动权限自己再加,目前仅有"步数"、"步行+跑步距离"、"心率")
+ (void)obtainHKHealthAuthorizedStatus {
    HKHealthStore *health = [[HKHealthStore alloc] init];
    NSSet *readObjectTypes =[NSSet setWithObjects:
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],//Cumulative
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],   //跑步
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],    //体重
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],    //心率
                             nil];
    
    [health requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
        [self ShowGranted:success];
    }];
}

#pragma mark - 是否开启语音识别事项权限
+ (BOOL)isObtainSpeechRecognizer {
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    return [self isObtainWithStatus:status];
}

+ (void)obtainSpeechRecognizeAuthorizedStatus {
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 是否授权状态判断
+ (BOOL)isObtainWithStatus:(NSInteger)status {
    
    if (status == LXAuthorizationStatusDenied) {
        DLog(@"用户拒绝App使用(Denied)");
        return NO;
    }else if (status == LXAuthorizationStatusNotDetermined){
        DLog(@"未选择权限(NotDetermined)");
        return NO;
    }else if (status == LXAuthorizationStatusRestricted){
        DLog(@"未授权(Restricted)");
        return NO;
    }
    DLog(@"权限:已授权(Authorized)"); //EKAuthorizationStatusAuthorized
    return YES;
}

+ (void)ShowGranted:(BOOL)success {
    if (success == YES) {
        DLog(@"开启权限:成功");
    }else{
        DLog(@"开启权限:失败");
    }
}

@end
