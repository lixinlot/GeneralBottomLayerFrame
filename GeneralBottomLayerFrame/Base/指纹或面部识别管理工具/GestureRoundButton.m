//
//  GestureRoundButton.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/14.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "GestureRoundButton.h"

@implementation GestureRoundButton

//@synthesize selected;
//@synthesize success;
//@synthesize表示如果属性没有手动实现setter和getter方法，编译器会自动加上这两个方法。
#define skyColor [self colorWithHexString:@"#4678e7" alpha:1]
#define lineColor [self colorWithHexString:@"#74757c" alpha:1]
#define unColor [self colorWithHexString:@"#ff4e4e" alpha:1]
#define regularColor [self colorWithHexString:@"#b9b9b9" alpha:1]


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _success = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _success = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //CGContextSetStrokeColor  设置当前笔触颜色。
    //CGContextSetAlpha  设置在图形上下文中绘制的对象的不透明度级别
    //CGContextSetStrokeColorSpace  在图形上下文中设置笔触颜色空间
    //********CGContextSetFillColorWithColor 当前填充颜色********
    //******CGContextSetStrokeColorWithColor 使用CGColor设置上下文中的当前笔触颜色******
    //CGContextAddEllipseInRect  画椭圆
    //CGContextFillPath：填充路径
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.thumb) {
        if (self.selected) {
            CGContextSetFillColorWithColor(context, skyColor.CGColor);
        }else {
            CGContextSetFillColorWithColor(context, regularColor.CGColor);
        }
        CGContextAddEllipseInRect(context, self.bounds);
        CGContextFillPath(context);
        return;
    }
    if (self.selected) {
        if (self.success) {
            CGContextSetFillColorWithColor(context, skyColor.CGColor);
            CGContextSetStrokeColorWithColor(context, skyColor.CGColor);
        }else {
            CGContextSetFillColorWithColor(context, unColor.CGColor);
            CGContextSetStrokeColorWithColor(context, unColor.CGColor);
        }
        CGRect frame = CGRectMake(self.bounds.size.width/2-self.bounds.size.width/8, self.bounds.size.height/2-self.bounds.size.height/8, self.bounds.size.width/4, self.bounds.size.height/4);
        //画圆
        CGContextAddEllipseInRect(context, frame);
        //填充路径
        CGContextFillPath(context);
    }else {
        //线条颜色
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    }
    CGContextSetLineWidth(context, 1);
    CGRect frame = CGRectMake(2, 2, self.bounds.size.width-3, self.bounds.size.height-3);
    CGContextAddEllipseInRect(context, frame);
    //路径绘制 只有边框
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddEllipseInRect(context,frame);
    if (self.selected) {
        CGContextFillPath(context);
    }
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
