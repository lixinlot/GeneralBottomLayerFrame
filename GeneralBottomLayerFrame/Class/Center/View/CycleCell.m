//
//  CycleCell.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "CycleCell.h"
#import "UITextView+PlaceHolder.h"

@interface CycleCell()<UITextViewDelegate>

@property (nonatomic,strong)  UITextView  * textV;
@property (nonatomic,strong)  UIButton    * addPicsBtn;
@property (nonatomic,strong)  UIImageView * imageV;
@property (nonatomic,strong)  NSIndexPath * indexpath;
//@property (nonatomic,strong)  UITextView  * textV;

@end

@implementation CycleCell

+ (CycleCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CycleCell";
    CycleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CycleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.indexpath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    [cell creatViewWithIndexPath:indexPath];
    
    return cell;
}

- (void)creatViewWithIndexPath:(NSIndexPath *)indexPath
{
    self.textV = [[UITextView alloc] init];
    self.textV.frame = CGRectMake(ScreenX375(15), ScreenX375(10), SCREEN_WIDTH - ScreenX375(30), ScreenX375(100));
    self.textV.font = Kfont(16);
    self.textV.delegate = self;
    self.textV.placeHolderString = @"请输入你的名字";
    self.textV.layer.masksToBounds = YES;
    self.textV.layer.cornerRadius = 8.0;
    self.textV.layer.borderWidth = 0.5;
    self.textV.layer.borderColor = FONTCOLOR_BLACK.CGColor;
    [self addSubview:self.textV];
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.frame = CGRectMake(ScreenX375(15), ScreenX375(120), SCREEN_WIDTH - ScreenX375(30), ScreenX375(100));
    self.imageV.userInteractionEnabled = YES;
    [self addSubview:self.imageV];
    
    self.addPicsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *num = [NSString stringWithFormat:@"%@",indexPath];
    NSInteger indexNum = [num integerValue];
    self.addPicsBtn.tag = indexNum;
    self.addPicsBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH - ScreenX375(30), ScreenX375(100));
    self.addPicsBtn.layer.masksToBounds = YES;
    self.addPicsBtn.layer.cornerRadius = 8.0;
    self.addPicsBtn.layer.borderWidth = 0.5;
    self.addPicsBtn.layer.borderColor = FONTCOLOR_BLACK.CGColor;
    self.addPicsBtn.contentMode = UIViewContentModeCenter;
    [self.addPicsBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addPicsBtn addTarget:self action:@selector(addPics:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageV addSubview:self.addPicsBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, ScreenX375(229), SCREEN_WIDTH, 1);
    lineLabel.backgroundColor = LineColor;
    [self addSubview:lineLabel];
    
}

- (void)addPics:(UIButton *)button
{
    NSInteger indexPath = button.tag;
    if (_selectPicsBlock) {
        _selectPicsBlock(indexPath);
    }
}

#pragma mark - 设置textView显示的内容
- (void)setTextViewStr:(NSString *)string
{
    self.textV.text = string;
}

#pragma mark - 设置textView显示的内容
- (void)setImage:(UIImage *)image
{
    self.imageV.image = image;
}

- (void)hiddenAddPic
{
    [self.addPicsBtn setImage:nil forState:UIControlStateNormal];
}

- (void)textViewResignFirstResponder
{
    [self.textV resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *num = [NSString stringWithFormat:@"%@",self.indexpath];
    NSInteger indexNum = [num integerValue];
    if (self.textViewDidEndEditingBlock) {
        self.textViewDidEndEditingBlock(textView.text, indexNum);
    }
}


@end
