//
//  KLine.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/11.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

public class TimeSharingView : UIView , KLineViewRequired{
    
    public weak var dataSource:KLineDataSource!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async {
            self.setup()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("can't awake from coder file")
    }
    
    public var type : KType {return currentType}
    
    private let currentType : KType = .timeSharing

    private var models : [KLineModel]?
    private var contentView : UIView!
    private var edgeLabel:(left:EdgeLabel,right:EdgeLabel) = ((7,6),(7,2))
    private var timeSharings : [TimeSharing]?
    
    private var cursor:(horizontal:CAShapeLayer?,vertical:CAShapeLayer?)
}

// MARK:- Initial
extension TimeSharingView {
    
    private func setup(){
        
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(subview)
        contentView = subview
        
        dataSource.prefetch(target: self)
        
        switch type {
        case .timeSharing:
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
            longPress.minimumPressDuration = 0.3
            addGestureRecognizer(longPress)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(taped))
            addGestureRecognizer(tap)
            
        default:
         print("")
        }
    }
    
}

// MARK:- Open Configuration
extension TimeSharingView : LineRepresentable {

    
    /// configure Background line
    ///
    /// - Parameters:
    ///   - hCount: horizontal line count
    ///   - vCount: vertical line count
    ///   - width: line width
    ///   - color: line color
    public func configBackgroundLine(horizontal hCount:Int = 5 , vertical vCount:Int = 3 , width:CGFloat = 1.0 , color:UIColor = Color.backgroundLine)  {
        
        drawBackgroundLine(direction: .horizontal, color: color, lineWidth: width, count: hCount)
        drawBackgroundLine(direction: .vertical , color: color, lineWidth: width, count: vCount)

    }
    
    
    /// configure  edge label
    ///
    /// - Parameters:
    ///   - left: left edge label
    ///   - right: right edge label
    public func configEdgeLabel(left:EdgeLabel,right:EdgeLabel){
        edgeLabel.left = left
        edgeLabel.right = right
    }
    
}

// MARK:- Render
extension TimeSharingView:ListLabelRepresentable {
    
    private func draw() {
        
        // remove subviews and create new one
        contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        contentView.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        
        
        let models = self.models!

        let result = Helper.TimeShare.generate(with: models, viewSize: contentView.frame.size)
        timeSharings = result.timeSharings
    
        // draw closePrice graph
        let closePoints = Helper.TimeShare.closePriceGraph(with: result.timeSharings, viewSize: contentView.frame.size)
        drawIndexLineChart(superLayer: contentView.layer, points: closePoints, lineColor: Color.timeSharingLine.cgColor, fillColor: Color.timeSharingFill.cgColor)
        
        
        // draw MA line
        let maPoints = Helper.TimeShare.maLine(with: result.timeSharings)
        drawIndexLineChart(superLayer: contentView.layer, points: maPoints, lineColor: Color.timeSharingMALine.cgColor)

        
        // create priceLabel
        let priceLabels = generatePriceLabel(label: edgeLabel.left, viewSize: contentView.frame.size, limit: result.limit)
        priceLabels.forEach { (label) in
            contentView.addSubview(label)
        }
        
        // create devLabel
        let devLabels = generateDevLabel(label: edgeLabel.right, viewSize: contentView.frame.size, limit: result.limit)
        devLabels.forEach{contentView.addSubview($0)}

        
        
//        let viewHeight = Double(contentView.frame.height)
//        let viewWidth =  Double(contentView.frame.width)
//        // create timeLabel
//        for i in 0..<5 {
//            let timeLabel = UILabel(frame: CGRect(x: 0, y: viewHeight, width: 50, height: 30))
//            timeLabel.font = UIFont.systemFont(ofSize: 20 * (UIScreen.main.bounds.width / 750))
//
//            if i != 0 {
//                var frame = timeLabel.frame
//                if i == 4 {
//
//                    frame.origin.x = CGFloat(viewWidth)  - timeLabel.frame.width
//                    timeLabel.textAlignment = .right
//
//                }else {
//
//                    frame.origin.x = CGFloat(viewWidth) * CGFloat(i) / 4 - 25
//                    frame.origin.y = CGFloat(viewHeight)
//                    timeLabel.textAlignment = .center
//                }
//                timeLabel.frame = frame
//            }
//
//            timeLabel.text = "--:--"
//            contentView.addSubview(timeLabel)
//
//        }
    }

    
    private func drawIndexLineChart(superLayer:CALayer,points:[CGPoint],lineColor:CGColor,fillColor:CGColor = UIColor.clear.cgColor){
        
        var ps : (start:CGPoint,others:[CGPoint]) = (.zero,[CGPoint]())
        
        for (offset , point) in points.enumerated() {
            if offset == 0 {
                ps.start = point
            }else {
                ps.others.append(point)
            }
        }
        
        let layer = drawPath(points: ps, strokeColor: lineColor, fillColor: fillColor, width: 1.0)
        superLayer.addSublayer(layer)

    }
    
}

