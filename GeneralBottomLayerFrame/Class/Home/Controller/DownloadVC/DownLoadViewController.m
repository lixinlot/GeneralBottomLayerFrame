//
//  DownLoadViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/27.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "DownLoadViewController.h"
#import "DownLoadTableViewCell.h"
#import "LXDownLoadManager.h"

NSString * const downloadURLString1 = @"http://yxfile.idealsee.com/9f6f64aca98f90b91d260555d3b41b97_mp4.mp4";
NSString * const downloadURLString2 = @"http://yxfile.idealsee.com/31f9a479a9c2189bb3ee6e5c581d2026_mp4.mp4";
NSString * const downloadURLString3 = @"http://yxfile.idealsee.com/d3c0d29eb68dd384cb37f0377b52840d_mp4.mp4";

#define kDownloadURL1 [NSURL URLWithString:downloadURLString1]
#define kDownloadURL2 [NSURL URLWithString:downloadURLString2]
#define kDownloadURL3 [NSURL URLWithString:downloadURLString3]

@interface DownLoadViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>

@property (nonatomic,strong)  BaseTableView   * tableView;


@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"下载"];
    [self setTableViewUI];
    
}

- (void)setTableViewUI
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenX375(88);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownLoadTableViewCell *cell = [DownLoadTableViewCell cellWithTableView:tableView indexPath:indexPath];
    
//    CGFloat progress = [[LXDownLoadManager sharedManager] fileHasDownloadedProgressOfURL:kDownloadURL1];
//    [cell setProgressLabelText:progress];
    cell.beginBlock = ^(UILabel * _Nonnull progressLabel, UIProgressView * _Nonnull progressView) {
        [self download:kDownloadURL1 progressLabel:progressLabel progressView:progressView title:@"开始"];
    };
    cell.resumeBlock = ^(UILabel * _Nonnull progressLabel, UIProgressView * _Nonnull progressView) {
        [self download:kDownloadURL1 progressLabel:progressLabel progressView:progressView title:@"暂停"];
    };
    
    return cell;
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个暂停按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"暂停"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加点击事件
        [[LXDownLoadManager sharedManager] suspendAllDownloads];
    }];
    // 添加一个删除下载按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加编辑事件
        [[LXDownLoadManager sharedManager] deleteAllFiles];
        
    }];
    topRowAction.backgroundColor = UIColorFromRGB(@"0x54a9dd", 1);
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
}

- (void)download:(NSURL *)URL progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView title:(NSString *)title
{
    if ([title isEqualToString:@"开始"]) {
        [[LXDownLoadManager sharedManager] downloadFileOfURL:URL state:^(LXDownloadState state) {

        } progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            progressView.progress = progress;
        } completion:^(BOOL success, NSString *filePath, NSError *error) {
            if (success) {
                NSLog(@"FilePath: %@", filePath);
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }else if ([title isEqualToString:@"暂停"]) {
        [[LXDownLoadManager sharedManager] resumeDownloadOfURL:URL];
    }
}

- (void)downloadFile
{
//    [self download:kDownloadURL1 progressLabel:self.progressLabel1 progressView:self.progressView1 button:sender];
}

- (NSInteger )getVideoInfoWithSourcePath:(NSString *)path
{
    NSInteger fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    return fileSize;
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath
{
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
    
}

@end
