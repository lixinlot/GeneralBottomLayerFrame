//
//  TestViewController1.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "TestViewController1.h"
#import <QuartzCore/QuartzCore.h>

@implementation DrawTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //创建cell的子控件
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.block) {
        self.block(self);
    }
}

#pragma mark - 快速创建Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DrawTableViewCell";
    DrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DrawTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (void)setBlock:(void (^)(UITableViewCell *))block {
    _block = block;
    [self setNeedsDisplay];
}

@end

@interface TestViewController1 ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *mainTableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation TestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = [ViewModel tableViewDatas];
    [self.view addSubview:self.mainTableView];
//    [self saveViewImageToAlbum];
}

#pragma mark - 将tableView截图保存到相册
- (void)saveViewImageToAlbum {
    CGRect oldFrame = self.mainTableView.frame;
    self.mainTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1600);
    UIGraphicsBeginImageContextWithOptions(self.mainTableView.frame.size, self.mainTableView.opaque, 1);
    [self.mainTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    self.mainTableView.frame = oldFrame;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawTableViewCell *cell = [DrawTableViewCell cellWithTableView:tableView];
    cell.block = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - 懒加载
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        //_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end


@implementation ViewModel

+ (NSArray *)tableViewDatas {
    NSMutableArray *arr = [NSMutableArray array];
    //MARK: ---------------------------    画圆
    void (^drawArc)(UITableViewCell *cell) = ^(UITableViewCell *cell){//画圆
        //MARK: 绘制文字 drawInRect
        [self drawText:@"画圆"];
        /**
         首先介绍一个枚举值
         kCGPathFill,           填充非零绕数规则
         kCGPathEOFill,         表示奇偶规则
         kCGPathStroke,         路径
         kCGPathFillStroke,     路劲填充
         kCGPathEOFillStroke    表示描线，不是填充
         这个值可以区分画一个边框（未填充）和填充以及填充类型的图形。
         */
        //MARK: 画一个边框圆    kCGPathStroke
        //第一步：拿到画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //第二步：context 设置线（边框）的颜色 如果需要改变颜色就要设置，如果不设置，使用上次设置的颜色，在同一个View中 UIGraphicsGetCurrentContext()函数每次获取的 context都是同一个
        CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0);//context red green blue alpha
        //第三步：设置线（边框）宽
        CGContextSetLineWidth(context, 1.0);
        //第四步：在画板上添加一个圆  AddArc
        //(1).context (2).x y 为圆点原点 (3).radius 半径 (4).startAngle 开始角度
        //(5).endAngle 结束角度 (6).clockwise 0 为顺时针 1 为逆时针
        CGContextAddArc(context, 80, 50, 25, 0, 2 * M_PI, 0);// context x y radius startAngle endAngle clockwise
        //第五步：开始画（绘制）kCGPathStroke 画线、不填充
        CGContextDrawPath(context, kCGPathStroke);//路径
        
        //无填充的圆
        CGContextRef customContext = UIGraphicsGetCurrentContext();
        //设置边框颜色
        CGContextSetRGBStrokeColor(customContext, 1, 1, 1, 0.5);
        //设置边框宽度
        CGContextSetLineWidth(customContext, 0.5);
        //画圆
        CGContextAddArc(customContext, 10, 10, 10, 0, 2*M_PI, 0);
        //绘制
        CGContextDrawPath(customContext, kCGPathStroke);
        
        /**
         kCGLineCapButt,
         kCGLineCapRound,
         kCGLineCapSquare
         */
        //MARK: 画一个填充圆
        //第二步：设置填充颜色
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        //第四步：在画板上添加圆
        CGContextAddArc(context, 160, 50, 25, 0, 2 * M_PI, 0);
        //第五步：画圆，kCGPathFill 填充
        CGContextDrawPath(context, kCGPathFill);
        
        //MARK: 画一个带边框的填充圆
        //第二步：设置线颜色和填充颜色
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        //第三步：设置线宽
        CGContextSetLineWidth(context, 3.0);
        //第四步：在画板上添加圆
        CGContextAddArc(context, 240, 50, 25, 0, 2 * M_PI, 0);
        //第五步：绘制  kCGPathFillStroke 边框加填充
        CGContextDrawPath(context, kCGPathFillStroke);
        //MARK: 画一段文字 换行也会识别
        NSString *str = @"kCGPathFill,\nkCGPathEOFill,\nkCGPathStroke,\nkCGPathStroke,\nkCGPathFillStroke,\nkCGPathEOFillStroke";
        [str drawInRect:CGRectMake(15, 120, 300, 80) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
        NSString *text = @"填充非零绕数规则\n表示奇偶规则\n路径\n路劲填充\n表示描线，不是填充";
        [text drawInRect:CGRectMake(150, 120, 300, 80) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
    };
    [arr addObject:drawArc];
    
    //MARK: ---------------------------  画线
    void (^drawLine)(UITableViewCell *cell) = ^(UITableViewCell *cell){//画线
        //MARK: 绘制文字
        [self drawText:@"画线和弧线"];
        //MARK: 画线
        //第一步：拿到画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //第二步：准备画线的点
        CGPoint aPoints[2];//坐标点数组
        aPoints[0] = CGPointMake(100, 30);//坐标1
        aPoints[1] = CGPointMake(200, 30);//坐标2
        //第三步：设置线的颜色
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        //第四步：在画板上添加一条线
        /**
         1.context
         2.points 坐标点数组
         3.cout 大小
         */
        CGContextAddLines(context, aPoints, 2);//添加线
        //第五步：绘制
        CGContextDrawPath(context, kCGPathStroke);//绘制路径
        
        //MARK: 画笑脸弧线
        //左边
        CGContextSetRGBStrokeColor(context, 0, 1, 0.5, 1.0);
        CGContextMoveToPoint(context, 220, 25);//开始坐标p1
        /**
         1.context
         2.x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,
         3.radius半径,注意, 需要算好半径的长度,
         
         */
        CGContextAddArcToPoint(context, 228, 13, 236, 25, 10);
        CGContextDrawPath(context, kCGPathStroke);
        
        //右边
        CGContextMoveToPoint(context, 240, 25);//开始坐标p1
        CGContextAddArcToPoint(context, 248, 13, 256, 25, 10);
        CGContextStrokePath(context);
        //下边
        CGContextMoveToPoint(context, 230, 35);//开始坐标p1
        CGContextAddArcToPoint(context, 238, 42, 246, 35, 10);
        CGContextStrokePath(context);
        //MARK: 绘制文字
        NSString *text = @"画圆弧需注意：\n1.context\n2.x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,\n3.radius半径,注意, 需要算好半径的长度,";
        [text drawInRect:CGRectMake(15, 80, 300, 120) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
    };
    [arr addObject:drawLine];
    
    //MARK: ---------------------------    绘制矩形以及渐变色填充
    void (^drawRec)(UITableViewCell *cell) = ^(UITableViewCell *cell){//矩形
        //MARK: 绘制文字
        [self drawText:@"画矩形"];
        //MARK: 画一个矩形
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //画方框
        CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(60, 10, 50, 50));
        //MARK: 画一个填充矩形
        CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
        CGContextFillRect(context, CGRectMake(120, 10, 50, 50));
        //MARK: 画一个渐变色填充矩形
        /**接下来介绍几种填充渐变色的方式 第一种 是在 QuartzCore 框架下得实现方式，第二种才是 CoreGraphics方式，虽然都能实现渐变色，但是两种截然不同的东西*/
        /**
         第一种填充方式必须导入quartcore #import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
         */
        //CAGradientLayer 插入后一直会存在layer层中所以会被复用；CoreGraphics绘图操作为什么不会出现复用问题，
//        CAGradientLayer *gradient1 = [CAGradientLayer layer];
//        gradient1.frame = CGRectMake(300, 10, 50, 50);
//        gradient1.colors = @[(id)[UIColor whiteColor].CGColor,
//                             (id)[UIColor grayColor].CGColor,
//                             (id)[UIColor blackColor].CGColor,
//                             (id)[UIColor yellowColor].CGColor,
//                             (id)[UIColor blueColor].CGColor,
//                             (id)[UIColor redColor].CGColor,
//                             (id)[UIColor greenColor].CGColor,
//                             (id)[UIColor orangeColor].CGColor,
//                             (id)[UIColor brownColor].CGColor];
//        [cell.layer insertSublayer:gradient1 atIndex:0];
        NSLog(@"%@",cell.layer.sublayers);
        /**
         第二种填充方式 CGGradientRef
         */
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colors[] = {
            1,1,1,1.0,
            1,1,0,1.0,
            1,0,0,1.0,
            1,0,1,1.0,
            0,1,1,1.0,
            0,1,0,1.0,
            0,0,1,1.0,
            0,0,0,1.0,
        };
        CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0]) * 4));//形成梯形渐变效果
        CGColorSpaceRelease(rgb);
        //画线形成一个矩形
        //CGContextSaveGState 与 CGContextRestoreGState 的作用
        /**
         CGContextSaveGState 函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的的描画操作，但不影响存储在栈堆中的拷贝。在修改完成后，您可以通过 CGContextRestoreGState 函数把栈堆顶部状态弹出，返回之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤销所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
         */
        CGContextSaveGState(context);
        CGContextMoveToPoint(context, 190, 10);
        CGContextAddLineToPoint(context, 240, 10);
        CGContextAddLineToPoint(context, 240, 65);
        CGContextAddLineToPoint(context, 190, 65);
        CGContextClip(context);//contenxt 裁剪路径，后续操作的路径
        CGContextDrawLinearGradient(context, gradient, CGPointMake(190, 10), CGPointMake(190, 65), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        /**
         下面再看一个颜色渐变的圆
         */
        CGContextDrawRadialGradient(context, gradient, CGPointMake(260, 20), 0, CGPointMake(260, 20), 20, kCGGradientDrawsBeforeStartLocation);
        
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        //MARK: 绘制文字
        [@"CGContextSaveGState 函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的的描画操作，但不影响存储在栈堆中的拷贝。在修改完成后，您可以通过 CGContextRestoreGState 函数把栈堆顶部状态弹出，返回之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤销所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。" drawInRect:CGRectMake(15, 70, [UIScreen mainScreen].bounds.size.width - 30, 140) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
        
    };
    [arr addObject:drawRec];
    
    //MARK: ---------------------------    绘制椭圆
    void (^drawEllipse)(UITableViewCell *cell) = ^(UITableViewCell *cell){//椭圆
        //MARK: 绘制文字
        [self drawText:@"画扇形和椭圆"];
        //MARK: 画一个扇形
        CGContextRef context = UIGraphicsGetCurrentContext();
        //画扇形，也就是画圆，只不过是设置角度的大小，形成一个扇形
        CGContextSetFillColorWithColor(context, [UIColor magentaColor].CGColor);
        CGContextMoveToPoint(context, 125, 45);
        CGContextAddArc(context, 125, 45, 35, - M_PI_4, - 3 * M_PI_4, 1);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
        //MARK: 画椭圆
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(195, 10, 50, 40));
        CGContextDrawPath(context, kCGPathFillStroke);
        //MARK: 绘制文字
        [@"画扇形其实就是画圆，只不过是设置角度大小形成一个扇形；\n CGContextAddEllipseInRect函数画椭圆" drawInRect:CGRectMake(15, 70, [UIScreen mainScreen].bounds.size.width - 30, 140) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
        
    };
    [arr addObject:drawEllipse];
    
    //MARK: ---------------------------    画圆角矩形
    void (^drawRaAr)(UITableViewCell *cell) = ^(UITableViewCell *cell){
        //MARK:绘制文字
        [self drawText:@"画圆角矩形"];
        //MARK:画一个圆角矩形
        CGContextRef context = UIGraphicsGetCurrentContext();
        float fw = 220;
        float fh = 70;
        CGContextMoveToPoint(context, fw, fh - 20);//开始坐标
        CGContextAddArcToPoint(context, fw, fh, fw - 20, fh, 10);//右下角角度
        CGContextAddArcToPoint(context, 120, fh, 120, fh - 20, 10);//左下角角度
        CGContextAddArcToPoint(context, 120, 20, 120 + 20, 20, 10);//左上角角度
        CGContextAddArcToPoint(context, fw, 20, fw, 40, 10);//右上角角度
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    };
    [arr addObject:drawRaAr];
    
    //MARK: ---------------------------   三角形
    void (^drawThree)(UITableViewCell *cell) = ^(UITableViewCell *cell){//三角形
        //MARK:绘制文字
        [self drawText:@"画三角形"];
        //MARK:画一个三角形
        CGContextRef context = UIGraphicsGetCurrentContext();
        /**
         画三角形只需要知道三个点，把三个点连起来
         */
        CGPoint points[3];
        points[0] = CGPointMake(200, 50);
        points[1] = CGPointMake(100, 150);
        points[2] = CGPointMake(300, 150);
        CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
        CGContextSetLineWidth(context, 3.0);
        CGContextAddLines(context, points, 3);//添加线
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    };
    [arr addObject:drawThree];
    
    //MARK: ---------------------------   贝塞尔
    void (^drawQua)(UITableViewCell *cell) = ^(UITableViewCell *cell){
        //MARK:绘制文字
        [self drawText:@"画贝塞尔曲线"];
        //MARK:二次曲线
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
        CGContextMoveToPoint(context, 15, 60);
        CGContextAddQuadCurveToPoint(context, 155, 120, 300, 40);//设置贝塞尔曲线的控制点和终点坐标
        CGContextStrokePath(context);
        /**
         ===================================三次曲线
         */
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextMoveToPoint(context, 15, 150);
        CGContextAddCurveToPoint(context, 100, 20, 100, 120, 300, 150);//设置两个控制点和终点
        CGContextStrokePath(context);
    };
    [arr addObject:drawQua];
    
    //MARK: ---------------------------   图片
    void (^drawImg)(UITableViewCell *cell) = ^(UITableViewCell *cell){//图片
        //MARK:绘制文字
        [self drawText:@"图片"];
        //MARK:绘制五张图片
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (int i = 1; i <= 11; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [image drawInRect:CGRectMake(15 + (i - 1) * 30, 50, 20, 20)];
            CGContextDrawImage(context, CGRectMake(15 + (i - 1) * 30, 50, 20, 20), image.CGImage);
        }
        
    };
    [arr addObject:drawImg];
    return arr;
}

#pragma mark - 显示文字
+ (void)drawText:(NSString *)str {
    [str drawInRect:CGRectMake(15, 30, 90, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    NSInteger index1 = 10;
    void(^testBlock1)(void) = ^{
        
        NSLog(@"此时的index1是：%ld",index1);
    };
    
    index1 = 200;
    testBlock1();
    
    __block NSInteger index2 = 10;
    void(^testBlock2)(void) = ^{
        
        NSLog(@"此时的index2是：%ld",index2);
    };
    
    index2 = 200;
    testBlock2();
}

@end
