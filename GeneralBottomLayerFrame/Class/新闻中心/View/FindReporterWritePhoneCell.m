//
//  FindReporterWritePhoneCell.m
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "FindReporterWritePhoneCell.h"

@interface FindReporterWritePhoneCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * inputTF;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FindReporterWritePhoneCell

+ (FindReporterWritePhoneCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"FindReporterWritePhoneCell";
    FindReporterWritePhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindReporterWritePhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI
{
    CGRect titleLab_frame = CGRectMake(20, 16, 90, 25);
    self.titleLab = [[UILabel alloc] initWithFrame:titleLab_frame];
    self.titleLab.textColor = [UIColor colorWithHexString:@"#212121"];
    self.inputTF.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = Rfont(17);
    self.titleLab.text = @"联系方式";
    [self addSubview:self.titleLab];
    
    CGRect inputTF_frame = CGRectMake(20+90, 16, SCREEN_WIDTH-20*3-90, 25);
    self.inputTF = [[UITextField alloc] initWithFrame:inputTF_frame];
    self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
    self.inputTF.textColor = [UIColor colorWithHexString:@"#212121"];
    self.inputTF.font = Rfont(16);
    self.inputTF.delegate = self;
    self.inputTF.textAlignment = NSTextAlignmentRight;
    self.inputTF.placeholder = @"请输入联系方式";
    [self addSubview:self.inputTF];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(0, 55, SCREEN_WIDTH, 1);
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self addSubview:self.lineView];
}

- (void)setCluesTitleLabelText
{
    self.titleLab.text = @"联系方式(选填)";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.phoneWriteBlock) {
        self.phoneWriteBlock(textField.text);
    }
}

@end
