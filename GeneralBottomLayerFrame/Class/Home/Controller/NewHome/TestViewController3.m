//
//  TestViewController3.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/8/19.
//  Copyright © 2019年 皇后娘娘. All rights reserved.
//

#import "TestViewController3.h"

@interface TestViewController3 ()

@end

@implementation TestViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.redColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.frame = CGRectMake(5, 5, kScreenWidth-10, kScreenHeight-10);
    label.textColor = UIColor.blackColor;
    label.font = Rfont(13);
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
    label.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",@"#include <CoreGraphics/CGBase.h>定义类本库中的一些宏和配置",@"#include <CoreGraphics/CGAffineTransform.h>包含一些形变方法，比如我们经常用到的CGAffineTransformMake()",@"#include <CoreGraphics/CGBitmapContext.h>位图绘制环境",@"#include <CoreGraphics/CGColor.h>绘图颜色，区分UIColor、CIColor",@"#include <CoreGraphics/CGColorConversionInfo.h>定义颜色的一组组件，带有指定如何解释它们的颜色空间",@"#include <CoreGraphics/CGColorSpace.h>指定如何解释用于显示的颜色值的配置文件",@"#include <CoreGraphics/CGContext.h>2D绘图会话",@"#include <CoreGraphics/CGDataConsumer.h>内存写入管理",@"#include <CoreGraphics/CGDataProvider.h>内存读取管理",@"#include <CoreGraphics/CGError.h>错误分析",@"#include <CoreGraphics/CGFont.h>2D绘图字体",@"#include <CoreGraphics/CGFunction.h>     定义和使用回调函数的通用工具",@"#include <CoreGraphics/CGGradient.h>用于绘制径向和轴向渐变填充的颜色的平滑过渡的定义",@"#include <CoreGraphics/CGImage.h>返回纹理的图像数据作为一个Quartz 2D图像",@"#include <CoreGraphics/CGLayer.h>一个幕后上下文，用于重用以核心图形绘制的内容",@"#include <CoreGraphics/CGPDFArray.h>封装了一个PDF数组的不透明类型",@"#include <CoreGraphics/CGPDFContentStream.h>   一种不透明的类型，它提供对描述PDF页面外观的数据的访问",@"#include <CoreGraphics/CGPDFContext.h>操作PDF的会话",@"#include <CoreGraphics/CGPDFDictionary.h>封装了一个PDF字典的类型",@"#include <CoreGraphics/CGPDFDocument.h>包含PDF的文档",@"#include <CoreGraphics/CGPDFObject.h>PDF实例化",@"#include <CoreGraphics/CGPDFOperatorTable.h>为PDF操作符存储回调函数的类型",@"#include <CoreGraphics/CGPath.h>核心图形的路径",@"#include <CoreGraphics/CGPDFString.h>表示PDF文档中的字符串的数据类型"];

//#include <CoreGraphics/CGPDFPage.h>            一种表示PDF文档中的页面的类型。
//#include <CoreGraphics/CGPDFScanner.h>         解析PDF扫描对象的内容流。
//#include <CoreGraphics/CGPDFStream.h>          表示PDF流的类型。
//。
//。
//#include <CoreGraphics/CGPattern.h>            用于绘制图形路径的2D模式。
//#include <CoreGraphics/CGShading.h>            由您提供的自定义函数控制的颜色平滑过渡的定义，用于绘制径向和轴向渐变填充。
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
