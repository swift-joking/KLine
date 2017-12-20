//
//  MY_RSI_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 RSI是Relative Strength Index的缩写。
 相对强弱指数RSI是根据一定时期内上涨点数和涨跌点数之和的比率制作出的一种技术曲线。能够反映出市场在一定时期内的景气程度。由威尔斯.威尔德（Welles Wilder)最早应用于期货买卖，后来人们发现在众多的图表技术分析中，强弱指标的理论和实践极其适合于股票市场的短线投资，于是被用于股票升跌的测量和分析中。该分析指标的设计是以三条线来反映价格走势的强弱，这种图形可以为投资者提供操作依据，非常适合做短线差价操作。
 
 RSI:= SMA(MAX(Close-LastClose,0),N,1)/SMA(ABS(Close-LastClose),N,1)*100
 */
@interface MY_RSI_Model : NSObject
@property (nonatomic, assign) double SMA1_A;
@property (nonatomic, assign) double SMA1_B;
@property (nonatomic, assign) double SMA2_A;
@property (nonatomic, assign) double SMA2_B;
@property (nonatomic, assign) double SMA3_A;
@property (nonatomic, assign) double SMA3_B;


@property (nonatomic, assign) double RSI1;
@property (nonatomic, assign) double RSI2;
@property (nonatomic, assign) double RSI3;


@property (nonatomic, assign) double RSI1_Height;
@property (nonatomic, assign) double RSI2_Height;
@property (nonatomic, assign) double RSI3_Height;

@property (nonatomic, assign) double Width;
@end
