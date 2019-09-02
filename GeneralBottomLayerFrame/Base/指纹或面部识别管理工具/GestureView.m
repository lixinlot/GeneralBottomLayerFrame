//
//  GestureView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/15.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "GestureView.h"
#import "GestureSlipView.h"
#import "GestureRoundButton.h"
#import "ScreenLockAuthenManager.h"

#define  WEAKSELF  __weak typeof(self) weakself = self;
#define  kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

@interface GestureView () <ResetGetureDelegate, BeginTouchDelegate, VertifacationDelegate>

@property (nonatomic, strong) UIImageView *avatarIcon;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) NSString *previousString;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) NSUInteger wrongCount;
@property (nonatomic, strong) GestureSlipView *gestureSlipView;

@end

@implementation GestureView

-(instancetype)init{
    self = [super init];
    if (self) {
        _buttons = @[].mutableCopy;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer new];
        gradientLayer.frame = [UIScreen mainScreen].bounds;
        gradientLayer.colors = @[(id)[[GestureRoundButton new] colorWithHexString:@"#474958" alpha:1].CGColor,(id)[[GestureRoundButton new] colorWithHexString:@"#32333a" alpha:1].CGColor];
        [self.layer addSublayer:gradientLayer];
        
        if ([ScreenLockAuthenManager shareInstance].lockType != GjjScreenLockTypeGestureUnlock && [ScreenLockAuthenManager shareInstance].lockType != GjjScreenLockTypeFingerprintUnlock) {
            [self addNavigationBar];
        }
        
        _avatarIcon = [UIImageView new];
        [_avatarIcon.layer setCornerRadius:34];
        _avatarIcon.clipsToBounds = YES;
        [self addSubview:_avatarIcon];
        [_avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(68);
            make.top.mas_equalTo(self).offset(94);
        }];
//        _avatarIcon.layout.y(94).width(68).height(68).center(UILayoutAttributeHorizontal);
//        [_avatarIcon setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"icon_mine_tx"]];
        
        _stateLabel = [UILabel new];
        _stateLabel.text = @"请绘制手势密码";
        [_stateLabel setTextColor:[UIColor whiteColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentCenter];
        [_stateLabel setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:_stateLabel];
//        _stateLabel.layout.follow(_avatarIcon,12).center(UILayoutAttributeHorizontal);
        
        UILabel *phoneLabel = [UILabel new];
        phoneLabel.font = [UIFont systemFontOfSize:12];
        phoneLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        [self addSubview:phoneLabel];
//        phoneLabel.layout.follow(_stateLabel, 8).center(UILayoutAttributeHorizontal);
        _phoneLabel = phoneLabel;
        
//        if ([GsDataSource sharedInstance].userGeneral.phone){
//            NSString *phone = [GsDataSource sharedInstance].userGeneral.phone;
//            if (phone.length==11) {
//                phone = [NSString stringWithFormat:@"%@****%@",
//                         [phone substringToIndex:3],
//                         [phone substringFromIndex:7]];
//            }
//            [phoneLabel setText:phone];
//        }
        
        if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureSet){
            [self addGestureView];
            [self thumbGestureView:nil];
        }else if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureClose){
            [self addGestureView];
            _titleLabel.text = @"验证手势密码";
        }else if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureUnlock){
            [self addGestureView];
        }else if ([ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeFingerprintUnlock){
            [self addFingerprintView];
        }
    }
    return self;
}

- (void)addNavigationBar {
    UIImageView *backIcon = [UIImageView new];
    backIcon.userInteractionEnabled = YES;
    backIcon.image = [UIImage imageNamed:@"ico_title_back"];
    [self addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(self).offset(kStatusBarHeight+6);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backIcon);
        make.center.mas_equalTo(self.center);
    }];
    _titleLabel = titleLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [backIcon addGestureRecognizer:tap];
}

