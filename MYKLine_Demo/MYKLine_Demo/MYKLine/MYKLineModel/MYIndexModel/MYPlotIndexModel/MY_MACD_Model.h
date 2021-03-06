//
//  MY_MACD_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 MACD称为指数平滑移动平均线，是从双指数移动平均线发展而来的，由快的指数移动平均线（EMA12）减去慢的指数移动平均线（EMA26）得到快线DIF，再用2×（快线DIF-DIF的9日加权移动均线DEA）得到MACD柱。MACD的意义和双移动平均线基本相同，即由快、慢均线的离散、聚合表征当前的多空状态和股价可能的发展变化趋势，但阅读起来更方便。当MACD从负数转向正数，是买的信号。当MACD从正数转向负数，是卖的信号。当MACD以大角度变化，表示快的移动平均线和慢的移动平均线的差距非常迅速的拉开，代表了一个市场大趋势的转变。
 
 MACD（Moving Average Convergence and Divergence)是Geral Appel 于1970年提出的，利用收盘价的短期（常用为12日）指数移动平均线与长期（常用为26日）指数移动平均线之间的聚合与分离状况，对买进、卖出时机作出研判的技术指标。
 */
@interface MY_MACD_Model : NSObject
@property (nonatomic, assign) double EMA_LONG;
@property (nonatomic, assign) double EMA_SHORT;

@property (nonatomic, assign) double DIF;
@property (nonatomic, assign) double DEA;
@property (nonatomic, assign) double M;

@property (nonatomic, assign) double DIF_Height;
@property (nonatomic, assign) double DEA_Height;
@property (nonatomic, assign) double M_Height;

@property (nonatomic, assign) double Width;
@end
