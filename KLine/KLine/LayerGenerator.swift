//
//  LayerConfiguration.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/19.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

// MARK:- Line Draw protocol
protocol LineRepresentable:PathRepresentable {
    
    func drawBackgroundLine(to view:UIView ,direction:Direction2, color:UIColor,lineWidth:CGFloat,count:Int)
    func drawLine(points:(start:CGPoint,end:CGPoint), color:CGColor, width:CGFloat) -> CAShapeLayer

}

extension LineRepresentable {
 
    func drawLine(points:(start:CGPoint,end:CGPoint), color:CGColor, width:CGFloat) -> CAShapeLayer{
        
       return drawPath(points: (points.start,[points.end]), strokeColor : color, fillColor: UIColor.clear.cgColor , width: width)
    }
    
    func drawBackgroundLine(to view:UIView,direction:Direction2, color:UIColor,lineWidth:CGFloat,count:Int){
        
        let width = view.frame.width
        let height = view.frame.height
        
        var points = [(CGPoint,CGPoint)]()
        switch direction {
        case .horizontal:
     
            for i in 0..<count + 1 {
                let start = CGPoint(x: 0, y: height / CGFloat(count)  * CGFloat(i))
                let end = CGPoint(x: width, y: start.y)
                points.append((start,end))
            }
            
        case .vertical:
            
            for i in 0..<count + 1{
                let start = CGPoint(x: width / CGFloat(count)  * CGFloat(i), y:0 )
                let end = CGPoint(x: start.x, y: height)
                points.append((start,end))
            }
        }
        
        for path in points {
            let line =  drawLine(points: path, color : color.cgColor , width: lineWidth)
            view.layer.addSublayer(line)
        }
        
    }
}

extension LineRepresentable where Self:UIView{
    
    func drawBackgroundLine(direction:Direction2, color:UIColor , lineWidth:CGFloat , count:Int){
        drawBackgroundLine(to: self, direction: direction, color: color, lineWidth: lineWidth, count: count)
    }

}




//// MARK:- Draw Graph
//protocol GraphRepresentable : PathRepresentable{
//
//}

// MARK:- Basic Path Draw Protocol
protocol PathRepresentable {
    
    func drawPath(points:(start:CGPoint,others:[CGPoint]),strokeColor:CGColor , fillColor:CGColor, width:CGFloat) -> CAShapeLayer
    
    
    func createShapeLayer(color:(stroke:CGColor,fill:CGColor) , line:(cap:String,join:String)) -> CAShapeLayer

    func createPath(width:CGFloat,line:(cap:CGLineCap,join:CGLineJoin)) -> UIBezierPath

}

extension PathRepresentable {

    func drawPath(points:(start:CGPoint,others:[CGPoint]), strokeColor:CGColor , fillColor:CGColor , width:CGFloat) -> CAShapeLayer{
        
        let pathLayer = createShapeLayer(color: (strokeColor,fillColor))
        
        let path = createPath(width: width)
        path.move(to: points.start)
        for point in points.others.enumerated() {
            path.addLine(to:point.element)
        }
        pathLayer.path = path.cgPath
        
        return pathLayer
        
    }
    
    
    func createShapeLayer(color:(stroke:CGColor,fill:CGColor) , line:(cap:String,join:String) = (kCALineCapRound,kCALineJoinBevel)) -> CAShapeLayer{
        
        let pathLayer = CAShapeLayer()
        pathLayer.lineCap = line.cap
        pathLayer.lineJoin = line.join
        pathLayer.strokeColor = color.stroke
        pathLayer.fillColor = color.fill
        
        return pathLayer
    }
    
    func createPath(width:CGFloat,line:(cap:CGLineCap,join:CGLineJoin) = (.round,.round)) -> UIBezierPath{
        
        let path = UIBezierPath()
        path.lineWidth = width
        path.lineCapStyle = line.cap
        path.lineJoinStyle = line.join

        return path
    }
}


