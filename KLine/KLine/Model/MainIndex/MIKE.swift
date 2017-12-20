//
//  MIKE.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 MIKE指标又叫麦克指标，其英文全称是“Mike Base”,是一种专门研究股价各种压力和支撑的中长期技术分析工具。
 */

extension MainIndex {
    struct MIKE {
        
        var wr : Tuple = (0,0)
        var mr : Tuple = (0,0)
        var ws : Tuple = (0,0)
        var ms : Tuple = (0,0)
        var ss : Tuple = (0,0)
        
        var width : Double = 0
        
    }
}
