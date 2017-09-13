//
//  AutoLabelsView.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import UIKit
import EZSwiftExtensions

public enum HandlerType {
    case seperate
    case startZore
}

private struct Handler {
    
    //Mark: 基本设置
    
    //分割类型
    static var handlerType: HandlerType = HandlerType.seperate
    //label间距
    static var spaceX = CGFloat(10)
    static var spaceY = CGFloat(10)
    //view左右间距
    static var labelMargin = CGFloat(20)
    //预设置view宽度
    static var preSetTotalWidth = kScreenWidth
    //label高度
    static var height = CGFloat(20)
    //view宽度
    static var totalWidth = preSetTotalWidth - 2 * Handler.labelMargin
    //需要特别定制item宽度
    static var innerMargin = CGFloat(2.5)
    
    static func setBase(_ baseSet: (
        spaceX: CGFloat,
        spaceY: CGFloat,
        margin: CGFloat,
        width: CGFloat,
        height: CGFloat,
        innerMargin: CGFloat,
        type: HandlerType)) {
        
        Handler.spaceX = baseSet.spaceX
        Handler.spaceY = baseSet.spaceY
        Handler.labelMargin = baseSet.margin
        Handler.preSetTotalWidth = baseSet.width
        Handler.height = baseSet.height
        Handler.innerMargin = baseSet.innerMargin
        Handler.handlerType = baseSet.type
        
    }
    
    
    //MARK: UI设置
    //字体大小
    static var font = UIFont.systemFont(ofSize: 13)
    //字体颜色
    static var textColor = UIColor(hexString: "#C7C7C7")
    //label背景颜色
    static var backGroundColor = UIColor.white
    //border颜色
    static var borderColor = UIColor(hexString: "#C7C7C7")?.cgColor
    
    static func setInterface(_ interfaceSet: (
        font: UIFont,
        textColor: UIColor,
        backGroundColor: UIColor,
        borderColor: UIColor)) {
        
        Handler.font = interfaceSet.font
        Handler.textColor = interfaceSet.textColor
        Handler.backGroundColor = interfaceSet.backGroundColor
        Handler.borderColor = interfaceSet.borderColor.cgColor
        
    }
    
}

class AutoLabelsView: UIView {
    
    public var sources: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, sources: [String]) {
        self.init(frame: frame)
        reloadData(sources)
    }
    
    //自定义视图
    public func reloadData(_ sources: [String],
                           baseSet: (spaceX: CGFloat, spaceY: CGFloat, margin: CGFloat, width: CGFloat, height: CGFloat, innerMargin: CGFloat, type: HandlerType),
                           interfaceSet: (font: UIFont, textColor: UIColor, backGroundColor: UIColor, borderColor: UIColor)) {
        Handler.setBase(baseSet)
        Handler.setInterface(interfaceSet)
        reloadData(sources)
    }
    
    public func reloadData(_ sources: [String]) {
        self.sources = sources
        setInterface()
    }
    
    public func reset() {
        
        Handler.handlerType = HandlerType.seperate
        Handler.spaceX = CGFloat(10)
        Handler.spaceY = CGFloat(10)
        Handler.labelMargin = CGFloat(20)
        Handler.preSetTotalWidth = kScreenWidth
        Handler.height = CGFloat(20)
        Handler.totalWidth = Handler.preSetTotalWidth - 2 * Handler.labelMargin
        
        Handler.font = UIFont.systemFont(ofSize: 13)
        Handler.textColor = UIColor(hexString: "#C7C7C7")
        Handler.backGroundColor = UIColor.white
        Handler.borderColor = UIColor(hexString: "#C7C7C7")?.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AutoLabelsView {
    func setInterface() {
        
        if let sources = self.sources {
            
            guard sources.count != 0 else {
                return
            }
            
            var startX = CGFloat(0) // 起始点
            var startY = CGFloat(Handler.spaceY)
            var index = 0 //记录当前索引
            var foreIndex = 0 //记录前索引
            for text in sources {
                let textWidth = text.widthWith(Handler.font, height: CGFloat(Handler.height)) + 2 * Handler.innerMargin
                startX += textWidth
                if index != sources.count - 1 {
                    startX += Handler.spaceX
                }
                if startX > Handler.totalWidth {
                    
                    let suppleSpace = textWidth + (index == sources.count - 1 ? 0 : Handler.spaceX)
                    //补充视图
                    addLabel(foreIndex: foreIndex, index: index, startX: (Handler.preSetTotalWidth - startX + suppleSpace)/2.0, startY: startY)
                    
                    //重新计算起始点
                    foreIndex = index
                    startX = textWidth + Handler.spaceX
                    startY += (Handler.height + Handler.spaceY)
                }
                index += 1
            }
            
            guard foreIndex < sources.count else {
                self.height = startY + Handler.spaceY
                return
            }
            
            addLabel(foreIndex: foreIndex, index: index, startX: (Handler.preSetTotalWidth - startX)/2.0, startY: startY)
            self.height = startY + 2 * Handler.spaceY
        }
        
    }
    
    func addLabel(foreIndex: Int, index: Int, startX: CGFloat , startY: CGFloat) {
        
        if let sources = self.sources {
            
            var insertX = CGFloat(startX)
            
            if Handler.handlerType == .startZore {
                insertX = 0
            }
            
            for i in foreIndex..<index {
                
                let content = sources[i]
                let contentWidth = content.widthWith(Handler.font, height: CGFloat(Handler.height)) + 2 * Handler.innerMargin
                
                var contentButton: UIButton?
                
                if let button = self.viewWithTag(i + 1) as? UIButton {
                    contentButton = button
                    contentButton?.frame = CGRect(x: insertX, y: startY, width: contentWidth, height: Handler.height)
                } else {
                    contentButton = UIButton(frame: CGRect(x: insertX, y: startY, width: contentWidth, height: Handler.height))
                    self.addSubview(contentButton!)
                }
                
                contentButton?.tag = i + 1
                contentButton?.setTitle(content, for: .normal)
                contentButton?.titleLabel?.font = Handler.font
                contentButton?.setTitleColor(Handler.textColor, for: .normal)
                contentButton?.titleLabel?.textAlignment = .center
                contentButton?.layer.borderWidth = 0.5
                contentButton?.backgroundColor = Handler.backGroundColor
                contentButton?.layer.borderColor = Handler.borderColor
                insertX += contentWidth
                insertX += Handler.spaceX
            }
        }
        
    }
    
}

extension String {
    func widthWith(_ font: UIFont, height: CGFloat) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat(height))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.width
    }
}
