//
//  Extensions.swift
//  PartyTime
//
//  Created by Mani on 09/05/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension UIScrollView {
    func scrollToTopp(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -10),
                         animated: animated)
    }
    
    func scrollToBottomm(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude),
                         animated: animated)
    }
}

extension UIColor {
    
    class func partyTimeBlue() -> UIColor {
        //        let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
        let color = UIColor.init(red: 0/255, green: 145/255, blue: 147/255, alpha: 1)
        return color
    }
    
    class func hightLightColor() -> UIColor {
        return .black
        let color = UIColor.init(red: 0/255, green: 120/255, blue: 127/255, alpha: 1)
        return color
    }
    
}

extension UIView {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
}
