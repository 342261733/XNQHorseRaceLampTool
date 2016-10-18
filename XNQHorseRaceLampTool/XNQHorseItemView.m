//
//  XNQHorseItemView.m
//
//  Created by Semyon on 16/10/16.
//  Copyright © 2016年 Semyon. All rights reserved.
//

#import "XNQHorseItemView.h"

static CGFloat const HorseRaceLampRunSpeed  = 1.0;
static CGFloat const HorseRaceLampRunTimer  = 0.02;
static CGFloat       PercentOfFullView      = 1.0/3.0;

@interface XNQHorseItemView () {
    UIView *_raceView;
    UILabel *_raceLabel;
    CGRect _oriRect;
    BOOL _isCreateOnce;
}

@property (nonatomic, strong) dispatch_source_t timer; //定时器开始执行的延时时间

@end

@implementation XNQHorseItemView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _isCreateOnce = NO;
    
    return self;
}

- (void)createOneHorseRaceLampLabelUseGCD:(UIView *)superView raceLabel:(UILabel *)raceLabel title:(NSString *)strContent rightMaigin:(CGFloat)rightMargin leftMaigin:(CGFloat)leftMargin fullWidth:(CGFloat)fullContentWidth {
    _raceLabel = [[UILabel alloc] init];
    _raceLabel.text = strContent;
    _raceLabel.textColor = raceLabel.textColor;
    _raceLabel.font = raceLabel.font;
    
    [superView addSubview:_raceLabel];
    [superView sendSubviewToBack:_raceLabel];
    superView.clipsToBounds = YES;
    CGSize contentSize = [strContent boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,  superView.bounds.size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_raceLabel.font} context:nil].size;
    _raceLabel.frame = CGRectMake(superView.frame.size.width - rightMargin, _raceLabel.frame.origin.y, contentSize.width, superView.frame.size.height);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HorseRaceLampRunTimer * NSEC_PER_SEC));
    dispatch_source_set_timer(_timer, startDelayTime, HorseRaceLampRunTimer * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:HorseRaceLampRunTimer animations:^{
                CGRect rect = _raceLabel.frame;
                rect.origin.x -= HorseRaceLampRunSpeed;
                _raceLabel.frame = rect;
            } completion:^(BOOL finished) {
                if (_raceLabel.frame.origin.x < -_raceLabel.frame.size.width + leftMargin) {
                    CGRect rect = _raceLabel.frame;
                    rect.origin.x = superView.frame.size.width - rightMargin;
                    _raceLabel.frame = rect;
                }
            }];
        });
    });
}

- (void)createMoreHorseRaceLampLabelUseGCD:(UIView *)superView raceLabel:(UILabel *)raceLabel title:(NSString *)strContent rightMaigin:(CGFloat)rightMargin leftMaigin:(CGFloat)leftMargin fullWidth:(CGFloat)fullContentWidth {
    if (_percentOfFullView) {
        PercentOfFullView = _percentOfFullView;
    }
    CGFloat percent =  1.0/ PercentOfFullView;
    CGSize contentSize = [strContent boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,  superView.bounds.size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:raceLabel.font} context:nil].size;
    
    CGFloat realContent = superView.frame.size.width - leftMargin - rightMargin;
    CGFloat viewWidth = contentSize.width * percent + realContent ;
    _raceView = [[UIView alloc] init];
    _oriRect = CGRectMake(superView.frame.size.width - rightMargin, 0, viewWidth, superView.frame.size.height);
    _raceView.frame = _oriRect;

    [superView addSubview:_raceView];
    [superView sendSubviewToBack:_raceView];
    for (int i=0; i< (int)percent; i++) {
        CGFloat labelX = i * (contentSize.width + realContent / percent);
        UILabel *label = [[UILabel alloc] init];
        label.text = strContent;
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(labelX, 0, contentSize.width, superView.frame.size.height);
        [label  sizeToFit];
        label.center = CGPointMake(label.center.x, _raceView.center.y);
        [_raceView addSubview:label];
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HorseRaceLampRunTimer * NSEC_PER_SEC));
    dispatch_source_set_timer(_timer, startDelayTime, HorseRaceLampRunTimer * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (((fullContentWidth - _raceView.frame.origin.x) >= (_raceView.frame.size.width - leftMargin)) &&
                (fullContentWidth - _raceView.frame.origin.x) < (_raceView.frame.size.width - leftMargin + HorseRaceLampRunSpeed * 10)) {
                if (!_isCreateOnce) {
                    if (self.createBlock) {
                        self.createBlock();
                        _isCreateOnce = YES;
                    }
                }
            }
            if ((fullContentWidth -_raceView.frame.origin.x + leftMargin) >= 2.00 * (_raceView.frame.size.width)) {
                [self restart];
            }
            
            [UIView animateWithDuration:HorseRaceLampRunTimer animations:^{
                CGRect rect = _raceView.frame;
                rect.origin.x -= HorseRaceLampRunSpeed;
                _raceView.frame = rect;
            } completion:^(BOOL finished) {
            }];
        });
    });
}



- (void)start {
    dispatch_resume(_timer);
}

- (void)restart {
    if (_raceView.frame.origin.x > 0) {
        return;
    }
    _raceView.frame = _oriRect;
}

- (void)stop {
    dispatch_source_cancel(_timer);
}

@end
