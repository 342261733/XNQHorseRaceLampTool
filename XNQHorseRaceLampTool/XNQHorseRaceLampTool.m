//
//  XNQHorseRaceLampTool.m
//
//  Created by Semyon on 16/10/11.
//  Copyright © 2016年 Semyon. All rights reserved.
//

#import "XNQHorseRaceLampTool.h"
#import "XNQHorseItemView.h"

static CGFloat const HorseRaceLampRunSpeed  = 1.0;
static CGFloat const HorseRaceLampRunTimer  = 0.02;

@interface XNQHorseRaceLampTool () {
    UIView              *_superView;
    NSString            *_strContent;
    UILabel             *_raceLabel;
    NSMutableArray      *_arrTimers;
    CGFloat             _fullContentWidth;  // 整个跑的宽度
    CGFloat             _leftMargin;        // 左边开始区域距离
    CGFloat             _rightMargin;       // 右边消失区域距离
    NSMutableDictionary *_dicLastOriX;      //
}

@property (nonatomic, strong) dispatch_source_t timer; //定时器开始执行的延时时间

@end

@implementation XNQHorseRaceLampTool

- (void)dealloc {
    
}

+ (XNQHorseRaceLampTool *)initWithSuperView:(UIView *)superView contentString:(NSString *)strContent {
    UILabel *defaultLabel = [[UILabel alloc] init];
    defaultLabel.text = strContent;
    defaultLabel.font = [UIFont systemFontOfSize:15.0];
    defaultLabel.textColor = [UIColor blackColor];
    return [self initWithSuperView:superView raceLabel:defaultLabel contentString:strContent];
}

+ (XNQHorseRaceLampTool *)initWithSuperView:(UIView *)superView raceLabel:(UILabel *)raceLabel contentString:(NSString *)strContent {
    XNQHorseRaceLampTool *lampTool = [[XNQHorseRaceLampTool alloc] init];
    lampTool->_superView = superView;
    lampTool->_strContent = strContent;
    lampTool->_raceLabel = raceLabel;
    return lampTool;
}

- (void)runAnimationUseGCD {
    if (_horseRaceLampType == HORSE_RACE_LAMP_Cycle) {
        [self createOneHorseRaceLampLabelUseGCD];
    }
    else {
        [self createMoreHorseRaceLampLabelUseGCD];
    }
}

- (void)runAnimationUseTimer {
    [self createNewHorseRaceLampLabel];
}

- (void)setLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    _fullContentWidth = _superView.frame.size.width - leftMargin - rightMargin;
    _leftMargin = leftMargin;
    _rightMargin = rightMargin;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _arrTimers = [NSMutableArray array];
    _dicLastOriX = [NSMutableDictionary dictionary];
    _horseRaceLampType = HORSE_RACE_LAMP_Cycle;
    _percentOfFullView = 1.0 / 3.0; // 默认占屏幕1/3
    [self setLeftMargin:0 rightMargin:0];
    return self;
}

- (void)createOneHorseRaceLampLabelUseGCD {
    XNQHorseItemView *oneHoreItem = [[XNQHorseItemView alloc] init];
    [oneHoreItem createOneHorseRaceLampLabelUseGCD:_superView raceLabel:_raceLabel title:_strContent rightMaigin:_rightMargin leftMaigin:_leftMargin fullWidth:_fullContentWidth];
    [oneHoreItem start];
}

- (void)createMoreHorseRaceLampLabelUseGCD {
    XNQHorseItemView *horseItem = [[XNQHorseItemView alloc] init];
    if (_percentOfFullView != 0) {
        horseItem.percentOfFullView = _percentOfFullView;
    }
    [horseItem createMoreHorseRaceLampLabelUseGCD:_superView raceLabel:_raceLabel title:_strContent rightMaigin:_rightMargin leftMaigin:_leftMargin fullWidth:_fullContentWidth];
    [horseItem start];
    
    XNQHorseItemView *horseItem2 = [[XNQHorseItemView alloc] init];
    if (_percentOfFullView != 0) {
        horseItem2.percentOfFullView = _percentOfFullView;
    }
    [horseItem2 createMoreHorseRaceLampLabelUseGCD:_superView raceLabel:_raceLabel title:_strContent rightMaigin:_rightMargin leftMaigin:_leftMargin fullWidth:_fullContentWidth];
    __weak typeof(horseItem2) weakItem2 = horseItem2;
    horseItem.createBlock = ^(void) {
        if (!weakItem2) {
            return ;
        }
        [weakItem2 start];
    };
}

