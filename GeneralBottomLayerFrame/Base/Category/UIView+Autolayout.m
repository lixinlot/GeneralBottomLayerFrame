//
//  UIView+Autolayout.m
//  gjj51
//
//  Created by anan on 15-2-11.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import "UIView+Autolayout.h"

static CADisplayLink * sm_timer = nil;
static NSMutableArray * movies = nil;
static NSMutableArray * willRemoveMovies = nil;
static NSMutableArray * willAddMovies = nil;

@implementation UIView (Autolayout)

-(void)setX:(CGFloat)x{
    if (!self.translatesAutoresizingMaskIntoConstraints && [self superview]) {
        [self setEdge:[self superview] attr:NSLayoutAttributeLeading constant:x];
        return;
    }
    self.frame=CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
-(void)setY:(CGFloat)y{
    if (!self.translatesAutoresizingMaskIntoConstraints && [self superview]) {
        [self setEdge:[self superview] attr:NSLayoutAttributeTop constant:y];
        return;
    }
    self.frame=CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}
-(void)setWidth:(CGFloat)width{
    NSArray* constrains = self.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth&&constraint.firstItem==self) {
            [self removeConstraint:constraint];
        }
    }
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    }else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
    }
}
-(void)setHeight:(CGFloat)height{
    NSArray* constrains = self.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight&&constraint.firstItem==self) {
            [self removeConstraint:constraint];
        }
    }
    if (height<0) {
        return;
    }
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    }else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
    }
}

-(void)setEdge:(UIView*)oview attr:(NSLayoutAttribute)attr constant:(CGFloat)constant{
    UIView *superview = nil;
    if (self.superview && oview.superview==self.superview) {
        superview = self.superview;
    }
    if (oview==self.superview) {
        superview=oview;
    }else if(self==oview.superview){
        superview=self;
    }
    if (!superview) {
        NSLog(@"setEdge has illegal argments");
        return;
    }
    for (NSLayoutConstraint *constraint in superview.constraints) {
        if (constraint.firstAttribute==attr&&constraint.secondAttribute==attr) {
            if (constraint.firstItem==oview||constraint.secondItem==oview) {
                if (constraint.firstItem==self||constraint.secondItem==self) {
                    [superview removeConstraint:constraint];
                }
            }
        }
    }
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:oview attribute:attr multiplier:1.0 constant:constant]];
}

-(UIView*)layout:(NSDictionary*)info{
    if (!info) {
        return self;
    }
    float tmp = 0;
    BOOL bl=[info objectForKey:@"left"]?YES:NO
    ,br=[info objectForKey:@"right"]?YES:NO
    ,bt=[info objectForKey:@"top"]?YES:NO
    ,bb=[info objectForKey:@"bottom"]?YES:NO
    ,bw=[info objectForKey:@"width"]?YES:NO
    ,bh=[info objectForKey:@"height"]?YES:NO;
    self.translatesAutoresizingMaskIntoConstraints=NO;
    
    if([info objectForKey:@"delete"]){
        NSString *del = [info objectForKey:@"delete"];
        NSArray*dels=[del componentsSeparatedByString:@" "];
        for (NSString*tag in dels) {
            if ([tag isEqualToString:@"top"]) {
                bt=YES;
            }else if ([tag isEqualToString:@"bottom"]){
                bb=YES;
            }else if ([tag isEqualToString:@"left"]){
                bl=YES;
            }else if ([tag isEqualToString:@"right"]){
                br=YES;
            }else if ([tag isEqualToString:@"width"]){
                bw=YES;
            }else if ([tag isEqualToString:@"height"]){
                bh=YES;
            }
        }
    }
    if (bl||br||bt||bb) {
        for (NSLayoutConstraint *constraint in self.superview.constraints) {
            if (constraint.firstItem==self||constraint.secondItem==self) {
                NSLayoutAttribute attr=constraint.firstItem==self?constraint.firstAttribute:constraint.secondAttribute;
                if (bl&&(attr==NSLayoutAttributeLeft||attr==NSLayoutAttributeLeading)) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (br&&(attr==NSLayoutAttributeRight||attr==NSLayoutAttributeTrailing)) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (bt&&attr==NSLayoutAttributeTop) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (bb&&attr==NSLayoutAttributeBottom) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
            }
            
        }
    }
    if (bw||bh) {
        for (NSLayoutConstraint *constraint in self.constraints){
            if (constraint.firstItem==self||constraint.secondItem==self) {
                NSLayoutAttribute attr=constraint.firstItem==self?constraint.firstAttribute:constraint.secondAttribute;
                if (bw&&attr==NSLayoutAttributeWidth) {
                    [self removeConstraint:constraint];
                    continue;
                }
                if (bh&&attr==NSLayoutAttributeHeight) {
                    [self removeConstraint:constraint];
                    continue;
                }
            }
        }
    }
    if ([info objectForKey:@"width"]) {
        tmp = ((NSNumber*)[info objectForKey:@"width"]).floatValue;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tmp]];
    }
    if ([info objectForKey:@"height"]) {
        tmp = ((NSNumber*)[info objectForKey:@"height"]).floatValue;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tmp]];
    }
    if (!self.superview) {
        return self;
    }
    if ([info objectForKey:@"left"]) {
        tmp = ((NSNumber*)[info objectForKey:@"left"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:tmp]];
    }
    if ([info objectForKey:@"top"]) {
        tmp = ((NSNumber*)[info objectForKey:@"top"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:tmp]];
    }
    if ([info objectForKey:@"right"]) {
        tmp = ((NSNumber*)[info objectForKey:@"right"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:-tmp]];
    }
    if ([info objectForKey:@"bottom"]) {
        tmp = [[info objectForKey:@"bottom"] floatValue];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:-tmp]];
    }
    return self;
}

