//
//  ViewController.swift
//  AutoLabel
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 LiYou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var labelsView: AutoLabelsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = LayerImage.image(with: self.view)
        self.view.addSubview(imageView)
        
        
        labelsView = AutoLabelsView()
        labelsView.frame = CGRect(x: 25, y: 100, width: kScreenWidth - 50, height: self.view.bounds.height - 100)
        labelsView.reloadData(["装修", "看房", "金融", "楼市政策", "数据权威", "地铁房", "学区房"],
                              baseSet: (spaceX: 15, spaceY: 25, margin: 0, width: kScreenWidth - 50, height: 32, innerMargin: 10 , type: HandlerType.startZore),
                              interfaceSet: (font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black, backGroundColor: UIColor.white, cornerRadius: 5, borderColor: UIColor.black))
        self.view.addSubview(labelsView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

