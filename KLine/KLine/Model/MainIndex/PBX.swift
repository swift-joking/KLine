//
//  PBX.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 瀑布线(PBX)是欧美国家九十年代初，广泛应用于金融领域中的判断股价运行趋势的主要分析方法，因此经由汇聚向下发散时呈瀑布状而得名。属于传统大势价格趋势线，它的真正名称叫做非线性加权移动平均线，是由六条非线性加权移动平均线组合而成，每条平均线分别代表着不同时间周期的股价成本状况，方便进行对比分析。
 
 瀑布线是一种中线指标，一般用来研究股价的中期走势，与普通均线系统相比较，它具有反应速度快，给出的买卖点明确的特点，并能过滤掉盘中主力震仓洗盘或下跌行情中的小幅反弹，可直观有效地把握住大盘和个股的运动趋势，是目前判断大势和个股股价运行趋势颇为有效的均线系统。
 */

extension MainIndex {
    struct PBX {
        
        
        var ema1 : Double = 0
        var ema2 : Double = 0
        var ema3 : Double = 0
        var ema4 : Double = 0
        var ema5 : Double = 0
        var ema6 : Double = 0

        var pbx1 : Tuple = (0,0)
        var pbx2 : Tuple = (0,0)
        var pbx3 : Tuple = (0,0)
        var pbx4 : Tuple = (0,0)
        var pbx5 : Tuple = (0,0)
        var pbx6 : Tuple = (0,0)

        var width : Double = 0
    }
}
