//
//  FindReporterWriteTitleCell.m
//  RongMei
//
//  Created by jimmy on 2019/4/11.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "FindReporterWriteTitleCell.h"

@interface FindReporterWriteTitleCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * inputTF;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation FindReporterWriteTitleCell

+ (FindReporterWriteTitleCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"FindReporterWriteTitleCell";
    FindReporterWriteTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindReporterWriteTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    CGRect titleLab_frame = CGRectMake(20, 18, 90, 18);
    self.titleLab = [[UILabel alloc] initWithFrame:titleLab_frame];
    self.titleLab.textColor = [UIColor colorWithHexString:@"#212121"];
    self.inputTF.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = Mfont(16);
    self.titleLab.text = @"上传素材";
    [self addSubview:self.titleLab];
    
    CGRect inputTF_frame = CGRectMake(20, self.titleLab.bottom+10, SCREEN_WIDTH-40, 30);
    self.inputTF = [[UITextField alloc] initWithFrame:inputTF_frame];
    self.inputTF.textColor = [UIColor colorWithHexString:@"#212121"];
    self.inputTF.font = Rfont(20);
    self.inputTF.delegate = self;
    self.inputTF.textAlignment = NSTextAlignmentLeft;
    self.inputTF.placeholder = @"请输入标题";
    [self addSubview:self.inputTF];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(0, 89, SCREEN_WIDTH, 1);
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
