//
//  KLineModel.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/13.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


public class KLineModel: NSObject, ModelRequired , ModelAdditional{
    
    public var type:KType
    
    public var highPrice : Double = 0
    public var lowPrice : Double = 0
    public var openPrice : Double = 0
    public var closePrice : Double = 0
    
    public var volume : Double = 0
    public var priceTime : String = ""
    
    init(type:KType) {
        self.type = type
    }
    
    
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        for key in keyedValues.keys {
            switch key.lowercased() {
            case "highprice":
                highPrice = (keyedValues[key] as! NSNumber).doubleValue
            case "lowprice":
                lowPrice = (keyedValues[key] as! NSNumber).doubleValue
            case "openprice":
                openPrice = (keyedValues[key] as! NSNumber).doubleValue
            case "closeprice":
                closePrice = (keyedValues[key] as! NSNumber).doubleValue
            case "volume":
                volume = (keyedValues[key] as! NSNumber).doubleValue
            case "pricetime":
                priceTime = keyedValues[key] as! String
            default:
                break
            }
        }
    }
    
    // 
  
    var candle : Candle? = nil
    
    // minute graph's main index
    var bbi : MainIndex.BBI? = nil
    var boll : MainIndex.BOLL? = nil
    var ma : MainIndex.MA? = nil
    var mike : MainIndex.MIKE? = nil
    var pbx : MainIndex.PBX? = nil
    
    // minute graph's deputy index
    var arbr : DeputyIndex.ARBR? = nil
    var atr : DeputyIndex.ATR? = nil
    var bias : DeputyIndex.BIAS? = nil
    var cci : DeputyIndex.CCI? = nil
    var dkby : DeputyIndex.DKBY? = nil
    var kd : DeputyIndex.KD? = nil
    var kdj : DeputyIndex.KDJ? = nil
    var lwr : DeputyIndex.LWR? = nil
    var macd : DeputyIndex.MACD? = nil
    var qhlsr : DeputyIndex.QHLSR? = nil
    var rsi : DeputyIndex.RSI? = nil
    var wr : DeputyIndex.WR? = nil

}



