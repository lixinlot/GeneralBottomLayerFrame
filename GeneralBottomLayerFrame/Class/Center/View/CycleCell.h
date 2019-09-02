//
//  CycleCell.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/12.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CycleModel;

@interface CycleCell : UITableViewCell

+ (CycleCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)  CycleModel  * cycleModel;

@property (nonatomic,strong)  void(^selectPicsBlock)(NSInteger  index);

@property (nonatomic,strong)  void(^textViewDidEndEditingBlock)(NSString * text, NSInteger  index);

- (void)setTextViewStr:(NSString *)string;

- (void)setImage:(UIImage *)image;

- (void)hiddenAddPic;



@end

@interface CycleModel : NSObject

@property (nonatomic,strong)  UIImage   * iamge;
@property (nonatomic,copy)    NSString  * str;


@end
