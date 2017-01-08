//
//  CustomWebProgressLayer
//  LLFoundation
//
//  Created by on 16/12/8.
//  Copyright All rights reserved.
//

#import "CustomWebProgressLayer.h"
//#import "UIColor+HEX.h"

static NSTimeInterval const LLFastTimeInterval = 0.01;
static const float lineWidth = 2.f;
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width


@interface CustomWebProgressLayer ()
@property (nonatomic, strong) CAShapeLayer *layer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval loadTime;
@end

@implementation CustomWebProgressLayer

- (id)init {
    self = [super init];
    if (self) {
        self.lineWidth = lineWidth;
        self.strokeColor = [UIColor redColor].CGColor;//[UIColor colorWithHexString:@"0xffcc99" alpha:1.f].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, lineWidth)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH, lineWidth)];
        
        self.path = path.CGPath;
        self.strokeEnd = 0;
    }
    return self;
}

//开始加载动画
- (void)startLoad {
    self.loadTime = 0.0;
    [self setProgressStrokeEnd:0];
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LLFastTimeInterval
                                                  target:self
                                                selector:@selector(pathChanged:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)pathChanged:(NSTimer *)timer {
    if (self.strokeEnd < 0.8) {
        self.strokeEnd += 0.01;
    }
    else if (self.strokeEnd < 0.95){
        self.strokeEnd += 0.002;
    }
    self.loadTime += LLFastTimeInterval;
}

//结束加载动画
- (void)finishedLoad {
    if (self.loadTime < 0.35) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.25*NSEC_PER_SEC)),
                       dispatch_get_main_queue(),^{
                           [self finished];
                       });
    }
    else{
        [self finished];
    }
}

- (void)finished{
    [self closeTimer];
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.25*NSEC_PER_SEC)),
                   dispatch_get_main_queue(),^{
                       [self setProgressStrokeEnd:0];
                   });
}

- (void)closeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

//无动画
- (void)setProgressStrokeEnd:(CGFloat)strokeEnd{
    if (strokeEnd < self.strokeEnd) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.strokeEnd = strokeEnd;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

- (void)removeFromSuperlayer{
    [self closeTimer];
    [self setProgressStrokeEnd:0];
    [super removeFromSuperlayer];
}

@end
