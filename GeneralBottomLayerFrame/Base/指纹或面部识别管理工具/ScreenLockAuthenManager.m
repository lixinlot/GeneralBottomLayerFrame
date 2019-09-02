//
//  ScreenLockAuthenManager.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/12.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "ScreenLockAuthenManager.h"
#import "KeychainItemWrapper.h"
#import <LocalAuthentication/LocalAuthentication.h>

static ScreenLockAuthenManager *_instance;
#define kGestureKeychain             @"Gesture"
#define kFingerMarkKeychain          @"fingerMark"
#define kNotificationForFingerprintLock @"app.notification.screenLock.fingerprint"
#define kNotificationForScreenUnlock @"app.notification.screeenUnlock"

@implementation ScreenLockAuthenManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

- (BOOL)touchIDSupport {
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    return success;
}

//面容、还是指纹
- (BOOL)faceID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (@available(iOS 11.0, *)) {
//        iOS 11后LAContext新增一个只读属性biometryType，该属性表示当前设备支持生物识别类型（是Touch ID还是Face ID）
//        LABiometryTypeNone      表示设备不支持生物识别技术
//        LABiometryNone          在iOS 11中已经过时，使用LABiometryTypeNone代替
//        LABiometryTypeTouchID   表示当前设备支持指纹识别
//        LABiometryTypeFaceID    表示当前设备支持人脸识别
//        使用Face ID功能必须要在Info.plist中加入Privacy - Face ID Usage Description并添加准确的使用描述。
        if (context.biometryType == LABiometryTypeFaceID){
            return YES;
        }
    }
    return NO;
}

- (BOOL)existGestureLock {
    KeychainItemWrapper *gestureKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:kGestureKeychain accessGroup:nil];
    NSString *code = [gestureKeychain objectForKey:(__bridge id)kSecValueData];
    return code.length?YES:NO;
}

- (BOOL)existFingerprintLock {
    KeychainItemWrapper *fingerprintKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:kFingerMarkKeychain accessGroup:nil];
    NSString *code = [fingerprintKeychain objectForKey:(__bridge id)kSecValueData];
    return code.length?YES:NO;
}

- (void)setLockType:(GjjScreenLockType)lockType {
    if ((_lockType == GjjScreenLockTypeGestureUnlock || _lockType == GjjScreenLockTypeFingerprintUnlock) && lockType == GjjScreenLockTypeNone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForScreenUnlock object:nil];
    }
    _lockType = lockType;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [ScreenLockAuthenManager shareInstance];
}

+ (void)verifyTouchID {
    //LAContext为贯穿整个识别过程的对象类型。使用识别必须初始化一个LAContext对象。
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    NSError *evaluateError = nil;
    //在进行指纹（人脸）识别前，需要判断识别功能是否可用，上面代码中的canEvaluatePolicy: error :方法就是做这样一件事情。当方法返回YES时则可以继续调用识别方法。否则需要根据error的描述来提示用户。该方法的policy参数决定了鉴权的行为方式
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics指纹（人脸）识别。验证弹框有两个按钮，第一个是取消按钮，第二个按钮可以自定义标题名称（输入密码）。只有在第一次指纹验证失败后才会出现第二个按钮，这种方式下的第二个按钮功能需要自己定义。前三次指纹验证失败，指纹验证框不再弹出。再次重新进入验证，还有两次验证机会，如果还是验证失败，TOUCH ID 被锁住不再继续弹出指纹验证框。以后的每次验证都将会弹出设备密码输入框直至输入正确的设备密码才能重新使用指纹（人脸）识别
    BOOL success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&evaluateError];
    NSString *myLocalizedReasonString = nil;
    NSString *successTip = nil;
    NSString *errorTip = nil;
    if (@available(iOS 11.0, *)) {
        if (context.biometryType == LABiometryTypeFaceID){
            myLocalizedReasonString = @" 请验证面容ID";
            successTip = @"面容密码开启成功";
            errorTip = @"验证手机锁屏密码，解锁面容";
        }else{
            myLocalizedReasonString = @"请按Home键验证指纹";
            successTip = @"指纹密码开启成功";
            errorTip = @"验证手机锁屏密码，解锁指纹";
        }
    }
    else{
        myLocalizedReasonString = @"请按Home键验证指纹";
        successTip = @"指纹密码开启成功";
        errorTip = @"验证手机锁屏密码，解锁指纹";
    };
    if (success) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintSet) {
//                        [GjjHintView showWithViewController:[GjjUtil topViewController] andText:successTip];
                        [self fingerprintSetSuccess];
                        NSDictionary *dict = @{@"finger" : @"1"};
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForFingerprintLock object:dict];
                    }else if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintUnlock){
                        [self clearScreenLockControllerAndBack];
                    }
                    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintSet) {
                        NSDictionary *dict = @{@"finger" : @"0"};
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForFingerprintLock object:dict];
                    }
                });
            }
        }];
        return;
    }else{
        if (evaluateError.code == LAErrorTouchIDLockout) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:errorTip reply:^(BOOL success, NSError * _Nullable error){
                    
                }];
            });
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置Touch ID，请在手机系统“设置>Touch ID与密码”中添加指纹" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            NSDictionary *dict = @{@"finger" : @"0"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForFingerprintLock object:dict];
        }
    }
}

