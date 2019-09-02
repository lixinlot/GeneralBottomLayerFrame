//
//  ScanViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/21.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "ScanViewController.h"
#import "WSLScanView.h"
#import "WSLNativeScanTool.h"
#import "WSLCreateQRCodeController.h"

@interface ScanViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)  WSLNativeScanTool * scanTool;
@property (nonatomic, strong)  WSLScanView * scanView;

@end

@implementation ScanViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidesBottomBarWhenPushed];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_scanView stopScanAnimation];
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_scanView startScanAnimation];
    [_scanTool sessionStartRunning];
    
    [self setViewUI];
}

#pragma mark - 设置当前页的视图UI
-(void)setViewUI
{
    UIButton * photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, NAVIGATION_BAR_HEIGHT/2, 64, NAVIGATION_BAR_HEIGHT/2)];
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, NAVIGATION_BAR_HEIGHT/2, SCREEN_WIDTH - 212, NAVIGATION_BAR_HEIGHT/2)];
    titleLabel.text = @"二维码/条码";
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.font = Kfont(18);
    [self.view addSubview:titleLabel];
    
    //输出流视图
    UIView *preview  = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:preview];
    
    __weak typeof(self) weakSelf = self;
    
    //构建扫描样式视图
    _scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    _scanView.scanRetangleRect = CGRectMake(60, 120, (SCREEN_WIDTH - 2 * 60),  (SCREEN_WIDTH - 2 * 60));
    _scanView.colorAngle = [UIColor greenColor];
    _scanView.photoframeAngleW = 20;
    _scanView.photoframeAngleH = 20;
    _scanView.photoframeLineW = 2;
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    _scanView.myQRCodeBlock = ^{
        NSLog(@"*********处理结果*********");
        
    };
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _scanTool = [[WSLNativeScanTool alloc] initWithPreview:preview andScanFrame:_scanView.scanRetangleRect];
    _scanTool.scanFinishedBlock = ^(NSString *scanString) {
        NSLog(@"扫描结果 %@",scanString);
        [weakSelf.scanView handlingResultsOfScan];
        
        
//         获取指定的Storyboard，name填写Storyboard的文件名
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
        WSLCreateQRCodeController *createQRCodeController = [storyboard instantiateViewControllerWithIdentifier:@"createQRCode"];
        createQRCodeController.qrImage =  [WSLNativeScanTool createQRCodeImageWithString:scanString andSize:CGSizeMake(250, 250) andBackColor:[UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1.0] andFrontColor:[UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1.0] andCenterImage:[UIImage imageNamed:@"piao"]];
        createQRCodeController.qrString = scanString;
        [weakSelf.navigationController pushViewController:createQRCodeController animated:YES];
        [weakSelf.scanTool sessionStopRunning];
        [weakSelf.scanTool openFlashSwitch:NO];
    };
    _scanTool.monitorLightBlock = ^(float brightness) {
        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    
    [_scanTool sessionStartRunning];
    [_scanView startScanAnimation];
    
}



#pragma mark -- Events Handle
- (void)photoBtnClicked
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持访问相册");
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    //    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_scanTool scanImageQRCode:image];
}

@end
