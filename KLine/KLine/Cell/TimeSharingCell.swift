//
//  LineView.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/12.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

public class TimeSharingCell:CAShapeLayer {
    let model : ModelRequired
    
    public init(model:ModelRequired) {
        self.model = model
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeSharingCell {
    
    func draw(in size:CGSize, container:CALayer)  {
        
        
        
        
        
    }
}
