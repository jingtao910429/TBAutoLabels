//
//  NSObject+Extension.swift
//  rabbitDoctor
//
//  Created by PixelShi on 2017/2/9.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation

extension NSObject {
    public class var nameOfClass: String {
        return NSStringFromClass(self)
    }

    public var nameOfClass: String {
        return NSStringFromClass(type(of: self))
    }

    public class var nameOfClassWithoutModulename: String {
        return self.nameOfClass.components(separatedBy: ".").last!
    }

    public var nameOfClassWithoutModulename: String {
        return self.nameOfClass.components(separatedBy: ".").last!
    }
}
