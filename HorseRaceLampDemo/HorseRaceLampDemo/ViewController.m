//
//  ViewController.m
//  HorseRaceLampDemo
//
//  Created by Semyon on 16/10/18.
//  Copyright © 2016年 Semyon. All rights reserved.
//

#import "ViewController.h"
#import "XNQHorseRaceLampTool.h"

@interface ViewController () {
    __weak IBOutlet UIView *_raceSuperView;
    XNQHorseRaceLampTool *_lampTool;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self setupLampViewUseTimer];
    [self setupLampViewUseGCD];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_lampTool clearAllTimer]; // 注意释放
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLampViewUseTimer {
    _lampTool = [XNQHorseRaceLampTool initWithSuperView:_raceSuperView contentString:@"我是跑马灯啊!"];
    [_lampTool setLeftMargin:70 rightMargin:30];
    _lampTool.horseRaceLampType = HORSE_RACE_LAMP_Cycle;
//    _lampTool.percentOfFullView = 1.0/3.0;
    [_lampTool runAnimationUseTimer];
}

- (void)setupLampViewUseGCD {
    XNQHorseRaceLampTool *lampTool = [XNQHorseRaceLampTool initWithSuperView:_raceSuperView contentString:@"我是跑马灯啊"];
    [lampTool setLeftMargin:70 rightMargin:30];
    lampTool.horseRaceLampType = HORSE_RACE_LAMP_MultiCycle;
    lampTool.percentOfFullView = 1.0/2.0;
    [lampTool runAnimationUseGCD];
}

@end
