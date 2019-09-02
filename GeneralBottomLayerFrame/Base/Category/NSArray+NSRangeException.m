//
//  NSArray+NSRangeException.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/5.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "NSArray+NSRangeException.h"
#import <objc/runtime.h>

@implementation NSArray (NSRangeException)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        @autoreleasepool {
//            Class class = [self class];
            // 原方法名和替换方法名
//            SEL originalSelector = @selector(viewDidAppear:);
//            SEL swizzledSelector = @selector(swizzle_viewDidAppear:);
            
            // 原方法结构体和替换方法结构体
//            Method originalMethod = class_getInstanceMethod(class, originalSelector);
//            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            // 调用交互两个方法的实现
//            method_exchangeImplementations(originalMethod, swizzledMethod);
            
            
//            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:)];
//            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(arrObjectIndex:)];
//            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
//            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
//        }
//    });
//}

- (id)emptyObjectIndex:(NSInteger)index {
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self arrObjectIndex:index];
}

- (id)mutableObjectIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}

@end
