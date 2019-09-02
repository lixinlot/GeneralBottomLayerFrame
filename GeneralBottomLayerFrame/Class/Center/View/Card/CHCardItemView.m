//
//  CHCardItemView.m
//  CHCardView
//
//  Created by yaoxin on 16/10/8.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "CHCardItemView.h"
#import "CHCardItemModel.h" 

@implementation CHCardItemView {
    CGPoint _originalCenter;
    CGFloat _currentAngle;
    BOOL _isLeft;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        
        [self addPanGest];
        
        [self configLayer];
        
    }
    return self;
}

- (void)addPanGest {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)configLayer { 
    self.layer.cornerRadius = ScreenX375(8);
//    self.layer.shadowOffset = CGSizeMake(0, 4); //设置阴影的偏移量
//    self.layer.shadowRadius = ScreenX375(5);  //设置阴影的半径
//    self.layer.shadowColor = RGB_COLOR(116, 116, 116).CGColor; //设置阴影的颜色为黑色
//    self.layer.shadowOpacity = 0; //设置阴影的不透明度
//    self.layer.masksToBounds = NO;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 2.0;
        _currentAngle = angle;
        
        self.transform = CGAffineTransformMakeRotation(angle);
        
        [panGest setTranslation:CGPointZero inView:self];
        
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [panGest velocityInView:self];
        if (vel.x > 500 || vel.x < - 500) {
            [self remove];
            return ;
        }
        if (self.frame.origin.x + self.frame.size.width > 230 && self.frame.origin.x < self.frame.size.width - 230) {
            [UIView animateWithDuration:0.15 animations:^{
                self.center = self->_originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
            }];
        } else {
            [self remove];
        }
    }
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        
        // right
        if (!self->_isLeft) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + self->_currentAngle * self.frame.size.height);
        } else { // left
            self.center = CGPointMake(- 1000, self.center.y - self->_currentAngle * self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView: withLeft:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self withLeft:self->_isLeft];
            }
        }
    }];
    
}

- (void)removeWithLeft:(BOOL)left {
    [UIView animateWithDuration:0.5 animations:^{
        
        // right
        if (!left) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + self->_currentAngle * self.frame.size.height + (self->_currentAngle == 0 ? 100 : 0));
        } else { // left
            self.center = CGPointMake(- 1000, self.center.y - self->_currentAngle * self.frame.size.height + (self->_currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:withLeft:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self withLeft:left];
            }
        }
    }];
}

@end
