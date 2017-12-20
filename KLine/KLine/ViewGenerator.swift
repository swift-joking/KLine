//
//  ViewGenerator.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/20.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

protocol ListLabelRepresentable {
    
    func generatePriceLabel(label:(count:Int,digits:Int),viewSize:CGSize,limit:(max:Double,min:Double))  ->[UILabel]
    func generateDevLabel(label:(count:Int,digits:Int),viewSize:CGSize,limit:(max:Double,min:Double))  ->[UILabel]
}

extension ListLabelRepresentable {
    
    func generatePriceLabel(label:(count:Int,digits:Int),viewSize:CGSize,limit:(max:Double,min:Double))  ->[UILabel]{
        
        let viewHeight = viewSize.height
        
        var priceLabels = [UILabel]()
        
        for i in 0..<label.count {
            let priceLabel = UILabel()
            priceLabel.font = UIFont.systemFont(ofSize: 13)
            if i != 0 {
                var frame = priceLabel.frame
                frame.origin.y = CGFloat(viewHeight) * CGFloat(i) / CGFloat(label.count) - priceLabel.frame.height
                priceLabel.frame = frame
            }
            
            let priceValue = limit.max - (limit.max - limit.min) * Double(i) / Double(label.count)
            priceLabel.text = String(format:"%.\(label.digits)f",priceValue)
            
            priceLabel.sizeToFit()
            
            priceLabels.append(priceLabel)
        }
        
        return priceLabels
    }
    
    func generateDevLabel(label:(count:Int,digits:Int),viewSize:CGSize,limit:(max:Double,min:Double))  ->[UILabel] {
        
        let viewWidth = viewSize.width
        let viewHeight = viewSize.height

        var devLabels = [UILabel]()

        for i in 0..<label.count {
            let devLabel = UILabel()
            devLabel.frame.origin.x = viewWidth
            devLabel.font = UIFont.systemFont(ofSize: 13 )
            devLabel.textAlignment = .right
            if i != 0 {
                var frame = devLabel.frame
                frame.origin.y = CGFloat(viewHeight) * CGFloat(i) / CGFloat(label.count) - devLabel.frame.height
                devLabel.frame = frame
            }
            
            let dev = (limit.max - limit.min) * ( 0.5 - Double(i) / Double(label.count))
            devLabel.text = String(format:"%.\(label.digits)f",dev)
            
            devLabel.sizeToFit()
            devLabel.frame.origin.x -= devLabel.frame.width
            
            devLabels.append(devLabel)
        }
        
        return devLabels
    }
}
