//
//  VideoNewsDetailViewController.m
//  RongMei
//
//  Created by jimmy on 2018/12/6.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "VideoNewsDetailViewController.h"
#import "VideoNewsTitleCell.h"
#import <SJVideoPlayer.h>

@interface VideoNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

///视频播放器
@property (nonatomic,strong)  SJVideoPlayer  * videoPlayer;
@property (nonatomic,strong)  UIImageView  * videoImage;
@property (nonatomic,strong)  UIButton     * playButton;

@property (nonatomic,strong)  BaseTableView  * tableView;
@property (nonatomic,strong)  NSMutableArray  * dataArray;

@property (nonatomic,copy)  NSString *videoString;

@end

@implementation VideoNewsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataArray = [NSMutableArray array];
    [self setTableViewUI];
    [self setVideoViewUI];
    [self getNewsDetailData];
}

#pragma mark- 请求新闻详情数据
- (void)getNewsDetailData
{
    WeakObj(self);
    NSString *urlStr = [NSString stringWithFormat:@"%@news/data/getNewsDetailById",REQUESTHEADER];
    NSDictionary *dict = @{@"newsId":@(self.newsId),@"currUserId":kNSUDefaultReadKey(@"userId")};
    [HttpManager postHttpRequestByGet:urlStr andParameter:dict success:^(id successResponse) {
        NSInteger status = [successResponse[@"code"] integerValue];
        if (!successResponse[@"result"] || [[NSNull null] isEqual:successResponse[@"result"]]) {
            [HttpManager showNoteMsg:@"该新闻已不存在"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        NSDictionary *resultDic = successResponse[@"result"];
        [selfWeak.dataArray removeAllObjects];
        selfWeak.videoString = resultDic[@"videoUrl"];
        if (status == 200) {
//            VideoTitleTextModel *model = [VideoTitleTextModel modelWithDictionary:resultDic];
//            [selfWeak.dataArray addObject:model];
//            [selfWeak setVideoViewUI];
        }else{
//            [HttpManager showNoteMsg:[NSString stringWithFormat:@"%@",successResponse[@"message"]]];
        }
        [selfWeak.tableView reloadData];
    } andFailure:^(id failureResponse) {
        [HttpManager showFail];
    }];
}

#pragma mark - 设置视频播放View
- (void)setVideoViewUI
{
    if (!self.videoPlayer) {
        self.videoPlayer = [SJVideoPlayer player];
        if (IS_PhoneXAll) {
            self.videoPlayer.view.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, ScreenX375(210));
        }else {
            self.videoPlayer.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(210));
        }
        
        [self.view addSubview:self.videoPlayer.view];
    }
    if (!self.videoImage) {
        self.videoImage = [[UIImageView alloc] init];
        if (IS_PhoneXAll) {
            self.videoImage.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, ScreenX375(210));
        }else {
            self.videoImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(210));
        }
        self.videoImage.userInteractionEnabled = YES;
        [self.view addSubview:self.videoImage];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX375(13), APP_STATUSBAR_HEIGHT+ScreenX375(10), ScreenX375(22), ScreenX375(22))];
        [leftButton setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self.videoImage addSubview:leftButton];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake((SCREEN_WIDTH-ScreenX375(40))/2, (ScreenX375(210)-ScreenX375(40))/2, ScreenX375(40), ScreenX375(40));
        [self.playButton setImage:ImageWithName(@"视频播放") forState:UIControlStateNormal];
        [self.videoImage addSubview:self.playButton];
    }
    
    [self.playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playClick
{
    [self ifNotAuthenticationShowAlert];
    self.videoImage.hidden = YES;
    self.playButton.hidden = YES;
    // 初始化资源
    if (self.videoUrl) {
        self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.videoUrl]];
    }else{
        self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.videoString]];
    }
}

#pragma mark - 设置tableView
- (void)setTableViewUI
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, ScreenX375(210), SCREEN_WIDTH, SCREEN_HEIGHT - ScreenX375(54)-ScreenX375(210)) style:UITableViewStylePlain];
    if (IS_PhoneXAll) {
        self.tableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT+ScreenX375(210), SCREEN_WIDTH, SCREEN_HEIGHT - ScreenX375(54)-ScreenX375(210));
    }
    self.tableView.backgroundColor = UIColorFromRGB(@"#F5F6F9", 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenX375(90);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoNewsTitleCell *cell = [VideoNewsTitleCell cellWithTableView:tableView];
    if (self.dataArray.count != 0) {
        VideoTitleTextModel *model = self.dataArray[0];
        cell.videoTitleTextModel = model;
    }
    
    return cell;
}

- (void)ifNotAuthenticationShowAlert
{
    if (![kNSUDefaultReadKey(@"isLogin") integerValue]) {
//        kKeyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
}

@end
