//
//  GestureSlipView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/14.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "GestureSlipView.h"
#import "GestureRoundButton.h"

@implementation GestureSlipView
{
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    NSMutableArray *touchBeginArray;
    NSMutableArray *touchEndArray;
    BOOL success;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        success = 1;
        touchBeginArray = [NSMutableArray array];
        touchEndArray = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        success = 1;
        touchBeginArray = [NSMutableArray array];
        touchEndArray = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint;
    
    UITouch *touch = [touches anyObject];
    [touchBeginArray removeAllObjects];
    [touchEndArray removeAllObjects];
    [_beginTouchDelegate beginTouch];
    success = 1;
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i = 0; i < self.buttonArray.count; i++) {
            GestureRoundButton *button = [self.buttonArray objectAtIndex:i];
            [button setSuccess:YES];
            [button setSelected:NO];
            if (CGRectContainsPoint(button.frame, touchPoint)) {
                CGRect frame = button.frame;
                CGPoint poin = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",poin.x], @"x", [NSString stringWithFormat:@"%f",poin.y], @"y", [NSString stringWithFormat:@"%d",i], @"num", nil];
                [touchBeginArray addObject:dict];
                [touchEndArray addObject:[NSString stringWithFormat:@"num%d",i]];
                lineStartPoint = touchPoint;
                lineEndPoint = touchPoint;
                [button setSelected:YES];
            }
            //setNeedsDisplay异步执行的。它会自动调用drawRect方法，这样可以拿到 UIGraphicsGetCurrentContext，就可以绘制了。而setNeedsLayout会默认调用layoutSubViews，处理子视图中的一些数据。
            [button setNeedsDisplay];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i = 0; i < self.buttonArray.count; i++) {
            GestureRoundButton *button = [self.buttonArray objectAtIndex:i];
            if (CGRectContainsPoint(button.frame, touchPoint)) {
                if ([touchEndArray containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }else {
                    [touchEndArray addObject:[NSString stringWithFormat:@"num%d",i]];
                    [button setSelected:YES];
                    [button setNeedsDisplay];
                    CGRect frame = button.frame;
                    CGPoint point = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x], @"x", [NSString stringWithFormat:@"%f",point.y], @"y", [NSString stringWithFormat:@"%d",i], @"num", nil];
                    [touchBeginArray addObject:dict];
                    break;
                }
            }
        }
        lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *resultString = [NSMutableString string];
    for (NSDictionary *dict in touchBeginArray) {
        if (![dict objectForKey:@"num"]) {
            break;
        }
        [resultString appendString:[dict objectForKey:@"num"]];
    }
    if (_style == 1) {
        success = [_vertifacationDelegate vertifate:resultString];
    }else {
        success = [_resetDelegate resetGeture:resultString];
    }
    for (int i = 0; i < touchBeginArray.count; i++) {
        NSInteger select = [[[touchBeginArray objectAtIndex:i] objectForKey:@"num"] integerValue];
        GestureRoundButton *button = [self.buttonArray objectAtIndex:select];
        [button setSuccess:success];
        [button setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < touchBeginArray.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (![[touchBeginArray objectAtIndex:i] objectForKey:@"num"]) {//防止过快滑动产生垃圾数据
            [touchBeginArray removeObjectAtIndex:i];
            continue;
        }
        if (success) {
            UIColor *skyHalfAlphaColor = [[GestureRoundButton new] colorWithHexString:@"#4678e7" alpha:0.5];
            CGContextSetStrokeColorWithColor(context, skyHalfAlphaColor.CGColor);
        }else {
            UIColor *unColor = [[GestureRoundButton new] colorWithHexString:@"#ff4e4e" alpha:1];
            CGContextSetStrokeColorWithColor(context, unColor.CGColor);
        }
        CGContextSetLineWidth(context, 5);
        CGContextMoveToPoint(context, [[[touchBeginArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchBeginArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        if (i < touchBeginArray.count - 1) {
            CGContextAddLineToPoint(context, [[[touchBeginArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchBeginArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        }else {
            if (success) {
                CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
            }
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextStrokePath(context);
    }
}

- (void)enterAgin {
    [touchBeginArray removeAllObjects];
    [touchEndArray removeAllObjects];
    for (int i = 0; i < self.buttonArray.count; i++) {
        GestureRoundButton *button = [self.buttonArray objectAtIndex:i];
        [button setSuccess:YES];
        [button setSelected:NO];
        [button setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

@end
