//
//  Helper.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/19.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

struct Helper{}

// MARK:- TimeSharing
extension Helper {
    
    struct TimeShare {
        
        
        /// Generate TimeSharing Models
        ///
        /// - Parameters:
        ///   - models: ModelRequired
        ///   - viewSize: viewSize
        /// - Returns: TimeSharing Models and maxValue ,minValue
        static func generate(with models:[ModelRequired] , viewSize:CGSize) ->(timeSharings:[TimeSharing],limit:(max:Double,min:Double)){
            
            var timeSharings = [TimeSharing]()
            // caculate MA and closePrice
            for i in 0..<models.count {
                
                let model = models[i]
                
                let sharing = TimeSharing()
                
                if i == 0 {
                    sharing.ma.value = model.closePrice
                }else {
                    
                    var sum : Double = 0
                    for j in 0...i {
                        sum += models[j].closePrice
                    }
                    sum = sum / Double(i + 1)
                    sharing.ma.value = sum
                }
                
                sharing.closePrice.value = model.closePrice
                
                timeSharings.append(sharing)
                
            }
            
            // caculate Max Min Value
            let firstModel = models.first!
            let startValue = models.first!.closePrice
            var maxValue : Double = 0
            var minValue : Double = Double(MAXFLOAT)
            
            for sharing in timeSharings {
                let closePrice = sharing.closePrice.value
                maxValue = maxValue > closePrice ? maxValue : closePrice
                
                let ma = sharing.ma.value
                maxValue = maxValue > ma ? maxValue : ma
                
                minValue = minValue < closePrice ? minValue : closePrice
                minValue = minValue < ma ? minValue : ma
            }
            
            let max_dev = fabs(startValue - maxValue) > fabs(startValue - minValue) ? true : false
            
            if max_dev {
                minValue = firstModel.closePrice - fabs(startValue - maxValue)
            }else {
                maxValue = firstModel.closePrice + fabs(startValue - minValue)
            }
            
            
            
            // caculate height and width
            let maxHeight = Double(viewSize.height)
            let maxWidth = Double(viewSize.width)
            
            for i in 0..<timeSharings.count {
                
                let timeSharing = timeSharings[i]
                let model = models[i]
                
                timeSharing.closePrice.height = price2YAxis(price: model.closePrice, maxValue: maxValue, minValue: minValue, maxHeight: maxHeight)
                timeSharing.width = Double(i) * (maxWidth - 2.0) / 12.0 / 24.0 + 1.0
                timeSharing.ma.height = price2YAxis(price: timeSharing.ma.value, maxValue: maxValue, minValue: minValue, maxHeight: maxHeight)
            }
            
            return (timeSharings,(maxValue,minValue))
            
        }
        
        static func price2YAxis(price:Double,maxValue:Double,minValue: Double,maxHeight:Double) -> Double{
            var result : Double = 0
            if maxValue - minValue != 0 {
                result = (maxValue - price) * maxHeight / (maxValue - minValue)
            }else{
                result = maxHeight / 2
            }
            return result
        }
        
        
        
        
        /// Caculate close price graph points
        ///
        /// - Parameters:
        ///   - sharings: TimeSharing models
        ///   - viewSize: viewSize
        /// - Returns: graph points
        static func closePriceGraph(with sharings:[TimeSharing] , viewSize:CGSize) ->[CGPoint] {
            
            var closePoints = [CGPoint]()
            let viewHeight = Double(viewSize.height)
            let count = sharings.count
            
            for i in 0..<count {
                
                let sharing = sharings[i]
                
                let height = sharing.closePrice.height
                let width = sharing.width
                
                if i == 0 {
                    let point1 = CGPoint(x: width, y: viewHeight)
                    closePoints.append(point1)
                    let point2 = CGPoint(x: width, y: height)
                    closePoints.append(point2)
                    
                }else if i == count - 1 {
                    let point1 = CGPoint(x: width, y: height)
                    closePoints.append(point1)
                    let point2 = CGPoint(x: width, y: viewHeight)
                    closePoints.append(point2)
                    
                }else {
                    let point1 = CGPoint(x: width, y: height)
                    closePoints.append(point1)
                }
            }
            
            return closePoints
        }
        
        
        /// Caculate MA Line Graph Points
        ///
        /// - Parameter sharings: TimeSharing Models
        /// - Returns: MA Line Graph Points
        static func maLine(with sharings:[TimeSharing] ) -> [CGPoint]{
            
            var maPoints = [CGPoint]()
            for sharing in sharings {
                let height = sharing.ma.height
                let width = sharing.width
                let point = CGPoint(x: width, y: height)
                maPoints.append(point)
            }
            
            return maPoints
        }

    }
    
    
    
    
}
