//
//  UIView+Extension.swift
//  rabbitDoctor
//
//  Created by PixelShi on 2017/2/9.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import UIKit

extension Selector {
    static let viewAction = #selector(UIView.tapGestureAction(_:))
}

class ActionManager: NSObject {
    var actionDict: Dictionary<NSValue, () -> ()> = Dictionary()
    static let sharedManager = ActionManager()
    override fileprivate init() {}
}

extension UIView {
    // MARK: Layer
    func boardColor(_ borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

    func borderRadius(_ radius:CGFloat){
        self.layer.cornerRadius = radius
    }

    /**
     * 默认为为grayColor
     * 默认透明度为0.5
     * 默认扩散范围为2
     * 默认阴影范围为size(1,1)
     - parameter color:
     */
    func shadow(_ color:UIColor = UIColor.gray,shadowOpacity:Float = 0.5,shadowRadius:CGFloat = 2,shadowOffset:CGSize = CGSize(width: 1, height: 1)) {
        self.layer.shadowColor = color.cgColor // 阴影的颜色
        self.layer.shadowOpacity = shadowOpacity // 阴影透明
        self.layer.shadowRadius = shadowRadius //// 阴影扩散的范围控制
        self.layer.shadowOffset = shadowOffset // 阴影的范围
    }

    // MARK: ACTION
    func addTapGestureAction(_ f: @escaping () -> ()) {
        let tap = UITapGestureRecognizer(target: self, action: .viewAction)
        self.addGestureRecognizer(tap)
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject: self)] = f
    }

    func tapGestureAction(_ tap: UITapGestureRecognizer) {
        if let closure = ActionManager.sharedManager.actionDict[NSValue(nonretainedObject: tap.view)] {
            closure()
        } else {

        }
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var bottom: CGFloat {
        get {
            return self.y + self.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    var right: CGFloat {
        get {
            return self.x + self.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }

    /**
     *  centerX, centerY
     */
    var centerX:CGFloat {
        get {
            return self.center.x;
        }

        set {
            self.center.x = newValue
        }
    }

    var centerY:CGFloat {
        get {
            return self.center.y;
        }

        set {
            self.center.y = newValue
        }
    }

    var innerCenter: CGPoint {
        return CGPoint(x: self.width/2, y: self.height/2)
    }

    class func instantiateFromNibWithOwner(_ owner: AnyObject) -> UIView? {
        let views = Bundle.main.loadNibNamed("\(self.nameOfClassWithoutModulename)", owner: owner, options: nil)
        return views?.first as? UIView
    }

    func snapshot() -> UIImage {
        return self.snapshotWithCompression(1)
    }

    func snapshotWithCompression(_ compression: CGFloat) -> UIImage {
        let gSize = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(gSize, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imgData = UIImageJPEGRepresentation(img!, compression)
        if compression < 1 {
            return UIImage(data: imgData!)!
        } else {
            return img!
        }
    }
    
    func foundCurrentViewController() -> AnyObject {
        guard self.superview != nil else {
            return self
        }
        var next = self.superview
        while (next != nil) {
            let responder = next?.next
            if let nextResponder = responder, nextResponder.isKind(of: UIViewController.self) {
                return nextResponder
            }
            next = next?.superview
        }
        return self
    }

}
