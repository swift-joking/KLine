//
//  BOLL.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 布林线（Boll）指标是通过计算股价的“标准差”，再求股价的“信赖区间”。该指标在图形上画出三条线，其中上下两条线可以分别看成是股价的压力线和支撑线，而在两条线之间还有一条股价平均线，布林线指标的参数最好设为20。一般来说，股价会运行在压力线和支撑线所形成的通道中。
 */

extension MainIndex {
    struct BOLL {
        var mid : Tuple = (0,0)
        var upper : Tuple = (0,0)
        var lower : Tuple = (0,0)
    
        
        
        
    }
}
