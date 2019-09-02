//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "GesturePasswordButton.h"

#define bounds self.bounds

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    if (self.thumb) {
        if (selected) {
            CGContextSetFillColorWithColor(context, [UIColor colorWithRGB:@"#4678e7"].CGColor);
        }else{
            CGContextSetFillColorWithColor(context, [UIColor colorWithRGB:@"#b9b9b9"].CGColor);
        }
        
        CGContextAddEllipseInRect(context, self.bounds);
        CGContextFillPath(context);
        return;
    }
    
    if (selected) {
        if (success) {
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRGB:@"#4678e7"].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRGB:@"#4678e7"].CGColor);
        }
        else {
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRGB:@"#ff4e4e"].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRGB:@"#ff4e4e"].CGColor);
        }
        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1, bounds.size.height/2-bounds.size.height/8, bounds.size.width/4, bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
//        CGContextSetRGBStrokeColor(context, 1,1,1,1);//线条颜色
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRGB:@"#74757c"].CGColor);
    }
    
    CGContextSetLineWidth(context,1);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
//    if (success) {
//        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
//    }
//    else {
//        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
//    }
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddEllipseInRect(context,frame);
    if (selected) {
        CGContextFillPath(context);
    }
    
}


@end