- (void)addFingerprintView {
    NSString *title = nil;
    NSString *tip = nil;
    if ([ScreenLockAuthenManager shareInstance].faceID) {
        title = @"面容验证";
        tip = @"点击进行面容解锁";
    }else{
        title = @"指纹验证";
        tip = @"点击进行指纹解锁";
    }
    _stateLabel.text = title;
    UIButton *fingerButton = [UIButton new];
    [fingerButton setImage:[UIImage imageNamed:@"ico_zhiwen"] forState:UIControlStateNormal];
    [fingerButton addTarget:self action:@selector(touchIDUnlock) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fingerButton];
//    fingerButton.layout.center(UILayoutAttributeHorizontal|UILayoutAttributeVertical).size(CGSizeMake(72.0, 72.0));
    
    WEAKSELF
//    UILabel *label = [UILabel createLabelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] text:tip];
//    [label addAction:^{
//        [weakself touchIDUnlock];
//    }];
//    [self addSubview:label];
//    label.layout.center(UILayoutAttributeHorizontal).follow(fingerButton,20);
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetButton setTitle:@"更换其他帐号" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetGesture) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.alpha = 0.8;
    [self addSubview:forgetButton];
//    forgetButton.layout.center(UILayoutAttributeHorizontal).bottom.spacing(self.layout.bottom,-44);
    
    [self performSelector:@selector(touchIDUnlock) withObject:nil afterDelay:1];
}

- (void)addGestureView {
    UIView *buttonView = [UIView new];
    [self addSubview:buttonView];
//    buttonView.layout.center(UILayoutAttributeHorizontal).follow(_phoneLabel,36).width((68+24)*3-24).height((68+24)*3-24);
    for (int i=0; i<9; i++) {
        NSInteger row = i/3;
        NSInteger col = i%3;
        // Button Frame
        GestureRoundButton * gesturePasswordButton = [GestureRoundButton new];
        [gesturePasswordButton setTag:i];
        [buttonView addSubview:gesturePasswordButton];
//        gesturePasswordButton.layout.x(col*(68+24)).y(row*(68+24)).width(68).height(68);
        [_buttons addObject:gesturePasswordButton];
    }
    GestureSlipView *gestureSlipView = [GestureSlipView new];
    gestureSlipView.style = [ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureSet?2:1;
    [gestureSlipView setButtonArray:_buttons];
    gestureSlipView.beginTouchDelegate = self;
    gestureSlipView.resetDelegate = self;
    gestureSlipView.vertifacationDelegate = self;
    [buttonView addSubview:gestureSlipView];
//    gestureSlipView.layout.fullWidth().fullHeight();
    _gestureSlipView = gestureSlipView;
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.hidden = [ScreenLockAuthenManager shareInstance].lockType == GjjScreenLockTypeGestureSet?YES:NO;
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetGesture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetButton];
//    forgetButton.layout.base(kScreenWidth>320?44:20).center(UILayoutAttributeHorizontal);
}

//手势缩略t
- (void)thumbGestureView:(NSString *)password {
    if (_thumbView) {
        [_thumbView removeFromSuperview];
    }
    _thumbView = [UIView new];
    for (int i=0; i<9; i++) {
        NSInteger row = i/3;
        NSInteger col = i%3;
        GestureRoundButton * gesturePasswordButton = [GestureRoundButton new];
        gesturePasswordButton.thumb = YES;
        [gesturePasswordButton setTag:i];
        [_thumbView addSubview:gesturePasswordButton];
//        gesturePasswordButton.layout.x(col*14).y(row*14).width(12).height(12);
        
        NSString *numStr = [NSString stringWithFormat:@"%d",i];
        if ([password rangeOfString:numStr].length > 0) {
            [gesturePasswordButton setSelected:YES];
            [gesturePasswordButton setSuccess:YES];
        }
    }
    [self addSubview:_thumbView];
//    _thumbView.layout.width(40).height(40).center(UILayoutAttributeHorizontal).equalBottom(_avatarIcon).y(148);
    
    _avatarIcon.hidden = YES;
//    _avatarIcon.layout.remove(UILayoutAttributeTop);
}

