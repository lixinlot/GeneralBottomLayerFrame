//
//  PopCoverView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/21.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "PopCoverView.h"
#import "PopCoverEnum.h"
#import "UIView+Utils.h"

#pragma mark - 内部记录
static PopCoverView     *_cover;           // 遮罩
static UIView           *_fromView;        // 显示在此视图上
static UIView           *_contentView;     // 显示的视图
static showBlock         _showBlock;       // 显示时的回调block
static hideBlock         _hideBlock;       // 隐藏时的回调block
static BOOL              _notclick;        // 是否能点击的判断
static PopCoverStyle     _style;           // 遮罩类型
static PopCoverShowStyle _showStyle;       // 显示类型
static BOOL              _hasCover;        // 遮罩是否已经显示的判断值
static BOOL              _isHideStatusBar; // 遮罩是否遮盖状态栏

// 分离动画类型
static PopCoverShowAnimStyle _showAnimStyle;
static PopCoverHideAnimStyle _hideAnimStyle;

static UIColor          *_bgColor;         // 背景色

@implementation PopCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 自动伸缩
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

+ (instancetype)cover {
    // cover一经初始化就存在
    _hasCover = YES;
    return [[self alloc] init];
}

#pragma mark - 判断是否已经有cover
+ (BOOL)hasCover {
    return _hasCover;
}

#pragma mark - 分离弹出和隐藏时的动画
+ (void)coverFrom:(UIView *)fromView contentView:(UIView *)contentView style:(PopCoverStyle)style showStyle:(PopCoverShowStyle)showStyle showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle notClick:(BOOL)notClick {
    [self coverFrom:fromView contentView:contentView style:style showStyle:showStyle showAnimStyle:showAnimStyle hideAnimStyle:hideAnimStyle notClick:notClick showBlock:nil hideBlock:nil];
}

#pragma mark - 分离弹出和隐藏时的动画
+ (void)coverFrom:(UIView *)fromView contentView:(UIView *)contentView style:(PopCoverStyle)style showStyle:(PopCoverShowStyle)showStyle showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle notClick:(BOOL)notClick showBlock:(showBlock)showBlock hideBlock:(hideBlock)hideBlock {
    if ([self hasCover]) return;
    
    _style         = style;
    _showStyle     = showStyle;
    _showAnimStyle = showAnimStyle;
    _hideAnimStyle = hideAnimStyle;
    _fromView      = fromView;
    _contentView   = contentView;
    _notclick      = notClick;
    _showBlock     = showBlock;
    _hideBlock     = hideBlock;
    
    // 创建遮罩
    PopCoverView *cover = [self cover];
    // 设置大小和颜色
    cover.frame = fromView.bounds;
    // 添加遮罩
    [fromView addSubview:cover];
    _cover = cover;
    
    switch (style) {
            case PopCoverStyleTranslucent: // 半透明
            [self setupTranslucentCover:cover];
            break;
            case PopCoverStyleTransparent: // 全透明
            [self setupTransparentCover:cover];
            break;
            case PopCoverStyleBlur:        // 高斯模糊
            [self setupBlurCover:cover];
            break;
            
        default:
            break;
    }
    
    [self showCover];
}

