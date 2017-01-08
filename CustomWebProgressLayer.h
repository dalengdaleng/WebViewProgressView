//
//  CustomWebProgressLayer.h
//  LLFoundation
//
//  Created   on 16/12/8.
//  Copyright © 2016年 All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CustomWebProgressLayer : CAShapeLayer

- (void)startLoad;
- (void)finishedLoad;

@end
