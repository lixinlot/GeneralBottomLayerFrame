//
//  EnumHeader.h
//  RongMei
//
//  Created by jimmy on 2018/12/3.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HandelTaskIntegralType_DidFinish,// 开始
    HandelTaskIntegralType_EnterForeground,// 进入前台
    HandelTaskIntegralType_EnterBackgroud,// 进入后台
    HandelTaskIntegralType_Terminate,// 终止程序
    HandelTaskIntegralType_SeeNews,// 点击新闻
    HandelTaskIntegralType_ShareNews,// 分享新闻
    HandelTaskIntegralType_CollectNews,// 收藏新闻
    HandelTaskIntegralType_CommentNews,// 评论新闻
    HandelTaskIntegralType_SubmitSubject,// 视频答题
    HandelTaskIntegralType_PunchClerk,// 考勤打卡
    HandelTaskIntegralType_SubmitSpecialQuestion,// 专题考试答题
} HandelTaskIntegralType;

typedef NS_ENUM(NSUInteger, RewardType) {
    RewardType_goldEgg = 0,
    RewardType_card    = 1,
    RewardType_box     = 2,
};

typedef NS_ENUM(NSUInteger, LotteryType) {//奖券类型
    LotteryType_exchange   = 0,//兑换券
    LotteryType_voucher    = 1,//代金券
};

typedef NS_ENUM(NSUInteger, LotteryTypeState) {//奖券类型及状态
    LotteryTypeState_voucherCanUse     = 0,//代金券未使用
    LotteryTypeState_voucherCantUse    = 1,//代金券已使用
    LotteryTypeState_exchangeCanUse     = 0,//兑换券未使用
    LotteryTypeState_exchangeCantUse    = 1,//兑换券已使用
};

typedef NS_ENUM(NSUInteger, LotteryState) {//奖券类型及状态
    LotteryState_canUse     = 0,//未使用
    LotteryState_cantUse    = 1,//已使用
};

typedef NS_ENUM(NSUInteger, TicketState) {//奖券类型及状态  我的商家
    TicketState_haveUse     = 0,//已使用 已核销
    TicketState_noUse    = 1,//未使用
};

typedef NS_ENUM(NSUInteger, LotteryUserType) {//奖券类型
    LotteryUserType_merchant     = 0,//商家
    LotteryUserType_customUser    = 1,//普通用户
};

typedef NS_ENUM(NSUInteger, NowReachType) {//一键类型
    NowReachType_people     = 0,//一键寻人
    NowReachType_thing    = 1,//一键寻物
    NowReachType_tv   = 2,//一键上电视
    NowReachType_other    = 3,//一键上广播，找记者
};

typedef NS_ENUM(NSUInteger, PostType) {//帖子类型
    PostType_localList     = 0,//本地圈列表
    PostType_mine    = 1,//我的帖子
    PostType_rubbish    = 2,//垃圾篓
};

typedef NS_ENUM(NSInteger,PhotoType) {//图片类型
    PhotoType_normal   = 0,//静图
    PhotoType_gif   = 2,   //gif
};

typedef NS_ENUM(NSInteger,YUTimerStatus) {
    YUTimerStatusIng,       //执行中
    YUTimerStatusSuspend,   //暂停
    YUTimerStatusStop,      //关闭
};

typedef NS_ENUM(NSInteger,SetPuncherType) {//设置的审核人还是监管人
    SetPuncherType_reviewer   = 0,//审核人
    SetPuncherType_supervisor   = 1,   //监管人
};

typedef NS_ENUM(NSInteger,PunchSelectTimeType) {//考勤打卡选择时间类型
    PunchSelectTimeType_beginTime, //上班时间
    PunchSelectTimeType_outTime ,  //下班时间
    PunchSelectTimeType_refreshTime,      //刷新时间
};


typedef NS_ENUM(NSInteger,LocalHomeBottomType) {//本地圈底部显示类型
    LocalHomeBottomType_allVideos   = 0,//显示所有视频
    LocalHomeBottomType_shopOwenr   = 1,//显示商家信息
    LocalHomeBottomType_reward      = 2,//显示奖券
};

typedef NS_ENUM(NSInteger, MarqueeViewDirection) {//跑马灯滚动方向
    MarqueeDirectionLeft,// 从右向左
    MarqueeDirectionRight // 从左向右
};

typedef NS_ENUM(NSUInteger, ShopParaType) {
    ShopParaType_Add     = 0,//
    ShopParaType_Buy     = 1,//
    ShopParaType_All     = 2,//
    ShopParaType_OnlyBuy = 3,//
};

typedef NS_ENUM(NSUInteger, NLMoreClickType) {
    NLMoreClickType_delete     = 0,//删除
    NLMoreClickType_report     = 1,//举报
};

typedef NS_ENUM(NSUInteger, NLMoreType) {
    NLMoreType_forum      = 0,//帖子
    NLMoreType_comment    = 1,//评论
};

typedef NS_ENUM(NSUInteger, NLDetailListType) {
    NLDetailListType_comment     = 0,//评论
    NLDetailListType_zan         = 1,//赞
    NLDetailListType_share       = 2,//分享
};

#endif /* EnumHeader_h */
