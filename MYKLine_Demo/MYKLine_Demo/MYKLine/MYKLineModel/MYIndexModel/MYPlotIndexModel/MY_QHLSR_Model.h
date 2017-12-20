//
//  MY_QHLSR_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 阻力指标　QHLSR 　判断原则是：当持股处盈利状态，趋势（无论中短期）出现逆转，原则是首先考虑减仓操作。如果持股处于亏损被套的（有的是追高买入造成的，应该写检讨记录在案警示），中期趋势出现逆转时，仍然是首先应该考虑减仓操作。明显上升通道以及箱型整理的持股，在上轨处作卖出操作。在通道下轨或箱体下轨处的回补必须非常小心。
 */

@interface MY_QHLSR_Model : NSObject
@property (nonatomic, assign) double QHL5;
@property (nonatomic, assign) double QHL10;

@property (nonatomic, assign) double QHL5_Height;
@property (nonatomic, assign) double QHL10_Height;

@property (nonatomic, assign) double Width;
@end
