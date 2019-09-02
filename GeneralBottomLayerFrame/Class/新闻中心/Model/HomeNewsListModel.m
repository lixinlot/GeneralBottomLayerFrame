//
//  HomeNewsListModel.m
//  RongMei
//
//  Created by jimmy on 2018/12/5.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "HomeNewsListModel.h"

@implementation HomeNewsAllModel

- (void)setHomeNewsListModel:(HomeNewsListModel *)homeNewsListModel
{
    _homeNewsListModel = homeNewsListModel;
    
    if (!homeNewsListModel.thumbnail_pic_s && !homeNewsListModel.thumbnail_pic_s03) {
        self.type = 0;
    }else if (!homeNewsListModel.thumbnail_pic_s03) {
        self.type = 1;
    }else {
        self.type = 2;
    }
}

@end

@implementation HomeNewsListModel



+ (NSDictionary *)modelCustomPropertyMapper {
    // value should be Class or Class name.
    return @{@"newsId" : @[@"id",@"ID"]};
}




@end



