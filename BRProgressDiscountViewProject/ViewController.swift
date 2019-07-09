//
//  ViewController.swift
//  BRProgressDiscountViewProject
//
//  Created by git burning on 2019/7/2.
//  Copyright © 2019 git burning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mProgressView:BRProgressDiscountView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressView = BRProgressDiscountView(frame: CGRect(x: 20, y: 100, width: 300, height: 10))
        progressView.overProgressWidth = 0
        self.view.addSubview(progressView)
        mProgressView = progressView
        progressView.br_updateProgress(progress: 0.3)
        
        let toMutiworkSetting = UIImage(named: "toMutiworkSetting")
        let item_1000 = BRProgressDiscountView.br_getProgressItemModel()
        item_1000.name = "8折"
        item_1000.item_progress = 0.2
        item_1000.mSelectedImg = toMutiworkSetting
        
        let item_2000 = BRProgressDiscountView.br_getProgressItemModel()
        item_2000.name = "7折"
        item_2000.item_progress = 0.9
        item_2000.mSelectedImg = toMutiworkSetting
        
        item_1000.text_config?.text_color = UIColor.white
        item_2000.text_config?.text_color = UIColor.white

        progressView.br_updateListData(list: [item_1000,item_2000])
        
//        self.br_addProgress()
//        self.br_addOneProgress()
//        self.br_addOverProgress()
        
        let slider = UISlider(frame: CGRect(x: 20, y: 200, width: 300, height: 20))
        self.view.addSubview(slider)
        slider.value = 0.3
        slider.addTarget(self, action: #selector(br_slider(tap:)), for: .valueChanged)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func br_addProgress() {
        let progressView = BRProgressDiscountView(frame: CGRect(x: 20, y: 300, width: 300, height: 10))
        progressView.overProgressWidth = 0
        self.view.addSubview(progressView)
        progressView.br_updateProgress(progress: 0.99)
        
        let toMutiworkSetting = UIImage(named: "toMutiworkSetting")
        let item_1000 = BRProgressDiscountView.br_getProgressItemModel()
        item_1000.name = "8折"
        item_1000.item_progress = 0
        item_1000.mSelectedImg = toMutiworkSetting
        
        let item_2000 = BRProgressDiscountView.br_getProgressItemModel()
        item_2000.name = "7折"
        item_2000.item_progress = 1
        item_2000.mSelectedImg = toMutiworkSetting
        
        item_1000.text_config?.text_color = UIColor.white
        item_2000.text_config?.text_color = UIColor.white
        
        progressView.br_updateListData(list: [item_1000,item_2000])
    }
    func br_addOneProgress() {
        let progressView = BRProgressDiscountView(frame: CGRect(x: 20, y: 400, width: 300, height: 10))
        progressView.overProgressWidth = 0
        self.view.addSubview(progressView)
        progressView.br_updateProgress(progress: 0.5)
        
        let toMutiworkSetting = UIImage(named: "toMutiworkSetting")
        let item_1000 = BRProgressDiscountView.br_getProgressItemModel()
        item_1000.name = "8折"
        item_1000.item_progress = 0
        item_1000.mSelectedImg = toMutiworkSetting
        
        let item_2000 = BRProgressDiscountView.br_getProgressItemModel()
        item_2000.name = "7折"
        item_2000.item_progress = 1
        item_2000.mSelectedImg = toMutiworkSetting
        
        item_1000.text_config?.text_color = UIColor.white
        item_2000.text_config?.text_color = UIColor.white
        
        progressView.br_updateListData(list: [item_2000])
    }

    func br_addOverProgress() {
        let progressView = BRProgressDiscountView(frame: CGRect(x: 20, y: 500, width: 300, height: 10))
        progressView.overProgressWidth = 50
        self.view.addSubview(progressView)
       // mProgressView = progressView
        progressView.br_updateProgress(progress: 1)
        
        let toMutiworkSetting = UIImage(named: "toMutiworkSetting")
        let item_1000 = BRProgressDiscountView.br_getProgressItemModel()
        item_1000.name = "8折"
        item_1000.item_progress = 0.2
        item_1000.mSelectedImg = toMutiworkSetting
        
        let item_2000 = BRProgressDiscountView.br_getProgressItemModel()
        item_2000.name = "7折"
        item_2000.item_progress = 0.9
        item_2000.mSelectedImg = toMutiworkSetting
        
        item_1000.text_config?.text_color = UIColor.white
        item_2000.text_config?.text_color = UIColor.white
        
        progressView.br_updateListData(list: [item_1000,item_2000])
        
    }

   @objc  func br_slider(tap:UISlider) {
       mProgressView?.br_updateProgress(progress: CGFloat(tap.value))
    }
   
}

