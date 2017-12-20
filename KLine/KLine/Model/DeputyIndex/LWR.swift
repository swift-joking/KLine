//
//  LWR.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 威廉指标(LWR)是摆动指标中变化最快的指标之一，它的使用方法可以参照KD线指标的方法使用，但最好是使用它在顶部背离或低部背离所表达的技术含义，将威廉指标(LWR)背离所表达的技术含义与均线指标相结合、相验证进行使用，效果会更好一些。
 
 */

extension DeputyIndex {
    struct LWR {
        var lwr1 : Tuple = (0,0)
        var lwr2 : Tuple = (0,0)

        var width : Double = 0
        
    }
}
