//
//  NewsCommentListModel.m
//  RongMei
//
//  Created by jimmy on 2018/12/17.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "NewsCommentListModel.h"

@implementation NewsCommentListAllModel

- (void)setNewsCommentListModel:(NewsCommentListModel *)newsCommentListModel
{
    _newsCommentListModel = newsCommentListModel;
    
    CGSize size1 = [newsCommentListModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
    self.commentHeight = size1.height + ScreenX375(10);
    if (newsCommentListModel.appraises.count == 0) {
        self.allCommentHeight = self.commentHeight+ScreenX375(75);
    }
    if (newsCommentListModel.appraises.count == 1) {
        CGSize size2 = [[newsCommentListModel.appraises[0] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
        self.allCommentHeight = self.commentHeight+ScreenX375(75)*2+size2.height;
    }
    if (newsCommentListModel.appraises.count == 2) {
        CGSize size3 = [[newsCommentListModel.appraises[0] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
        CGSize size4 = [[newsCommentListModel.appraises[1] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
        self.allCommentHeight = self.commentHeight+ScreenX375(75)*3+size3.height+size4.height;
    }
    if (newsCommentListModel.appraises.count > 2) {
        CGSize size5 = [[newsCommentListModel.appraises[0] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
        CGSize size6 = [[newsCommentListModel.appraises[1] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-ScreenX375(82), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Rfont(16)} context:nil].size;
        self.allCommentHeight = self.commentHeight+ScreenX375(75)*3+size5.height+size6.height+ScreenX375(50);
    }
}


@end

@implementation NewsCommentListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"Id": @"id",
                                                                  @"itemId":@"forumId",
                                                                  @"itemId":@"newsId",
                                                                  @"newsTitle":@"forumContent",
                                                                  @"Description":@"description",
//                                                                  @"newsTitle":@"forumContent",
//                                                                  @"newsAppraiseZanNum":@"forumAppraiseZanNum",
                                                                  }];
}

@end


@implementation NewsCommentConnectListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"Id": @"id",
                                                                  @"itemId":@"forumId",
                                                                  @"itemId":@"newsId",
//                                                                  @"newsAppraiseZanNum":@"forumAppraiseZanNum",
                                                                  }];
}

@end
