//
//  VideoTitleTextModel.h
//  RongMei
//
//  Created by jimmy on 2018/12/14.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoTitleTextModel : JSONModel

///标题
@property (nonatomic,copy)  NSString<Optional>  * title;
///创建时间
@property (nonatomic,copy)  NSString<Optional>  * createTime;
///浏览数
@property (nonatomic,copy)  NSString<Optional>  * lookNum;

@property (nonatomic,copy)  NSString<Optional>  * author;

@property (nonatomic,copy)  NSString<Optional>  * editor;

@end

NS_ASSUME_NONNULL_END