+ (void)coverHideStatusBarWithContentView:(UIView *)contentView style:(PopCoverStyle)style showStyle:(PopCoverShowStyle)showStyle showAnimStyle:(PopCoverShowAnimStyle)showAnimStyle hideAnimStyle:(PopCoverHideAnimStyle)hideAnimStyle notClick:(BOOL)notClick showBlock:(showBlock)showBlock hideBlock:(hideBlock)hideBlock {
    
    if ([self hasCover]) return;
    
    _isHideStatusBar = YES;
    
    _style         = style;
    _showStyle     = showStyle;
    _showAnimStyle = showAnimStyle;
    _hideAnimStyle = hideAnimStyle;
    _contentView   = contentView;
    _notclick      = notClick;
    _showBlock     = showBlock;
    _hideBlock     = hideBlock;
    
    UIWindow *fromView   = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fromView.windowLevel = UIWindowLevelAlert;
    fromView.hidden      = NO;
    [fromView makeKeyAndVisible];
    
    _fromView = fromView;
    
    // 创建遮罩
    PopCoverView *cover = [self cover];
    // 设置大小和颜色
    cover.frame = fromView.bounds;
    // 添加遮罩
    [fromView addSubview:cover];
    _cover = cover;
    
    switch (style) {
            case PopCoverStyleTranslucent: // 半透明
            [self setupTranslucentCover:cover];
            break;
            case PopCoverStyleTransparent: // 全透明
            [self setupTransparentCover:cover];
            break;
            case PopCoverStyleBlur:        // 高斯模糊
            [self setupBlurCover:cover];
            break;
            
        default:
            break;
    }
    
    [self showCover];
}

