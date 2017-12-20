//
//  Provider.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/11.
//  Copyright © 2017年 Eric. All rights reserved.
//

import Foundation


class Provider {
    
    var models = [KType:[KLineModel]]()
    
    weak var view : KLineViewRequired?
    
    var timer : Timer?

}


extension Provider  {
    
    private func asyncLoadData(for lineView:KLineViewRequired){
        
        view = lineView
        
        if let models = models[lineView.type] , !models.isEmpty {
            return
        }
        
        DispatchQueue.global().async {
            
            var path:String!
            switch lineView.type {
            case .timeSharing:
                path = Bundle.main.path(forResource: "TimeSharing", ofType: "plist")
            case .oneMinutes:
                path = Bundle.main.path(forResource: "1minute", ofType: "plist")

            case .fiveMinutes:
                path = Bundle.main.path(forResource: "5minutes", ofType: "plist")

            case .fifteenMinutes:
                path = Bundle.main.path(forResource: "15minutes", ofType: "plist")

            case .thirtyMinutes:
                path = Bundle.main.path(forResource: "30minutes", ofType: "plist")

            case .sixtyMinutes:
                path = Bundle.main.path(forResource: "60minutes", ofType: "plist")
                
            }
            
            if let dictArray = NSArray(contentsOfFile: path) as? [[String:Any]] {
                
                var models = [KLineModel]()
                for dict in dictArray {
                    let model = KLineModel(type: lineView.type)
                    model.setValuesForKeys(dict)
                    models.append(model)
                }
                
                self.models[lineView.type] = models
                
                DispatchQueue.main.async {
                    lineView.reloadData()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateData), userInfo: nil, repeats: true)
                    
                }
                
                
            }
            
        }
    }
}


extension Provider {
    
    @objc private func updateData(){
        
        view?.reloadOne()
    }

}

extension Provider {
    
    func updateModel(type: KType) -> KLineModel {
        
        var path:String!
        switch type {
        case .timeSharing:
            path = Bundle.main.path(forResource: "TimeSharing_Update", ofType: "plist")
        case .oneMinutes:
            path = Bundle.main.path(forResource: "1minute_Update", ofType: "plist")
            
        case .fiveMinutes:
            path = Bundle.main.path(forResource: "5minutes_Update", ofType: "plist")
            
        case .fifteenMinutes:
            path = Bundle.main.path(forResource: "15minutes_Update", ofType: "plist")
            
        case .thirtyMinutes:
            path = Bundle.main.path(forResource: "30minutes_Update", ofType: "plist")
            
        case .sixtyMinutes:
            path = Bundle.main.path(forResource: "60minutes_Update", ofType: "plist")
            
        }
        
        
        let dictArray = NSArray(contentsOfFile: path) as! [[String:Any]]
        
        var models = [KLineModel]()
        for dict in dictArray {
            let model = KLineModel(type: type)
            model.setValuesForKeys(dict)
            models.append(model)
        }
        
        let index = Int(arc4random_uniform(UInt32(models.count - 1)))
        
        return models[index]
    }
   
}

extension Provider : KLineDataSource{
 
        
    func prefetch(target lineView: KLineViewRequired) {
        asyncLoadData(for: lineView)
    }
    func models(in lineView:KLineViewRequired) ->[KLineModel]{
        return models[lineView.type]  ?? [KLineModel]()
    }
    
    func update(in lineView:KLineViewRequired) -> KLineModel {
        
        return updateModel(type: lineView.type)
    }

}
