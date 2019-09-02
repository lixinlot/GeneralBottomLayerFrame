//
//  NSDate+Extension.m
//  ForestPack
//
//  Created by 郑洲 on 2018/7/3.
//  Copyright © 2018年 郑洲. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (BOOL)isThisYear
{
    //取出当前的日期--年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year == nowCmps.year;
}

- (BOOL)isToday
{
    /** 另一种方法*/
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *now = [NSDate date];
    NSString *nowStr = [fmt stringFromDate:now];
    NSString *dateStr = [fmt stringFromDate:self];
    
    return [nowStr isEqualToString:dateStr];
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"dd";
    
    NSDate *now = [NSDate date];
    NSString *nowStr = [fmt stringFromDate:now];
    NSString *dateStr = [fmt stringFromDate:self];
    
    BOOL isSure = NO;
    if (nowStr.intValue - dateStr.intValue == 1) {
        isSure = YES;
    }
    
    return isSure;
}

@end