#pragma mark - 中间弹窗动画
+ (void)animationAlert:(UIView*)view {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = _cover;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark - 显示Cover
+ (void)showCover {
    [_fromView addSubview:_contentView];
    
    switch (_showStyle) {
            case PopCoverShowStyleTop: {  // 显示在顶部
                _contentView.centerX = _fromView.centerX;
                if (_showAnimStyle == PopCoverShowAnimStyleTop) {
                    _contentView.top = -_contentView.height;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = 0;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else{
                    !_showBlock ? : _showBlock();
                    _contentView.top = 0;
                }
            }
            break;
            case PopCoverShowStyleCenter: {  // 显示在中间
                _contentView.centerX = _fromView.centerX;
                if (_showAnimStyle == PopCoverShowAnimStyleTop) { // 上进
                    _contentView.top = -_contentView.height;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.center = _fromView.center;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else if (_showAnimStyle == PopCoverShowAnimStyleCenter) { // 中间动画
                    _contentView.center = _fromView.center;
                    [self animationAlert:_contentView];
                }else if (_showAnimStyle == PopCoverShowAnimStyleBottom) { // 下进
                    _contentView.top = _fromView.height;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.center = _fromView.center;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else{ // 无动画
                    _contentView.center = _fromView.center;
                    !_showBlock ? : _showBlock();
                }
            }
            break;
            case PopCoverShowStyleBottom: { // 显示在底部
                _contentView.centerX = _fromView.centerX;
                if (_showAnimStyle == PopCoverShowAnimStyleBottom) {
                    _contentView.top = _fromView.height;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = _fromView.height - _contentView.height;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else{
                    !_showBlock ? : _showBlock();
                    _contentView.top = _fromView.height - _contentView.height;
                }
            }
            break;
            case PopCoverShowStyleLeft: { // 显示在左侧
                _contentView.centerY = _fromView.height * 0.5f;
                if (_showAnimStyle == PopCoverShowAnimStyleLeft) {
                    _contentView.left = -_contentView.width;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.left = 0;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else {
                    !_showBlock ? : _showBlock();
                    _contentView.left = 0;
                }
            }
            break;
            case PopCoverShowStyleRight: { // 显示在右侧
                _contentView.centerY = _fromView.height * 0.5f;
                if (_showAnimStyle == PopCoverShowAnimStyleRight) {
                    _contentView.right = KScreenW + _contentView.width;
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.right = KScreenW;
                    }completion:^(BOOL finished) {
                        !_showBlock ? : _showBlock();
                    }];
                }else {
                    !_showBlock ? : _showBlock();
                    _contentView.right = KScreenW;
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 隐藏Cover
+ (void)hideCover {
    // 这里为了防止动画未完成导致的不能及时判断cover是否存在，实际上cover再这里并没有销毁
    _hasCover = NO;
    
    switch (_showStyle) {
            case PopCoverShowStyleTop: { // 显示在顶部
                if (_hideAnimStyle == PopCoverHideAnimStyleTop) {
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = -_contentView.height;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else{
                    _contentView.top = -_contentView.height;
                    [self remove];
                }
            }
            break;
            case PopCoverShowStyleCenter: { // 显示在中间
                if (_hideAnimStyle == PopCoverHideAnimStyleTop) { // 上出
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = -_contentView.height;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else if (_hideAnimStyle == PopCoverHideAnimStyleCenter) { // 中间动画
                    [self remove];
                }else if (_hideAnimStyle == PopCoverHideAnimStyleBottom) { // 下出
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = _fromView.height;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else{ // 无动画
                    _contentView.center = _fromView.center;
                    [self remove];
                }
            }
            break;
            case PopCoverShowStyleBottom: { // 显示在底部
                if (_hideAnimStyle == PopCoverHideAnimStyleBottom) {
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.top = _fromView.height;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else{
                    _contentView.top = _fromView.height;
                    [self remove];
                }
            }
            break;
            case PopCoverShowStyleLeft: { // 显示在左侧
                if (_hideAnimStyle == PopCoverHideAnimStyleLeft) {
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.left = -_contentView.width;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else{
                    _contentView.left = -_contentView.width;
                    [self remove];
                }
            }
            break;
            case PopCoverShowStyleRight: { // 显示在右侧
                if (_hideAnimStyle == PopCoverHideAnimStyleRight) {
                    [UIView animateWithDuration:kAnimDuration animations:^{
                        _contentView.left = KScreenW;
                    }completion:^(BOOL finished) {
                        [self remove];
                    }];
                }else{
                    _contentView.left = KScreenW;
                    [self remove];
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 半透明遮罩
+ (void)setupTranslucentCover:(UIView *)cover {
    cover.backgroundColor = _bgColor ? _bgColor : [UIColor blackColor];
    cover.alpha = kAlpha;
    [self coverAddTap:cover];
}

#pragma mark - 全透明遮罩
+ (void)setupTransparentCover:(UIView *)cover {
    cover.backgroundColor = [UIColor clearColor];
    [cover addSubview:[self coverTransparentBgView]];
}

+ (UIView *)coverTransparentBgView {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.size = _cover.size;
    bgView.userInteractionEnabled = YES;
    [self coverAddTap:bgView];
    return bgView;
}

#pragma mark - 高斯模糊遮罩
+ (void)setupBlurCover:(UIView *)cover {
    cover.backgroundColor = [UIColor clearColor];
    [self coverAddTap:cover];
    // 添加高斯模糊效果,添加毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = cover.bounds;
    
    [cover addSubview:effectview];
}

+ (void)coverAddTap:(UIView *)cover {
    if (!_notclick) {
        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover)]];
    }
}

+ (void)remove {
    [_cover removeFromSuperview];
    [_contentView removeFromSuperview];
    if (_isHideStatusBar) {
        _isHideStatusBar = NO;
        
        UIWindow *coverWindow = (UIWindow *)_fromView;
        coverWindow.hidden = YES;
        [coverWindow resignKeyWindow];
        coverWindow = nil;
    }
    
    _cover       = nil;
    _contentView = nil;
    
    // 隐藏block放到最后，修复多个cover不能隐藏的bug
    !_hideBlock ? : _hideBlock();
}

+ (void)layoutSubViews {
    _contentView.centerX = _fromView.centerX;
    
    switch (_showStyle) {
            case PopCoverShowStyleTop:
        {
            _contentView.top = 0;
        }
            break;
            case PopCoverShowStyleCenter:
        {
            _contentView.center = _fromView.center;
        }
            break;
            case PopCoverShowStyleBottom:
        {
            _contentView.left = _fromView.height - _contentView.height;
        }
            break;
            
        default:
            break;
    }
}

+ (void)hideCoverWithHideBlock:(hideBlock)hideBlock {
    _hideBlock = hideBlock;
    [PopCoverView hideCover];
}

+ (void)changeCoverBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _cover.backgroundColor = bgColor;
}


@end
