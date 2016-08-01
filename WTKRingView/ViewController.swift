//
//  ViewController.swift
//  WTKRingView
//
//  Created by 王同科 on 16/7/28.
//  Copyright © 2016年 王同科. All rights reserved.
////
//
import UIKit

class ViewController: UIViewController {

    var ringView        : WTKRingView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ringView?.startTimer()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ringView?.endTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ringView = WTKRingView()
        ringView!.frame = CGRectMake(0, 0, ringView!.kWIDTH, ringView!.kWIDTH)
        
        self.view.addSubview(ringView!)
        
        let imageArray = ["1","2","3"]
        ringView!.refreshRingView(imageArray)
        
        ringView!.clickPage = {
            (tag) ->Void in
            print("\(tag)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

