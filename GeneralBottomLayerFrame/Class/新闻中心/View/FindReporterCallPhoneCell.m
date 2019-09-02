//
//  FindReporterCallPhoneCell.m
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "FindReporterCallPhoneCell.h"

@interface FindReporterCallPhoneCell()

@property (nonatomic,strong)  UILabel  * titleL;
@property (nonatomic,strong)  UILabel  * phoneNumL;

@end

@implementation FindReporterCallPhoneCell

+ (FindReporterCallPhoneCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"FindReporterCallPhoneCell";
    FindReporterCallPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindReporterCallPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell createChildView];
    }
    return cell;
}

- (void)createChildView
{
    self.titleL = [[UILabel alloc] init];
    self.titleL.frame = CGRectMake(20, 18,SCREEN_WIDTH-40,18);
    self.titleL.text = @"爆料热线";
    self.titleL.textAlignment = NSTextAlignmentLeft;
    self.titleL.textColor = REXADECIMALCOLOR(@"#212121");
    self.titleL.font = Mfont(16);
    [self addSubview:self.titleL];
    
    self.phoneNumL = [[UILabel alloc] init];
    self.phoneNumL.frame = CGRectMake(20, self.titleL.bottom+10,SCREEN_WIDTH-40,22);
    self.phoneNumL.textAlignment = NSTextAlignmentLeft;
    self.phoneNumL.textColor = REXADECIMALCOLOR(@"#3A93FA");
    self.phoneNumL.font = Mfont(20);
    self.phoneNumL.userInteractionEnabled = YES;
    [self addSubview:self.phoneNumL];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialPhoneNumClick)];
    [self.phoneNumL addGestureRecognizer:tap];
}

- (void)setPhoneNumWith:(NSString *)phoneNum
{
    self.phoneNumL.text = phoneNum;
}

- (void)dialPhoneNumClick
{
    if (self.dialPhoneNum) {
        self.dialPhoneNum();
    }
}

@end
