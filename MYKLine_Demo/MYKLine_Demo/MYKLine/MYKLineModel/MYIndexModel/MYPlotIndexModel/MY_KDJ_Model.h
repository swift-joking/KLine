//
//  MY_KDJ_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 KDJ指标又叫随机指标，是一种相当新颖、实用的技术分析指标，它起先用于期货市场的分析，后被广泛用于股市的中短期趋势分析，是期货和股票市场上最常用的技术分析工具。
 随机指标KDJ一般是用于股票分析的统计体系，根据统计学原理，通过一个特定的周期（常为9日、9周等）内出现过的最高价、最低价及最后一个计算周期的收盘价及这三者之间的比例关系，来计算最后一个计算周期的未成熟随机值RSV，然后根据平滑移动平均线的方法来计算K值、D值与J值，并绘成曲线图来研判股票走势。
 */
@interface MY_KDJ_Model : NSObject

@property (nonatomic, assign) double RSV;

@property (nonatomic, assign) double K;
@property (nonatomic, assign) double D;
@property (nonatomic, assign) double J;

@property (nonatomic, assign) double K_Height;
@property (nonatomic, assign) double D_Height;
@property (nonatomic, assign) double J_Height;

@property (nonatomic, assign) double Width;
@end
