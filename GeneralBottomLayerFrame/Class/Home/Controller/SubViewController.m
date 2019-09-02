//
//  SubViewController.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/20.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()

/// 标签
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
//    WeakObj(self);
//    UIPreviewAction *confirmAction = [UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"置顶");
//    }];
//
//    UIPreviewAction *defaultAction = [UIPreviewAction actionWithTitle:@"标为未读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"标为未读");
//    }];
//
//    UIPreviewAction *cancelAction = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        if (selfWeak.deleteSelectRow) {
//            selfWeak.deleteSelectRow(selfWeak.indexpath);
//        }
//
//        NSLog(@"删除了");
//    }];
//
//    return @[confirmAction, defaultAction,cancelAction];
    
    return self.actions;
}

#pragma mark - Set方法
-(void)setText:(NSString *)text {
    _textStr = text;
    
    self.textLabel.text = text;
}

#pragma mark - Get方法
-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 50)];
        _textLabel.center = self.view.center;
        
        [self.view addSubview:_textLabel];
    }
    
    return _textLabel;
}

@end
