//
//  CHCardItemModel.m
//  CHCardView
//
//  Created by yaoxin on 16/10/8.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "CHCardItemModel.h"

@implementation CHCardItemModel

- (instancetype)initWithDic:(NSDictionary *)dict {
    self = [super init];
    if (self) {
//        self.designIdea = [NSString stringWithFormat:@"%@",dict[@"designIdea"]];
//        self.fensNum = [NSString stringWithFormat:@"%@",dict[@"fensNum"]];
//        self.isFollow = [NSString stringWithFormat:@"%@",dict[@"isFollow"]];
//        self.nickName = [NSString stringWithFormat:@"%@",dict[@"nickName"]];
//        self.proId = [NSString stringWithFormat:@"%@",dict[@"proId"]];
//        self.proName = [NSString stringWithFormat:@"%@",dict[@"proName"]];
//        self.proNum = [NSString stringWithFormat:@"%@",dict[@"proNum"]];
//        self.proPic = [NSString stringWithFormat:@"%@",dict[@"proPic"]];
//        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
//        self.userIntro = [NSString stringWithFormat:@"%@",dict[@"userIntro"]];
//        self.userPic = [NSString stringWithFormat:@"%@",dict[@"userPic"]];
        
        self.image_url = [NSString stringWithFormat:@"%@",dict[@"image_url"]];
        self.url = [NSString stringWithFormat:@"%@",dict[@"url"]];
    }
    return self;
}

@end
