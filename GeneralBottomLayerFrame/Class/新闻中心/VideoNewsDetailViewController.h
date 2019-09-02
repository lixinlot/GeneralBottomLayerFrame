//
//  VideoNewsDetailViewController.h
//  RongMei
//
//  Created by jimmy on 2018/12/6.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoNewsDetailViewController : BaseViewController

///视频链接
@property (nonatomic,copy)  NSString  * videoUrl;

@property (nonatomic,assign)NSInteger   newsId;

@property (nonatomic,copy)  NSString  * picUrl;

@end

NS_ASSUME_NONNULL_END
