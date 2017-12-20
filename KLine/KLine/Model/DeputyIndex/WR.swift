//
//  WR.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 W%R是威廉指标（Williams %R）利用摆动点来量度股市的超买卖现象，可以预测循环期内的高点或低点，从而提出有效率的投资讯号，%R=100－（C－Ln）/（Hn-Ln）×100。
 其中：C为当日收市价，Ln为N日内最低价，Hn为N日内最高价，公式中N日为选设参数，一般设为14日或20日。
 */

extension DeputyIndex {
    struct WR {
        var wr : Tuple = (0,0)
        var width : Double = 0
    }
}