- (void)createNewHorseRaceLampLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = _strContent;
    label.textColor = [UIColor whiteColor];
    [_superView addSubview:label];
    [_superView sendSubviewToBack:label];
    _superView.clipsToBounds = YES;
    CGSize contentSize = [_strContent boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,  _superView.bounds.size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    label.frame = CGRectMake(_superView.frame.size.width - _rightMargin, _raceLabel.frame.origin.y, contentSize.width, _superView.frame.size.height);
    
    NSMutableDictionary *dicLabelInfo = [[NSMutableDictionary alloc] init];
    [dicLabelInfo setObject:label forKey:@"HorseRaceLampTool.raceLabel"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:HorseRaceLampRunTimer target:self selector:@selector(timerRunHorseRaceLamp:) userInfo:dicLabelInfo repeats:YES];
    [timer fire];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [_arrTimers addObject:timer];
}

- (void)timerRunHorseRaceLamp:(NSTimer *)timer {

    UILabel *raceLabel = [[timer userInfo] objectForKey:@"HorseRaceLampTool.raceLabel"];
    
    if (self.horseRaceLampType == HORSE_RACE_LAMP_Cycle) {
        if (raceLabel.frame.origin.x < -raceLabel.frame.size.width + _leftMargin) {
            CGRect rect = raceLabel.frame;
            rect.origin.x = _superView.frame.size.width - _rightMargin;
            raceLabel.frame = rect;
        }
    }
    else if (self.horseRaceLampType == HORSE_RACE_LAMP_MultiCycle) {
        NSNumber *lastOriX = [_dicLastOriX objectForKey:[NSString stringWithFormat:@"%p", timer]];
        if (lastOriX.doubleValue == raceLabel.frame.origin.x) { // **** 修复NSTimer执行两次相同的坐标，导致重复创建label问题。
            return ;
        }
        [_dicLastOriX setObject:@(raceLabel.frame.origin.x) forKey:[NSString stringWithFormat:@"%p", timer]];
        
        if (((_fullContentWidth - (raceLabel.frame.size.width + raceLabel.frame.origin.x - _leftMargin)) == (_fullContentWidth * _percentOfFullView)) ||
            ((_fullContentWidth - (raceLabel.frame.size.width + raceLabel.frame.origin.x  - _leftMargin)) > (_fullContentWidth * _percentOfFullView) && (_fullContentWidth - (raceLabel.frame.size.width + raceLabel.frame.origin.x  - _leftMargin)) < (_fullContentWidth * _percentOfFullView + HorseRaceLampRunSpeed))) {
            [self createNewHorseRaceLampLabel];
        }
        if (((-raceLabel.frame.origin.x - _leftMargin) >= raceLabel.frame.size.width)) {
            [self performSelector:@selector(valideTimer:label:) withObject:timer withObject:raceLabel];
        }
    }
    
    [UIView animateWithDuration:HorseRaceLampRunTimer animations:^{
        CGRect rect = raceLabel.frame;
        rect.origin.x -= HorseRaceLampRunSpeed;
        raceLabel.frame = rect;
    } completion:nil];
}

- (void)valideTimer:(NSTimer *)timer label:(UILabel *)label {
    if ([_arrTimers indexOfObject:timer] == NSNotFound) {
        return;
    }
    [_dicLastOriX removeObjectForKey:[NSString stringWithFormat:@"%p", timer]];
    [_arrTimers removeObject:timer];
    [timer invalidate];
    timer = nil;
    [label removeFromSuperview];
}

- (void)clearAllTimer {
    for (NSTimer __strong *timer in _arrTimers) {
        @try {
            [timer invalidate];
            timer = nil;
        } @catch (NSException *exception) {
            NSLog(@"exception:%@", exception);
        } @finally {
            
        }
    }
    [_arrTimers removeAllObjects];
}

@end
