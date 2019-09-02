//
//  BaseTableView.m
//  ForestPack
//
//  Created by 郑洲 on 2018/7/3.
//  Copyright © 2018年 郑洲. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    }
    return self;
}

@end
