# XNQHorseRaceLampTool
# 跑马灯效果集成工具

需要开发者自己写父View，本类在父View上继承动画效果

## 支持两种类型：

- HORSE_RACE_LAMP_Cycle ： 普通的循环跑
- HORSE_RACE_LAMP_MultiCycle ： 多个文字铺满屏幕一起循环跑

## 使用方法：

### NSTimer

```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _lampTool = [XNQHorseRaceLampTool initWithSuperView:_contentView contentString:@"我是跑马灯啊！哈"];
    [_lampTool setLeftMargin:70 rightMargin:30];
    _lampTool.horseRaceLampType = HORSE_RACE_LAMP_MultiCycle;
    _lampTool.percentOfFullView = 1.0/3.0;
    [_lampTool runAnimationUseTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_lampTool clearAllTimer];
}

```

### GCD

```
- (void)setupLampViewUseGCD {
    XNQHorseRaceLampTool *lampTool = [XNQHorseRaceLampTool initWithSuperView:_raceSuperView contentString:@"我是跑马灯啊"];
    [lampTool setLeftMargin:70 rightMargin:30];
    lampTool.horseRaceLampType = HORSE_RACE_LAMP_MultiCycle;
    lampTool.percentOfFullView = 1.0/2.0;
    [lampTool runAnimationUseGCD];
}
```

两种方法思路不同，但是效果是一样的。用其中一种即可。

# Pod 支持

pod 'XNQHorseRaceLampTool'
