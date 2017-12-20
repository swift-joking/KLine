//
//  Protocol.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/11.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

typealias ModelProtocol = ModelRequired & ModelAdditional

public protocol KLineViewRequired : class{
    
    var type : KType {get}
    func reloadData()
    func reloadOne()
}

public protocol KLineDataSource: class {
    
    func prefetch(target lineView:KLineViewRequired)
    func models(in lineView:KLineViewRequired) ->[KLineModel]
    func update(in lineView:KLineViewRequired) -> KLineModel 

}

//public protocol KLineViewSource : class {

//    func lineView(_ lineView:KLineViewRequired , cellAt index:Int) ->LineCell

//}




////////////////////////////////////////////////////////////////////////////////
// Model
////////////////////////////////////////////////////////////////////////////////
public protocol ModelRequired {
    
    var type:KType {get set}
    
    var highPrice : Double{get set}
    var lowPrice : Double {get set}
    var openPrice : Double {get set}
    var closePrice : Double {get set}
    
    var volume : Double {get set}
    var priceTime : String {get set}
    
}

protocol ModelAdditional {

    var candle : Candle? {get set}
    
    // minute graph's main index
    var bbi : MainIndex.BBI? {get set}
    var boll : MainIndex.BOLL? {get set}
    var ma : MainIndex.MA? {get set}
    var mike : MainIndex.MIKE? {get set}
    var pbx : MainIndex.PBX? {get set}

    // minute graph's deputy index
    var arbr : DeputyIndex.ARBR? {get set}
    var atr : DeputyIndex.ATR? {get set}
    var bias : DeputyIndex.BIAS? {get set}
    var cci : DeputyIndex.CCI? {get set}
    var dkby : DeputyIndex.DKBY? {get set}
    var kd : DeputyIndex.KD? {get set}
    var kdj : DeputyIndex.KDJ? {get set}
    var lwr : DeputyIndex.LWR? {get set}
    var macd : DeputyIndex.MACD? {get set}
    var qhlsr : DeputyIndex.QHLSR? {get set}
    var rsi : DeputyIndex.RSI? {get set}
    var wr : DeputyIndex.WR? {get set}


}