-(void)centerX{
    UIView *superview = [self superview];
    if (superview && !self.translatesAutoresizingMaskIntoConstraints) {
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
}

-(void)centerY{
    UIView *superview = [self superview];
    if (superview && !self.translatesAutoresizingMaskIntoConstraints) {
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
}

-(NSLayoutConstraint*)removeAlignFromParentBottom{
    UIView *superview = [self superview];
    for (NSLayoutConstraint *constraint in superview.constraints) {
        if (constraint.firstAttribute==NSLayoutAttributeBottom&&constraint.firstAttribute==NSLayoutAttributeBottom) {
            if (constraint.firstItem==superview||constraint.secondItem==superview) {
                if (constraint.firstItem==self||constraint.secondItem==self) {
                    [superview removeConstraint:constraint];
                    return constraint;
                }
            }
        }
    }
    return nil;
}

-(void)setX:(float)x y:(float)y width:(float)w height:(float)h{
    UIView *supview = [self superview];
    if (!self.translatesAutoresizingMaskIntoConstraints&&supview) {
        [self setEdge:supview attr:NSLayoutAttributeLeft constant:x];
        [self setEdge:supview attr:NSLayoutAttributeTop constant:y];
        self.width=w;
        self.height=h;
    }
}

-(void)addFlowSubview:(UIView*)sub{
    [self addFlowSubview:sub bottom:0];
}

-(void)addFlowSubview:(UIView*)sub bottom:(float)b{
    [self addFlowSubview:sub margin:0 bottom:b];
}

-(void)addFlowSubview:(UIView*)sub margin:(float)m bottom:(float)b{
    UIView *last=nil;
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:sub];
    [sub setEdge:self attr:NSLayoutAttributeLeading constant:0];
    [sub setEdge:self attr:NSLayoutAttributeTrailing constant:0];
    if (self.subviews.count<=1) {
        [sub setEdge:self attr:NSLayoutAttributeTop constant:m];
    }else{
        last=[self.subviews objectAtIndex:self.subviews.count-2];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sub
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:last
                                                        attribute:NSLayoutAttributeBottom multiplier:1.0 constant:m]];
    }
    
    NSArray* constraints = self.constraints;
    for (NSLayoutConstraint* constraint in constraints) {
        if (constraint.firstItem==self&&constraint.firstAttribute == NSLayoutAttributeHeight) {
            [self removeConstraint:constraint];
        }
        if (constraint.firstAttribute== NSLayoutAttributeBottom && constraint.secondAttribute== NSLayoutAttributeBottom) {
            if (constraint.secondItem==self||constraint.firstItem==self) {
                if (constraint.firstItem==last||constraint.secondItem==last) {
                    [self removeConstraint:constraint];
                }
            }
        }
    }
    if (b>=0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sub attribute:NSLayoutAttributeBottom multiplier:1 constant:b]];
    }
}

-(void)fullWidth{
    if ([self superview]) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            
        }else{
            [self setEdge:[self superview] attr:NSLayoutAttributeLeft constant:0];
            [self setEdge:[self superview] attr:NSLayoutAttributeRight constant:0];
        }
    }
}

-(void)fullHeight{
    if ([self superview]) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            
        }else{
            [self setEdge:[self superview] attr:NSLayoutAttributeTop constant:0];
            [self setEdge:[self superview] attr:NSLayoutAttributeBottom constant:0];
        }
    }
}

