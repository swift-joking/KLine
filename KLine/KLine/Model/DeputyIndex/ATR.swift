//
//  ATR.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 ATR又称 Average true range平均真实波动范围，简称ATR指标，是由J.Welles Wilder 发明的，ATR指标主要是用来衡量市场波动的强烈度，即为了显示市场变化率的指标。
 
 首先提出的，这一指标主要用来衡量价格的波动。因此，这一技术指标并不能直接反映价格走向及其趋势稳定性，而只是表明价格波动的程度。
 
 这一指标对于长期持续边幅移动的时段是非常典型的，这一情况通常发生在市场的顶部，或者是在价格巩固期间。根据这个指标来进行预测的原则可以表达为：该指标价值越高，趋势改变的可能性就越高；该指标的价值越低，趋势的移动性就越弱。
 */

extension DeputyIndex {
    struct ATR {
        
        var tr : Tuple = (0,0)
        var atr : Tuple = (0,0)
        var width : Double = 0
        
    }
}
