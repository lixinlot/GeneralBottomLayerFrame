//
//  NewsCommentListModel.h
//  RongMei
//
//  Created by jimmy on 2018/12/17.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NewsCommentListModel;

@protocol NewsCommentConnectListModel

@end

@interface NewsCommentListAllModel : JSONModel

@property (nonatomic,strong)  NewsCommentListModel   *newsCommentListModel;
///一级评论的高度
@property (nonatomic,assign)  CGFloat   commentHeight;
///评论的总高度
@property (nonatomic,assign)  CGFloat   allCommentHeight;

///当前页
@property (nonatomic,assign)  NSInteger   currentPage;
///总页数
@property (nonatomic,assign)  NSInteger   allPages;

@property (nonatomic,assign)  BOOL   isSelect;

@end


@interface NewsCommentListModel : JSONModel

///评论ID
@property (nonatomic,copy)  NSString<Optional>*  Id;
///帖子ID
@property (nonatomic,copy)  NSString<Optional>*  itemId;
///父评论Id
@property (nonatomic,copy)  NSString<Optional>*  parentId;
///评论内容时间
@property (nonatomic,copy)  NSString<Optional>*  createTime;
///用户昵称
@property (nonatomic,copy)  NSString<Optional>*  nickName;
///新闻类型
@property (nonatomic,copy)  NSString<Optional>*  newsType;
///用户头像
@property (nonatomic,copy)  NSString<Optional>*  headPortrait;
///评论内容
@property (nonatomic,copy)  NSString<Optional>*  content;
///回复对象评论id 2级评论id
@property (nonatomic,copy)  NSString<Optional>*   grandparentId;
///
//@property (nonatomic,copy)  NSString<Optional>* appraiseUserId;
///评论对象名字
@property (nonatomic,copy)  NSString<Optional>* appraiseNickName;
///评论对象头像
@property (nonatomic,copy)  NSString<Optional>* appraiseHeadPortrait;

///评论赞数量
@property (nonatomic,copy)  NSString<Optional>* newsAppraiseZanNum;
///评论赞数量
@property (nonatomic,copy)  NSString<Optional>* forumAppraiseZanNum;
///帖子标题
@property (nonatomic,copy)  NSString<Optional>* newsTitle;

@property (nonatomic,copy)  NSString<Optional>* title;
///0:赞 1:取消赞
@property (nonatomic,copy)  NSString<Optional>* isSelfZan;

///子评论
@property (nonatomic,strong)  NSArray<NewsCommentConnectListModel,Optional>*  appraises;

///回放id
@property (nonatomic,copy)  NSString<Optional>* playbackId;
///回放视频id
@property (nonatomic,copy)  NSString<Optional>* playbackVideoId;
///点赞数
@property (nonatomic,copy)  NSString<Optional>* zanNum;
///回放描述
@property (nonatomic,copy)  NSString<Optional>* Description;


@end

@interface NewsCommentConnectListModel : JSONModel

///评论ID
@property (nonatomic,copy)  NSString<Optional>*  Id;
///帖子ID
@property (nonatomic,copy)  NSString<Optional>*  newsId;
///父评论Id
@property (nonatomic,copy)  NSString<Optional>*  parentId;
///评论内容时间
@property (nonatomic,copy)  NSString<Optional>*  createTime;
///用户昵称
@property (nonatomic,copy)  NSString<Optional>*  nickName;
///用户Id
//@property (nonatomic,copy)  NSString<Optional>*  userId;
///用户头像
@property (nonatomic,copy)  NSString<Optional>*  headPortrait;
///评论内容
@property (nonatomic,copy)  NSString<Optional>*  content;
///回复对象评论id 2级评论id
@property (nonatomic,copy)  NSString<Optional>*   grandparentId;
///
//@property (nonatomic,copy)  NSString<Optional>* appraiseUserId;
///评论对象名字
@property (nonatomic,copy)  NSString<Optional>* appraiseNickName;
///评论对象头像
@property (nonatomic,copy)  NSString<Optional>* appraiseHeadPortrait;
///评论赞数量
@property (nonatomic,copy)  NSString<Optional>* forumAppraiseZanNum;
///新闻评论赞数量
@property (nonatomic,copy)  NSString<Optional>* newsAppraiseZanNum;
///帖子标题
@property (nonatomic,copy)  NSString<Optional>* newsTitle;

///0:赞 1:取消赞
@property (nonatomic,copy)  NSString<Optional>* isSelfZan;

///子评论
@property (nonatomic,strong)  NSArray<NewsCommentConnectListModel,Optional>*  appraises;


@end

NS_ASSUME_NONNULL_END