-(void)fullParent{
    if ([self superview]) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            
        }else{
            [self setEdge:[self superview] attr:NSLayoutAttributeTop constant:0];
            [self setEdge:[self superview] attr:NSLayoutAttributeBottom constant:0];
            [self setEdge:[self superview] attr:NSLayoutAttributeLeft constant:0];
            [self setEdge:[self superview] attr:NSLayoutAttributeRight constant:0];
        }
    }
}
-(void)equalWidthTo:(UIView*)oview{
    [self equalWidthTo:oview multipier:1];
}

-(void)equalWidthTo:(UIView*)oview multipier:(CGFloat)f{
    UIView *container = nil;
    if (self.superview==oview.superview&&self.superview!=nil) {
        container=self.superview;
    }else if(self.superview==oview){
        container=oview;
    }else if (self==oview.superview){
        container=self;
    }
    if(container){
        NSArray* constraints = container.constraints;
        for (NSLayoutConstraint* constraint in constraints) {
            if (constraint.secondAttribute==NSLayoutAttributeWidth&&constraint.firstAttribute == NSLayoutAttributeWidth) {
                if ((constraint.firstItem==self&&constraint.secondItem==oview)
                    ||(constraint.firstItem==oview&&constraint.secondItem==self)) {
                    [container removeConstraint:constraint];
                    break;
                }
            }
        }
        [container addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:oview attribute:NSLayoutAttributeWidth multiplier:f constant:0]];
    }
}

-(void)equalOrGreaterWidthTo:(UIView *)oview multipier:(CGFloat)f{
    UIView *container = nil;
    if (self.superview==oview.superview&&self.superview!=nil) {
        container=self.superview;
    }else if(self.superview==oview){
        container=oview;
    }else if (self==oview.superview){
        container=self;
    }
    if(container){
        NSArray* constraints = container.constraints;
        for (NSLayoutConstraint* constraint in constraints) {
            if (constraint.secondAttribute==NSLayoutAttributeWidth&&constraint.firstAttribute == NSLayoutAttributeWidth) {
                if ((constraint.firstItem==self&&constraint.secondItem==oview)
                    ||(constraint.firstItem==oview&&constraint.secondItem==self)) {
                    [container removeConstraint:constraint];
                    break;
                }
            }
        }
        [container addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:oview attribute:NSLayoutAttributeWidth multiplier:f constant:0]];
    }
}
-(void)equalHeightTo:(UIView*)oview{
    UIView *container = nil;
    if (self.superview==oview.superview&&self.superview!=nil) {
        container=self.superview;
    }else if(self.superview==oview){
        container=oview;
    }else if (self==oview.superview){
        container=self;
    }
    if(container){
        [container addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:oview attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
}
-(void)follow:(UIView*)lastView{
    [self follow:lastView margin:0];
}
-(void)follow:(UIView*)lastView margin:(float)m{
    if (![self superview] || [self superview]!=[lastView superview]) {
        return;
    }
    [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:lastView
                                                                 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:m]];
}

-(void)after:(UIView*)lastView margin:(float)m{
    if (![self superview] || [self superview]!=[lastView superview]) {
        return;
    }
    [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:lastView
                                                                 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:m]];
}

//-(void)startMovie:(NSDictionary*)data andCompleted:(movieCompleted)cb{
//    Movie *m = [[Movie alloc]initWithView:self data:data andCompleted:cb];
//    [m start];
//}
//
//-(void)startMovie:(NSDictionary*)data{
//    [self startMovie:data andCompleted:nil];
//}
//
//+(void)countTotalFrames:(id)sender{
//    if(!movies){
//        movies=[NSMutableArray arrayWithCapacity:3];
//    }
//    for (Movie*m in movies) {
//        [m update];
//    }
//    for (Movie*m in willRemoveMovies) {
//        [movies removeObject:m];
//    }
//    if (willAddMovies.count) {
//        if (!movies) {
//            movies=[NSMutableArray arrayWithCapacity:3];
//        }
//        [movies addObjectsFromArray:willAddMovies];
//        [willAddMovies removeAllObjects];
//    }
//    if (movies.count==0) {
//        [sm_timer invalidate];
//        sm_timer = nil;
//    }
//    [willRemoveMovies removeAllObjects];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

typedef void(^movieCompleted)(float);