+ (void)openScreenLock {
//    if (![GsDataSource sharedInstance].userGeneral.phone.length) {
//        [ScreenLockAuthenManager clearScreenLock];
//        return;
//    }
    if ([ScreenLockAuthenManager shareInstance].unlocked) {
        //打开系统功能，如相册，模态出来的时候，防止launch再次打开
        return;
    }
//    UIViewController *topController = [GjjUtil topViewController];
    if ([ScreenLockAuthenManager shareInstance].existGestureLock) {
        [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeGestureUnlock;
//        GjjScreenLockController *controller = [GjjScreenLockController new];
//        [topController.navigationController pushViewController:controller animated:NO];
    }else if ([ScreenLockAuthenManager shareInstance].existFingerprintLock) {
        [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeFingerprintUnlock;
//        GjjScreenLockController *controller = [GjjScreenLockController new];
//        [topController.navigationController pushViewController:controller animated:NO];
    }
}

+ (void)openSetFingerprint {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeFingerprintSet;
    [self verifyTouchID];
}

+ (void)openUnlockFingerprint {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeFingerprintUnlock;
    [self verifyTouchID];
}

+ (void)openCloseGesture {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeGestureClose;
//    UIViewController *topController = [GjjUtil topViewController];
//    GjjScreenLockController *controller = [GjjScreenLockController new];
//    [topController.navigationController pushViewController:controller animated:YES];
}

+ (void)openSetGesture {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeGestureSet;
//    UIViewController *topController = [GjjUtil topViewController];
//    GjjScreenLockController *controller = [GjjScreenLockController new];
//    [topController.navigationController pushViewController:controller animated:YES];
}

+ (NSString *)gesturePassword {
    KeychainItemWrapper *gestureKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:kGestureKeychain accessGroup:nil];
    NSString *code = [gestureKeychain objectForKey:(__bridge id)kSecValueData];
    return code.length?code:nil;
}

+ (void)clearScreenLock {
    [self clearGestureLock];
    [self clearFingerprintLock];
}

+ (void)clearGestureLock {
    KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc]initWithIdentifier:kGestureKeychain accessGroup:nil];
    [keychin resetKeychainItem];
}

+ (void)clearFingerprintLock {
    KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc]initWithIdentifier:kFingerMarkKeychain accessGroup:nil];
    [keychin resetKeychainItem];
}

+ (void)gestureSetSuccess:(NSString *)password {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
    [self clearFingerprintLock];
    KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc]initWithIdentifier:kGestureKeychain accessGroup:nil];
    [keychin setObject:[NSString stringWithFormat:@"gestureService"] forKey:(__bridge id)kSecAttrService];
    [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
    [keychin setObject:password forKey:(__bridge id)kSecValueData];
}

