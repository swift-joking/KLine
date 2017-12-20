//
//  MYKLineTool+TimeSharing.h
//  XinShengInternational
//
//  Created by michelle on 2017/10/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool.h"

@interface MYKLineTool (TimeSharing)


/**
 画分时图背景线

 @param view 分时图背景view
 */
+ (void)drawTimeSharingBackgroundLineWithView:(UIView *)view;


/**
 画分时图k线

 @param view 分时图背景view
 */
+ (void)drawTimeSharingKLineWithView:(UIView *)view;
@end
