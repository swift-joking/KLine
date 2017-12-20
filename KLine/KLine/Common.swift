//
//  Common.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/12.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

public enum KType: String {
    
    case timeSharing = "timeSharing"
    case oneMinutes = "oneMinutes"
    case fiveMinutes = "fiveMinutes"
    case fifteenMinutes = "fifteenMinutes"
    case thirtyMinutes = "thirtyMinutes"
    case sixtyMinutes = "sixtyMinutes"
}


public enum Direction2 {
    case vertical
    case horizontal
}

public enum Direction4{
    case up
    case down
    case left
    case right 
}


public enum Color {
    
    public static let backgroundLine = UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
    
    public static let timeSharingLine = UIColor(red: 117/255.0, green: 142/255.0, blue: 210/255, alpha: 1.0)
    public static let timeSharingFill = UIColor(red: 221/255.0, green: 229/255.0, blue: 251/255, alpha: 1.0)
    public static let timeSharingMALine = UIColor(red: 230/255.0, green: 218/255.0, blue: 73/255.0, alpha: 1.0)


    
    
}


typealias Tuple = (value:Double,height:Double)
public typealias EdgeLabel = (count:Int,digits:Int)

