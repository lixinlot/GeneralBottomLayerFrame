//
//  WeatherVC.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/8/21.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "WeatherVC.h"
#import "WHWeatherView.h"

@interface WeatherVC ()

@property (nonatomic,strong)  WHWeatherView *weatherView;

@end

@implementation WeatherVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidesBottomBarWhenPushed];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:24/255.0 green:110/255.0 blue:255/255.0 alpha:1.0];
    [self setWeatherVC];
}

-(void)setWeatherVC
{
    self.weatherView = [[WHWeatherView alloc] init];
    self.weatherView.frame = self.view.bounds;
    [self.view addSubview:self.weatherView];
    
    [self.weatherView showWeatherAnimationWithType:WHWeatherTypeSun];
}

/*
 typedef NS_ENUM(NSInteger, WHWeatherType){
 WHWeatherTypeSun = 0,
 WHWeatherTypeClound = 1,
 WHWeatherTypeRain = 2,
 WHWeatherTypeRainLighting = 3,
 WHWeatherTypeSnow = 4,
 WHWeatherTypeOther = 5
 };
 */

@end
