//
//  ARBR.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 AR指标是反映市场当前情况下多空双方力量发展对比的结果。它是以当日的开盘价为基点。与当日最高价相比较，依固定公式计算出来的强弱指标。
 */
extension DeputyIndex {
    struct ARBR {
        var n : Int = 0
        var ar : Tuple = (0,0)
        var br : Tuple = (0,0)
        var width : Double = 0
    }
}
