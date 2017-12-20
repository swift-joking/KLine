//
//  RSI.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 RSI是Relative Strength Index的缩写。
 相对强弱指数RSI是根据一定时期内上涨点数和涨跌点数之和的比率制作出的一种技术曲线。能够反映出市场在一定时期内的景气程度。由威尔斯.威尔德（Welles Wilder)最早应用于期货买卖，后来人们发现在众多的图表技术分析中，强弱指标的理论和实践极其适合于股票市场的短线投资，于是被用于股票升跌的测量和分析中。该分析指标的设计是以三条线来反映价格走势的强弱，这种图形可以为投资者提供操作依据，非常适合做短线差价操作。
 
 RSI:= SMA(MAX(Close-LastClose,0),N,1)/SMA(ABS(Close-LastClose),N,1)*100
 */

extension DeputyIndex {
    struct RSI {
     
        var sma1 : (a:Double,b:Double) = (0,0)
        var sma2 : (a:Double,b:Double) = (0,0)
        var sma3 : (a:Double,b:Double) = (0,0)

        var rsi1 : Tuple = (0,0)
        var rsi2 : Tuple = (0,0)
        var rsi3 : Tuple = (0,0)

        var width : Double = 0
        
    }
}
