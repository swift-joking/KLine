//
//  BBI.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 多空线(BBI)是一个统计性指标。它是将主动买、主动卖的成交按时间区间分别统计而形成的一个曲线。多空线有两条线，以交叉方式提示买入卖出。
 */
extension MainIndex {
    struct BBI {
        var value : Double = 0
        var height : Double = 0
        var width : Double = 0
    }
}
