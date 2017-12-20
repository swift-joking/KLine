//
//  DKBY.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation

/*
 多空博弈指标 DKBY
 
 当“多方”线向上与“空方”线“金叉”时为买点。当“多方”线向下与“空方”线“死叉”时为卖点。
 */

extension DeputyIndex {
    struct DKBY {
        
        var sma : Double = 0
        
        var sell : Tuple = (0,0)
        var buy : Tuple = (0,0)
        var ene1 : Tuple = (0,0)
        var ene2 : Tuple = (0,0)

        var width : Double = 0
                
    }
}
