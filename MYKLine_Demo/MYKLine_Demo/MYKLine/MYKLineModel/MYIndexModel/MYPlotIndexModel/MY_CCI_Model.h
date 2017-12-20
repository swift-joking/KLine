//
//  MY_CCI_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 顺势指标又叫CCI指标，CCI指标是美国股市技术分析 家唐纳德·蓝伯特(Donald Lambert)于20世纪80年代提出的，专门测量股价、外汇或者贵金属交易是否已超出常态分布范围。属于超买超卖类指标中较特殊的一种。波动于正无穷大和负无穷大之间。但是，又不需要以0为中轴线，这一点也和波动于正无穷大和负无穷大的指标不同。
 它最早是用于期货市场的判断，后运用于股票市场的研判，并被广泛使用。与大多数单一利用股票的收盘价、开盘价、最高价或最低价而发明出的各种技术分析指标不同，CCI指标是根据统计学原理，引进价格与固定期间的股价平均区间的偏离程度的概念，强调股价平均绝对偏差在股市技术分析中的重要性，是一种比较独特的技术指标。
 它与其他超买超卖型指标又有自己比较独特之处。像KDJ、W%R等大多数超买超卖型指标都有“0-100”上下界限，因此，它们对待一般常态行情的研判比较适用，而对于那些短期内暴涨暴跌的股票的价格走势时，就可能会发生指标钝化的现象。而CCI指标却是波动于正无穷大到负无穷大之间，因此不会出现指标钝化现象，这样就有利于投资者更好地研判行情，特别是那些短期内暴涨暴跌的非常态行情。

 */
@interface MY_CCI_Model : NSObject
@property (nonatomic, assign) double CCI;

@property (nonatomic, assign) double CCI_Height;

@property (nonatomic, assign) double Width;
@end