- (void)hideThumbView {
    _avatarIcon.hidden = NO;
//    _avatarIcon.layout.remove(UILayoutAttributeTop).y(94);
    if (_thumbView) {
        [_thumbView removeFromSuperview];
        _thumbView = nil;
    }
}

- (BOOL)resetPassword:(NSString *)result{
    if (!_previousString){
        _previousString = result;
        if (result.length >= 4){
            [_gestureSlipView enterAgin];
            _stateLabel.textColor = [UIColor whiteColor];
            _stateLabel.text = @"请再次绘制手势密码!";
            [self thumbGestureView:_previousString];
            return YES;
        }else{
            _previousString = nil;
            _stateLabel.textColor = [[GestureRoundButton new] colorWithHexString:@"#ff4e4e" alpha:1];
            _stateLabel.text = @"至少连接4个点！请重新绘制";
            [self thumbGestureView:nil];
            [self performSelector:@selector(clearTentacleView) withObject:self afterDelay:.4];
            return NO;
        }
    }else{
        if ([result isEqualToString:_previousString]){
            _stateLabel.textColor = [UIColor whiteColor];
            _stateLabel.text = @"已保存手势密码";
            NSDictionary *dict = @{@"gesture" : @"1"};
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForFingerprintLock object:dict];
            [ScreenLockAuthenManager gestureSetSuccess:result];
            [ScreenLockAuthenManager clearScreenLockControllerAndBack];
            return YES;
        }else{
            _previousString = nil;
            _stateLabel.textColor = [[GestureRoundButton new] colorWithHexString:@"#ff4e4e" alpha:1];
            _stateLabel.text = @"两次密码不一致，请重新设置";
            [self thumbGestureView:nil];
            [self performSelector:@selector(clearTentacleView) withObject:self afterDelay:.4];
            return NO;
        }
    }
}

-(BOOL)verification:(NSString *)result{
//    if ([result isEqualToString:[GjjScreenLockManager gesturePassword]]){
//        _stateLabel.textColor = [UIColor whiteColor];
//        _stateLabel.text = @"输入正确";
//        if ([GjjScreenLockManager shareInstance].lockType == GjjScreenLockTypeGestureClose){
//            [GjjScreenLockManager gestureCloseSuccess];
//        }else if ([GjjScreenLockManager shareInstance].lockType == GjjScreenLockTypeGestureUnlock){
//            [GjjScreenLockManager gestureUnlockSuccess];
//        }
//        return YES;
//    }
//    _stateLabel.textColor = [UIColor colorWithRGB:@"#ff4e4e"];
//    _stateLabel.text = @"手势密码错误";
//    [self performSelector:@selector(clearTentacleView) withObject:self afterDelay:.4];
//    _wrongCount++;
//    if (_wrongCount >= 5) {
//        _wrongCount = 0;
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"您已输错5次手势密码，是否需要解除手势密码？"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"解除", nil];
//        alertView.tag = 1000;
//        [alertView show];
//    }
    return NO;
}

- (void)gestureTouchBegin {
    
}

//- (void)clearTentacleView {
//    [_tentacleView  enterArgin];
//}
//
//- (void)touchIDUnlock {
//    [GjjScreenLockManager openUnlockFingerprint];;
//}
//
//- (void)forgetGesture {
//    [GjjScreenLockManager forget];
//}
//
//- (void)back {
//    [GjjScreenLockManager clearScreenLockControllerAndBack];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 1000) {
//        if (buttonIndex == 0) {
//            _stateLabel.textColor = [UIColor whiteColor];
//            _stateLabel.text = @"请绘制手势密码";
//        }else{
//            [GjjScreenLockManager forget];
//        }
//    }
//}

@end