@interface Movie(){
    float _currF;
    float _lastF;
    NSMutableDictionary *origin;
    UIView *actor;
    UILabel *actorLabel;
    float _ori_bg_rgb[3];
    float _ori_text_color_rgb[3];
    float _bg_rgb[3];
    float _text_color_rgb[3];
}
@end

@implementation Movie
//-(id)initWithView:(UIView *)view data:(NSDictionary *)dic{
//    return [self initWithView:view data:dic andCompleted:nil];
//}
//-(id)initWithView:(UIView *)view data:(NSDictionary*)dic andCompleted:(movieCompleted)cb{
//    if (self=[super init]) {
//        _currF=0;
//        self.duration = .4;
//        if([dic objectForKey:@"duration"]){
//            self.duration=((NSNumber*)[dic objectForKey:@"duration"]).floatValue;
//        }
//        self.data=dic;
//        actor = view;
//        origin = [[NSMutableDictionary alloc]initWithCapacity:3];
//        if ([dic objectForKey:@"height"]) {
//            if ([dic objectForKey:@"o-height"]) {
//                [origin setValue:[dic objectForKey:@"o-height"] forKey:@"height"];
//            }else{
//                [origin setValue:@(actor.frame.size.height) forKey:@"height"];
//            }
//        }
//        if ([dic objectForKey:@"width"]) {
//            if ([dic objectForKey:@"o-width"]) {
//                [origin setValue:[dic objectForKey:@"o-width"] forKey:@"width"];
//            }else{
//                [origin setValue:@(actor.frame.size.width) forKey:@"width"];
//            }
//        }
//        if ([dic objectForKey:@"alpha"]) {
//            [origin setValue:@(actor.alpha) forKey:@"alpha"];
//        }
//        if ([dic objectForKey:@"x"]) {
//            if ([dic objectForKey:@"o-x"]) {
//                [origin setValue:[dic objectForKey:@"o-x"] forKey:@"x"];
//            }else{
//                [origin setValue:@(actor.frame.origin.x) forKey:@"x"];
//            }
//        }
//        if ([dic objectForKey:@"y"]) {
//            if ([dic objectForKey:@"o-y"]) {
//                [origin setValue:[dic objectForKey:@"o-y"] forKey:@"y"];
//            }else{
//                [origin setValue:@(actor.frame.origin.y) forKey:@"y"];
//            }
//        }
//        if ([dic objectForKey:@"right"]) {
//            if ([dic objectForKey:@"o-right"]) {
//                [origin setValue:[dic objectForKey:@"o-right"] forKey:@"right"];
//            }else{
//                [origin setValue:@(actor.superview.frame.size.width-actor.frame.origin.x-actor.frame.size.width) forKey:@"right"];
//            }
//        }
//        if ([dic objectForKey:@"background"]) {
//            id bg = [dic objectForKey:@"background"];
//            UIColor *backgroundColor=nil;
//            if ([bg isKindOfClass:[UIColor class]]) {
//                backgroundColor=bg;
//            }else if([bg isKindOfClass:[NSString class]]){
//                backgroundColor=[UIColor colorWithRGB:bg];
//            }
//            if (backgroundColor) {
//                const CGFloat *components = CGColorGetComponents(backgroundColor.CGColor);
//                _bg_rgb[0]=components[0];
//                _bg_rgb[1]=components[1];
//                _bg_rgb[2]=components[2];
//            }
//            
//            const CGFloat *components = CGColorGetComponents(actor.backgroundColor.CGColor);
//            _ori_bg_rgb[0]=components[0];
//            _ori_bg_rgb[1]=components[1];
//            _ori_bg_rgb[2]=components[2];
//        }
//        if ([dic objectForKey:@"textColor"]) {
//            id col = [dic objectForKey:@"textColor"];
//            UIColor *tc=nil;
//            if ([col isKindOfClass:[UIColor class]]) {
//                tc=col;
//            }else if([col isKindOfClass:[NSString class]]){
//                tc=[UIColor colorWithRGB:col];
//            }
//            if (tc&&[actor isKindOfClass:[UILabel class]]) {
//                actorLabel=(UILabel*)actor;
//                const CGFloat *components = CGColorGetComponents(tc.CGColor);
//                _text_color_rgb[0]=components[0];
//                _text_color_rgb[1]=components[1];
//                _text_color_rgb[2]=components[2];
//                
//                components = CGColorGetComponents(actorLabel.textColor.CGColor);
//                _ori_text_color_rgb[0]=components[0];
//                _ori_text_color_rgb[1]=components[1];
//                _ori_text_color_rgb[2]=components[2];
//            }
//        }
//        self.completed=cb;
//    }
//    return self;
//}
//
//-(void)start{
//    if(!sm_timer){
//        sm_timer = [CADisplayLink displayLinkWithTarget:[UIView class] selector:@selector(countTotalFrames:)];
//        sm_timer.frameInterval=1;
//        [sm_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    }
//    if (!willAddMovies) {
//        willAddMovies = [NSMutableArray arrayWithCapacity:4];
//    }
//    [willAddMovies addObject:self];
//}
//
//-(void)setDuration:(float)duration{
//    _duration = duration;
//    _lastF = 60.0*_duration;
//}
//-(void)update{
//    float r = _currF/_lastF;
//    r = r*r;
//    if ([_data objectForKey:@"height"]) {
//        float newH = ((NSNumber*)[_data objectForKey:@"height"]).floatValue;
//        float oriH = ((NSNumber*)[origin objectForKey:@"height"]).floatValue;
//        float currH = _currF==_lastF?newH:(oriH+(newH-oriH)*r);
//        actor.height = currH;
//    }
//    if ([_data objectForKey:@"width"]) {
//        float newW = ((NSNumber*)[_data objectForKey:@"width"]).floatValue;
//        float oriW = ((NSNumber*)[origin objectForKey:@"width"]).floatValue;
//        float currW = _currF==_lastF?newW:(oriW+(newW-oriW)*r);
//        actor.width = currW;
//    }
//    if ([_data objectForKey:@"x"]) {
//        float newX = ((NSNumber*)[_data objectForKey:@"x"]).floatValue;
//        float oriX = ((NSNumber*)[origin objectForKey:@"x"]).floatValue;
//        float currX = _currF==_lastF?newX:(oriX+(newX-oriX)*r);
//        actor.x = currX;
//    }
//    if ([_data objectForKey:@"y"]) {
//        float newY = ((NSNumber*)[_data objectForKey:@"y"]).floatValue;
//        float oriY = ((NSNumber*)[origin objectForKey:@"y"]).floatValue;
//        float currY = _currF==_lastF?newY:(oriY+(newY-oriY)*r);
//        actor.y = currY;
//    }
//    if ([_data objectForKey:@"right"]) {
//        float newX = ((NSNumber*)[_data objectForKey:@"right"]).floatValue;
//        float oriX = ((NSNumber*)[origin objectForKey:@"right"]).floatValue;
//        float currX = _currF==_lastF?newX:(oriX+(newX-oriX)*r);
//        [actor layout:@{@"right":@(currX)}];
//    }
//    if ([_data objectForKey:@"alpha"]) {
//        float newA = ((NSNumber*)[_data objectForKey:@"alpha"]).floatValue;
//        float oriA = ((NSNumber*)[origin objectForKey:@"alpha"]).floatValue;
//        float currA = _currF==_lastF?newA:(oriA+(newA-oriA)*r);
//        actor.alpha=currA;
//    }
//    if ([_data objectForKey:@"background"]) {
//        float red = _currF==_lastF?_bg_rgb[0]:(_ori_bg_rgb[0]+(_bg_rgb[0]-_ori_bg_rgb[0])*r);
//        float green = _currF==_lastF?_bg_rgb[1]:(_ori_bg_rgb[1]+(_bg_rgb[1]-_ori_bg_rgb[1])*r);
//        float blue = _currF==_lastF?_bg_rgb[2]:(_ori_bg_rgb[2]+(_bg_rgb[2]-_ori_bg_rgb[2])*r);
//        actor.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:1];
//    }
//    if (actorLabel) {
//        float red = _currF==_lastF?_text_color_rgb[0]:(_ori_text_color_rgb[0]+(_text_color_rgb[0]-_ori_text_color_rgb[0])*r);
//        float green = _currF==_lastF?_text_color_rgb[1]:(_ori_text_color_rgb[1]+(_text_color_rgb[1]-_ori_text_color_rgb[1])*r);
//        float blue = _currF==_lastF?_text_color_rgb[2]:(_ori_text_color_rgb[2]+(_text_color_rgb[2]-_ori_text_color_rgb[2])*r);
//        actorLabel.textColor=[UIColor colorWithRed:red green:green blue:blue alpha:1];
//    }
//    if (_currF==_lastF) {
//        if(!willRemoveMovies){
//            willRemoveMovies = [NSMutableArray arrayWithCapacity:2];
//        }
//        [willRemoveMovies addObject:self];
//        if (_completed) {
//            _completed(1.0);
//        }
//    }else{
//        _currF+=1;
//    }
//}

@end
