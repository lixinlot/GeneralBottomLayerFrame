//
//  TestViewController2.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "TestViewController2.h"
#import "JKDBHelper.h"
#import "User.h"

@interface TestViewController2 ()

@property (nonatomic,strong)  UILabel  * label1;
@property (nonatomic,strong)  UILabel  * label2;
@property (nonatomic,strong)  UILabel  * label3;

@property (nonatomic,strong)  User  * users;

@end

@implementation TestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.cyanColor;
    
    self.title = self.title1;
    
    UILabel *label1 = [UILabel new];
    label1.frame = CGRectMake(0, 200, SCREEN_WIDTH, 20);
    label1.textColor = [UIColor lightGrayColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    label1.text = self.title1;
    label1.userInteractionEnabled = YES;
    self.label1 = label1;
    UIButton *tap1 = [[UIButton alloc] initWithFrame:label1.frame];
    [tap1 addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tap1];
    
    UILabel *label2 = [UILabel new];
    label2.frame = CGRectMake(0, 200+40, SCREEN_WIDTH, 20);
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    label2.text = self.title2;
    label2.userInteractionEnabled = YES;
    self.label2 = label2;
    UIButton *tap2 = [[UIButton alloc] initWithFrame:label2.frame];
    [tap2 addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tap2];
    
    UILabel *label3 = [UILabel new];
    label3.frame = CGRectMake(0, 200+40+40, SCREEN_WIDTH, 20);
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label3];
    label3.text = self.title3;
    label3.userInteractionEnabled = YES;
    self.label3 = label3;
    UIButton *tap3 = [[UIButton alloc] initWithFrame:label3.frame];
    [tap3 addTarget:self action:@selector(upDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tap3];
    
    
    self.users = ({User *users = [[User alloc] init]; users; });
    [self.users addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc {
    [self.users removeObserver:self forKeyPath:@"age"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static NSInteger age = 10;
    self.users.age = [[NSString stringWithFormat:@"%ld",++age] intValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"change:%@",change);
}

- (void)addClick:(UIButton *)button {
    button.selected = !button.selected;
    User *user = [[User alloc] init];
    if (button.selected == YES) {
        user.name = @"麻子";
        user.sex = @"男";
        user.age = 10;
        user.createTime = 1368082020;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [user save];
        });
        self.label1.text = user.name;
        NSLog(@"text1:%@",user);
    }else {
        user.name = @"更新";
        user.age = 120;
        user.pk = 5;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [user update];
        });
        self.label1.text = user.name;
        NSLog(@"更新text1:%@",user);
    }
}

- (void)delete:(UIButton *)button {
    button.selected = !button.selected;
    User *user = [[User alloc] init];
    if (button.selected == YES) {
        user.name = self.title2;
        user.age = 10;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [user deleteObject];
        });
        self.label2.text = @"";
        NSLog(@"text2:%@",user);
    }else {
        user.name = @"不删除了显示";
        user.age = 20;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [user deleteObject];
        });
        self.label2.text = user.name;
        NSLog(@"不删除了显示text2:%@",user);
    }
    
    if ([User findFirstByCriteria:@" WHERE age = 20 "]) {
        NSLog(@"20");
    }else {
        NSLog(@"不是20");
    }
}

- (void)upDate:(UIButton *)button {
    button.selected = !button.selected;
    User *user = [[User alloc] init];
    if (button.selected == YES) {
        user.name = @"更新";
        user.age = 120;
        user.pk = 5;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [user update];
        });
        self.label3.text = user.name;
        NSLog(@"更新text3:%@",user);
    }else {
        NSMutableArray *array = [NSMutableArray array];
//        dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//        dispatch_async(q1, ^{
            for (int i = 0; i < 5; ++i) {
                User *user = [[User alloc] init];
                user.name = [NSString stringWithFormat:@"这是%d",i];
                user.sex = @"女";
                user.age = i+5;
                [user save];
                [array addObject:user];
            }
//        });
        User *user0 = array[0];
        User *user1 = array[1];
        User *user2 = array[2];
        User *user3 = array[3];
        
        self.label3.text = [NSString stringWithFormat:@"%@+%@+%@+%@",user0.name,user1.name,user2.name,user3.name];
        NSLog(@"更新text3:%@",user);
    }
}

@end
