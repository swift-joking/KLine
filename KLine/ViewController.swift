//
//  ViewController.swift
//  KLine
//
//  Created by 黄继平 on 2017/12/11.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let provider = Provider()


}


extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup(){
        
        let timeView = TimeSharingView(frame: CGRect(x: 10, y: 64 + 10, width: view.frame.width - 20, height: view.frame.height - 100))
        timeView.dataSource = provider
        timeView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.addSubview(timeView)
        
        timeView.configBackgroundLine()
        
                
    }
}
