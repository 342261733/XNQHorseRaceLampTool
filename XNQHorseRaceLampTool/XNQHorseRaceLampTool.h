//
//  XNQHorseRaceLampTool.h
//
//  Created by Semyon on 16/10/11.
//  Copyright © 2016年 Semyon. All rights reserved.
//

/*
 * 跑马灯工具类：只需要传入父view，文字内容。本类功能是将动画集合上去。
 * 注意：在viewDidAppear之后执行，防止superview没有完全加载而导致错误。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HORSE_RACE_LAMP_Cycle,      // **** 普通的循环跑
    HORSE_RACE_LAMP_MultiCycle, // **** 多个文字铺满屏幕一起循环跑
} HorseRaceLampType;

@interface XNQHorseRaceLampTool : NSObject

@property (nonatomic, assign) HorseRaceLampType horseRaceLampType;  // **** 类型：默认是HORSE_RACE_LAMP_Cycle
@property (nonatomic, assign) CGFloat percentOfFullView;            // **** HORSE_RACE_LAMP_MultiCycle 类型下，可以设置多个间隙所占全部的比例。
@property (nonatomic, assign) CGFloat offSetBetweenViews;           // **** HORSE_RACE_LAMP_MultiCycle 类型下,view间隔，有时候可能会不准，需要手动调

+ (XNQHorseRaceLampTool *)initWithSuperView:(UIView *)superView contentString:(NSString *)strContent;

/**
 *  初始化方法
 *
 *  @param superView            所要添加到的父View
 *  @param raceLabel            跑马灯label设置属性
 *  @param strContent           跑马灯内容
 *  @return XNQHorseRaceLampTool对象
 */
+ (XNQHorseRaceLampTool *)initWithSuperView:(UIView *)superView raceLabel:(UILabel *)raceLabel contentString:(NSString *)strContent;

/**
 *  设置边距
 *
 *  @param leftMargin           左边距离
 *  @param rightMargin          右边距离
 */
- (void)setLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

- (void)runAnimationUseGCD;         // **** 开始运行
- (void)runAnimationUseTimer;       //**** 使用timer 注意需要在页面消失的时候，执行clearAllTimer方法。

- (void)clearAllTimer;              // **** 在声明周期结束的时候释放所有的timer，防止内存泄露

@end
