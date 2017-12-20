//
//  BIAS.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 乖离，指市场指数或收盘价与某条移动平均价格之间的差距。
 乖离率(BIAS)，又称偏离率，简称Y值，是通过计算市场指数或收盘价与某条移动平均线之间的差距百分比，以反映一定时期内价格与其MA偏离程度的指标，从而得出价格在剧烈波动时因偏离移动平均趋势而造成回档或反弹的可能性，以及价格在正常波动范围内移动而形成继续原有势的可信度。
 
 */

extension DeputyIndex {
    struct BIAS {
        
        var bias1 : Tuple = (0,0)
        var bias2 : Tuple = (0,0)
        var bias3 : Tuple = (0,0)

        var width : Double = 0
    }
}
