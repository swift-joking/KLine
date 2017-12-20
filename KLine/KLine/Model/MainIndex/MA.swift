//
//  MA.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 移动平均线，Moving Average，简称MA，原本的意思是移动平均，由于我们将其制作成线形，所以一般称之为移动平均线，简称均线。它是将某一段时间的收盘价之和除以该周期。 比如日线MA5指5天内的收盘价除以5 。
 */


extension MainIndex {
    struct MA {
        
        var level1 : Tuple = (0,0)
        var level2 : Tuple = (0,0)
        var level3 : Tuple = (0,0)
        var level4 : Tuple = (0,0)
        var level5 : Tuple = (0,0)

        var width : Double = 0
        
        
        
        
        
    }
}
