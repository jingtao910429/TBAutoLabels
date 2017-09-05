//
//  RentHouseDetailLabelsView.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import UIKit

private struct Handler {
    static let labelSpace = CGFloat(10)
    static let labelMargin = CGFloat(20)
    static let labelHeight = CGFloat(20)
    static let totalWidth = kScreenWidth - Handler.labelMargin
    static let font = UIFont.systemFont(ofSize: 13)
}

class RentHouseDetailLabelsView: UIView {
    
    public var sources: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, sources: [String]) {
        self.init(frame: frame)
        self.sources = sources
        setInterface()
    }
    
    public func reloadData(_ obj: [String]) {
        self.sources = obj
        setInterface()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RentHouseDetailLabelsView {
    func setInterface() {
        
        if let sources = self.sources {
            
            guard sources.count != 0 else {
                return
            }
            
            var startX = CGFloat(0)
            var startY = CGFloat(10)
            var index = 0
            var foreIndex = 0
            for text in sources {
                let textWidth = text.widthWith(Handler.font, height: CGFloat(Handler.labelHeight)) + 5
                startX += textWidth
                startX += Handler.labelSpace
                if startX > Handler.totalWidth {
                    //补充视图，重新计算起始点
                    
                    addLabel(foreIndex: foreIndex, index: index, startX: (kScreenWidth - startX + Handler.labelSpace + textWidth)/2.0, startY: startY)
                    
                    foreIndex = index
                    
                    startX = textWidth + Handler.labelSpace
                    startY += (Handler.labelHeight + 10)
                }
                index += 1
            }
            
            guard index == sources.count else {
                return
            }
            
            addLabel(foreIndex: foreIndex, index: index, startX: (kScreenWidth - startX)/2.0, startY: startY)
        }
        
    }
    
    func addLabel(foreIndex: Int, index: Int, startX: CGFloat , startY: CGFloat) {
        
        if let sources = self.sources {
            
            var insertX = CGFloat(startX)
            
            for i in foreIndex..<index {
                print("index=\(i)")
                let content = sources[i]
                let contentWidth = content.widthWith(Handler.font, height: CGFloat(Handler.labelHeight)) + 5
                
                var contentLabel: UILabel?
                
                if let label = self.viewWithTag(i + 1) as? UILabel {
                    contentLabel = label
                    contentLabel?.frame = CGRect(x: insertX, y: startY, width: contentWidth, height: Handler.labelHeight)
                } else {
                    contentLabel = UILabel(frame: CGRect(x: insertX, y: startY, width: contentWidth, height: Handler.labelHeight))
                    self.addSubview(contentLabel!)
                }
                
                contentLabel?.tag = i + 1
                contentLabel?.text = content
                contentLabel?.font = Handler.font
                contentLabel?.textAlignment = .center
                contentLabel?.layer.borderWidth = 0.5
                contentLabel?.layer.borderColor = UIColor.init(hexString: "#C7C7C7")?.cgColor
                contentLabel?.textColor = UIColor(hexString: "#C7C7C7")
                insertX += contentWidth
                insertX += Handler.labelSpace
            }
        }
        
    }
    
}
