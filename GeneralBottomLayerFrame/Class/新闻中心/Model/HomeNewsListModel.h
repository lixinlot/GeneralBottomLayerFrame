//
//  HomeNewsListModel.h
//  RongMei
//
//  Created by jimmy on 2018/12/5.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsListModel;

@interface HomeNewsAllModel : NSObject

@property (nonatomic, strong) HomeNewsListModel * homeNewsListModel;
///0是没有图片  1是只有一张图片  2是有三张图片
@property (nonatomic, assign) NSInteger  type;

@end

@interface HomeNewsListModel : NSObject

///新闻ID
//@property (nonatomic,assign)NSInteger     newsId;

@property (nonatomic,copy)  NSString   *  title;

@property (nonatomic,copy)  NSString   *  date;

@property (nonatomic,copy)  NSString   *  category;

@property (nonatomic,copy)  NSString   *  author_name;

@property (nonatomic,copy)  NSString   *  url;

@property (nonatomic,copy)  NSString   *  thumbnail_pic_s;

@property (nonatomic,copy)  NSString   *  thumbnail_pic_s02;

@property (nonatomic,copy)  NSString   *  thumbnail_pic_s03;

@end


NS_ASSUME_NONNULL_END