+ (void)fingerprintSetSuccess {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
    [self clearGestureLock];
    KeychainItemWrapper *fingerMarkKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:kFingerMarkKeychain accessGroup:nil];
    [fingerMarkKeyChain setObject:[NSString stringWithFormat:@"fignerMakrService"] forKey:(__bridge id)kSecAttrService];
    [fingerMarkKeyChain setObject:@"<指纹>" forKey:(__bridge id)kSecAttrAccount];
    [fingerMarkKeyChain setObject:@"YES" forKey:(__bridge id)kSecValueData];
}

+ (void)gestureUnlockSuccess {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
    [self clearScreenLockControllerAndBack];
}

+ (void)gestureCloseSuccess {
    [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
    [ScreenLockAuthenManager clearScreenLock];
    [self clearScreenLockControllerAndBack];
}

+ (void)forget {
    UIViewController *topController = [UIViewController new];
    //指纹解锁忘记密码，直接打开登录页
    if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintUnlock) {
//        [[NodeRequestManager sharedInstance] logoutWithSuccess:^(id responseObject) {
            [ScreenLockAuthenManager clearScreenLock];
            [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
//            [topController needJumpLoginView];
//        } failure:^(GsHttpError *error) {
            [ScreenLockAuthenManager clearScreenLock];
            [ScreenLockAuthenManager shareInstance].lockType = GjjScreenLockTypeNone;
//            [topController needJumpLoginView];
//        }];
        return;
    }
//    AuthLoginController *authViewController = [[AuthLoginController alloc] init];
//    authViewController.isRemoveGesturePassword = YES;
//    [topController.navigationController pushViewController:authViewController animated:NO];
}

+ (void)clearScreenLockControllerAndBack {
    //解锁后，把状态设置为yes
    [ScreenLockAuthenManager shareInstance].unlocked = YES;
    
    UIViewController *topController = [UIViewController new];
    UIViewController *GjjScreenLockController = [UIViewController new];
    UIViewController *AuthLoginController = [UIViewController new];
    if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureUnlock) {
        //启动解锁,提示用户重新设置手势密码
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解除手势密码成功" delegate:[ScreenLockAuthenManager shareInstance] cancelButtonTitle:@"进入首页" otherButtonTitles:@"重置手势密码", nil];
        alertView.tag = 1011;
        [alertView show];
        return;
    }
    NSMutableArray *controllers = topController.navigationController.viewControllers.mutableCopy;
    if ([topController isKindOfClass:GjjScreenLockController.class]) {
        if (controllers.count > 1) {
            NSInteger index = [controllers indexOfObject:topController];
            UIViewController *lastController = controllers[index - 1];
            if ([lastController isKindOfClass:AuthLoginController.class]) {
                [controllers removeObject:lastController];
            }
            NSArray *tmpControllers = controllers.copy;
            for (NSInteger i = 0; i < index - 1; i ++) {
                UIViewController *controller = tmpControllers[i];
                if ([controller isKindOfClass:GjjScreenLockController.class]) {
                    [controllers removeObject:controller];
                }
            }
            topController.navigationController.viewControllers = controllers;
        }
        BOOL animater = YES;
        if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureUnlock || [ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintUnlock) {
            animater = NO;
        }
        [topController.navigationController popViewControllerAnimated:animater];
    }else {
        NSArray *tmpControllers = controllers.copy;
        for (UIViewController *controller in tmpControllers) {
            if ([controller isKindOfClass:GjjScreenLockController.class]) {
                [controllers removeObject:controller];
            }
        }
        topController.navigationController.viewControllers = controllers;
        [topController.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1011) {
        if (0 == buttonIndex) {
            [ScreenLockAuthenManager clearScreenLockControllerAndBack];
        } else {
            //进入重置手势页
            [ScreenLockAuthenManager openSetGesture];
        }
    }
}

@end