// MARK:- Gesture
extension TimeSharingView {
    
    
    /// taped
    ///
    /// - Parameter gesture: tap gesture
    @objc private func taped(_ gesture:UITapGestureRecognizer){
        let  point = gesture.location(in: self)
        if point.x >= 0 && point.y >= 0 {
            
            guard let _ = cursor.horizontal else {return}
            
            cursor.horizontal?.removeFromSuperlayer()
            cursor.vertical?.removeFromSuperlayer()
        }
    }
    
    
    /// LongPress
    ///
    /// - Parameter gesture: longpress
    @objc private func longPressed(_ gesture:UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: self)
        let relativePoint = convert(point, to: contentView)
        let doublePoint : (x:Double,y:Double) = (Double(relativePoint.x),Double(relativePoint.y))
        
        guard doublePoint.x >= 0 && doublePoint.y >= 0 else{ return}

        let lastSharing = timeSharings?.last
        guard let sharing = lastSharing else{return}

        var cursorPoint = doublePoint
        if doublePoint.x > sharing.width{
            
            cursorPoint.x = sharing.width
            cursorPoint.y = sharing.closePrice.height
        }else{
            
            let num = 12 * 24 * doublePoint.x / Double(contentView.frame.width - 2)
            let sharing = timeSharings![Int(num)]
            
            cursorPoint.x = sharing.width
            cursorPoint.y = sharing.closePrice.height
        }
        
        updateCursor(with: cursorPoint)
        
    }
    
    
    
    /// update Cursor
    ///
    /// - Parameter point: long press point
    private func updateCursor(with point:(x:Double,y:Double)){
        
        
        let cgPoint = CGPoint(x: point.x, y: point.y)
        
        cursor.horizontal?.removeFromSuperlayer()
        cursor.vertical?.removeFromSuperlayer()
        
        // 竖线
        let vLayer = createShapeLayer(color: (UIColor.cyan.cgColor,UIColor.white.cgColor))
        let vPath = createPath(width: 1.0)
        vPath.move(to: CGPoint(x: cgPoint.x, y: 0))
        vPath.addLine(to: CGPoint(x: cgPoint.x , y: contentView.frame.height))
        vLayer.path = vPath.cgPath
        
        layer.addSublayer(vLayer)
        cursor.vertical = vLayer
        
        // 横线
        if cgPoint.y < contentView.frame.height && cgPoint.y > 0{
            
            let hLayer = createShapeLayer(color: (UIColor.cyan.cgColor,UIColor.white.cgColor))
            let hPath = createPath(width: 1.0)
            
            hPath.move(to: CGPoint(x:0,y:cgPoint.y))
            hPath.addLine(to: CGPoint(x:contentView.frame.width,y:cgPoint.y))
            
            hLayer.path = hPath.cgPath
            layer.addSublayer(hLayer)
            cursor.horizontal = hLayer
        }
    }

}

// MARK:- Open API
extension TimeSharingView {
    
    public func reloadData(){
        
        models = dataSource.models(in: self)
        draw()
        
    }
    
    public func reloadOne(){
        
        let model = dataSource.update(in: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let newDate = dateFormatter.date(from: model.priceTime)
        
        guard let models = self.models else {
            return
        }
        let latter2 = models[models.count - 2]
        
        let latter2Date = dateFormatter.date(from: latter2.priceTime)
        
        let cmps = Calendar.current.dateComponents(
            [Calendar.Component.year,
             Calendar.Component.month,
             Calendar.Component.day,
             Calendar.Component.hour,
             Calendar.Component.minute], from: newDate!, to: latter2Date!)
        
        if let day = cmps.day , let hour = cmps.hour ,let minute = cmps.minute ,
            day == 0 , hour == 0 , minute < 0{
            
            let lastModel = models.last!
            lastModel.closePrice = model.closePrice
            
            lastModel.highPrice = max(lastModel.closePrice, lastModel.highPrice)
            lastModel.lowPrice = min(lastModel.closePrice, lastModel.highPrice)
            lastModel.priceTime = model.priceTime
        }else{
            
            self.models?.append(model)
            
        }
        
        draw()
    }

}
