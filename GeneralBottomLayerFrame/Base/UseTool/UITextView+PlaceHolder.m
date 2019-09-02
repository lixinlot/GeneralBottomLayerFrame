//
//  UITextView+PlaceHolder.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

static NSString * placeHolderLabelKey = @"placeHolderLabelKey";
static NSString * placeHolderStringKey = @"placeHolderStringKey";
static NSString * placeHolderColorKey = @"placeHolderColorKey";
static NSString * placeHolderFontKey = @"placeHolderFontKey";

@interface UITextView()

@property (nonatomic,strong)  UILabel  * placeHolderLabel;

@end

@implementation UITextView (PlaceHolder)

- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel
{
    objc_setAssociatedObject(self, &placeHolderLabelKey, placeHolderLabel, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)placeHolderLabel
{
    return objc_getAssociatedObject(self, &placeHolderLabelKey);
}

- (void)setPlaceHolderString:(NSString *)placeHolderString
{
    if (!self.placeHolderLabel) {
        self.placeHolderLabel = [self setUpCustomPlaceHolderLabel];
    }
    self.placeHolderLabel.text = placeHolderString;
    objc_setAssociatedObject(self, &placeHolderStringKey, placeHolderString, OBJC_ASSOCIATION_COPY);
}

- (NSString *)placeHolderString
{
    return objc_getAssociatedObject(self, &placeHolderStringKey);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    if (!self.placeHolderLabel) {
        self.placeHolderLabel = [self setUpCustomPlaceHolderLabel];
    }
    self.placeHolderLabel.textColor = placeHolderColor;
    objc_setAssociatedObject(self, &placeHolderColor, placeHolderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)placeHolderColor
{
    return objc_getAssociatedObject(self, &placeHolderColorKey);
}

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont
{
    if (!self.placeHolderLabel) {
        self.placeHolderLabel = [self setUpCustomPlaceHolderLabel];
    }
    self.placeHolderLabel.font = placeHolderFont;
    objc_setAssociatedObject(self, &placeHolderFontKey, placeHolderFont, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)placeHolderFont
{
    return objc_getAssociatedObject(self, &placeHolderFontKey);
}

- (UILabel *)setUpCustomPlaceHolderLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    label.font = self.font;
    [label sizeToFit];
    [self addSubview:label];
    [self setValue:label forKey:@"placeHolderLabel"];
    
    
    
    return label;
}

@end
