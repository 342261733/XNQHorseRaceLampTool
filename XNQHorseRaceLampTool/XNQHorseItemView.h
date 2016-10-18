//
//  XNQHorseItemView.h
//  CycleLabelDemo
//
//  Created by Semyon on 16/10/16.
//  Copyright © 2016年 Semyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNQHorseRaceLampTool.h"

@interface XNQHorseItemView : UIView

@property (nonatomic, copy) void(^createBlock)(void);
@property (nonatomic, assign) CGFloat percentOfFullView; // **** HORSE_RACE_LAMP_MultiCycle 类型下，可以设置多个间隙所占全部的比例。

- (void)createOneHorseRaceLampLabelUseGCD:(UIView *)superView raceLabel:(UILabel *)raceLabel title:(NSString *)strContent rightMaigin:(CGFloat)rightMargin leftMaigin:(CGFloat)leftMargin fullWidth:(CGFloat)fullContentWidth;

- (void)createMoreHorseRaceLampLabelUseGCD:(UIView *)superView raceLabel:(UILabel *)raceLabel title:(NSString *)strContent rightMaigin:(CGFloat)rightMargin leftMaigin:(CGFloat)leftMargin fullWidth:(CGFloat)fullContentWidth;

- (void)start;
- (void)restart;
- (void)stop;

@end
