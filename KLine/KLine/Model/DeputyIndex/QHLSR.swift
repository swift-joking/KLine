//
//  QHLSR.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


/*
 阻力指标　QHLSR 　判断原则是：当持股处盈利状态，趋势（无论中短期）出现逆转，原则是首先考虑减仓操作。如果持股处于亏损被套的（有的是追高买入造成的，应该写检讨记录在案警示），中期趋势出现逆转时，仍然是首先应该考虑减仓操作。明显上升通道以及箱型整理的持股，在上轨处作卖出操作。在通道下轨或箱体下轨处的回补必须非常小心。
 */

extension DeputyIndex {
    struct QHLSR {
        var qhl5 : Tuple = (0,0)
        var qhl10 : Tuple = (0,0)

        var width : Double = 0
        
    }
}
