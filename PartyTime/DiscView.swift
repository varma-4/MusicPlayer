//
//  DiscView.swift
//  PartyTime
//
//  Created by Mani on 21/02/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class DiscView: UIView {
    
    var smallDiscModeOn = true
    var fromEnlargedState = false
    
    var smallDiscFrame: CGRect = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2 + 20, height: UIScreen.main.bounds.height)
        return frame
    }()
    
    func smallDiscPath() -> (inner: UIBezierPath, outer: UIBezierPath) {
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 100)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: 100)
        return (innerPath, outerPath)
    }
    
    func enlargedDiscPath() -> (inner: UIBezierPath, outer: UIBezierPath) {
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 200)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: 200)
        return (innerPath, outerPath)
    }
    
    func getInnerSemiCircleBeizerpath(withRadius radius: CGFloat) -> UIBezierPath {
        let center = CGPoint(x: 0, y: bounds.height / 2)

        // Generating Beizerpath for Inner Semi circle
        let innerSemiCirclePath = UIBezierPath(arcCenter: center,
                                               radius: radius/2 + 10,
                                               startAngle: 0,
                                               endAngle: 180,
                                               clockwise: true)
        // Fill color is always White
        UIColor.white.setFill()
        return innerSemiCirclePath
    }
    
    func getOuterSemiCircleBeizerPath(withRadius radius: CGFloat) -> UIBezierPath {
        // Drawing Semicircle on the left corner
        let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
        
        let center = CGPoint(x: 0, y: bounds.height / 2)
        
        // Drawing outer circle
        var radiusFinal = radius * 2
        print(UIScreen.main.bounds.height/2)
        print(UIScreen.main.bounds.width - 10)
        if radius == 200 {
            radiusFinal = UIScreen.main.bounds.height/2
//            radiusFinal = min(UIScreen.main.bounds.width - 10, UIScreen.main.bounds.height - 20)
        }
        let outerSemiCirclePath = UIBezierPath(arcCenter: center,
                                               radius: radiusFinal,
                                               startAngle: 0,
                                               endAngle: 180,
                                               clockwise: true)
        color.setFill()
        return outerSemiCirclePath
    }
    
    var enlargedDiscFrame: CGRect = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height)
        return frame
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func paintDisc() {
        if smallDiscModeOn {
            smallDiscModeOn = false
            self.frame = enlargedDiscFrame
            draw(self.bounds)
        } else {
            smallDiscModeOn = true
            //chande to small
            self.frame = smallDiscFrame
            self.draw(self.bounds)
        }
    }
    
    override func draw(_ rect: CGRect) {
        if smallDiscModeOn {
            let path1 = smallDiscPath().outer
            
//            var animationsGroup = [CABasicAnimation]()
//            let center = CGPoint(x: 0, y: bounds.height / 2)
            let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
            let shapeLayer = getCAShapeLayer(forPath: path1, fillColor: color)
            
            if fromEnlargedState {
                let shapeLayer = getCAShapeLayer(forPath: enlargedDiscPath().outer, fillColor: .white)
                
                addLayer(shapeLayer: shapeLayer)
                fromEnlargedState = false
            }
            
            let shapeLayer1 = getCAShapeLayer(forPath: smallDiscPath().inner, fillColor: .white)
            
//            let animationGroup = CAAnimationGroup()
//            animationGroup.animations = animationsGroup
//            animationGroup.duration = 1.0
//            animationGroup.autoreverses = false
//            animationGroup.repeatCount = 0
//            animationGroup.fillMode = kCAFillModeBackwards
//            animationGroup.isRemovedOnCompletion = false
//            shapeLayer.add(animationGroup, forKey: nil)
            // remove existing shapelayers
            
            
            addLayer(shapeLayer: shapeLayer)
            addLayer(shapeLayer: shapeLayer1)
        } else {
            layer.sublayers = nil
            let path1 = enlargedDiscPath().outer

            let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
            let shapeLayer = getCAShapeLayer(forPath: path1, fillColor: color)
            
//            var animationsGroup = [CABasicAnimation]()
//            let center = CGPoint(x: 0, y: bounds.height / 2)
            
//            for i in 100...Int(bounds.width) {
//                let path = UIBezierPath(arcCenter: center,
//                                        radius: CGFloat(i),
//                                        startAngle: 0,
//                                        endAngle: 180,
//                                        clockwise: true)
//
//                let pathAnim = CABasicAnimation(keyPath: "path")
//                pathAnim.toValue = path.cgPath
//                animationsGroup.append(pathAnim)
//            }
//
//            let animationGroup = CAAnimationGroup()
//            animationGroup.animations = animationsGroup
//            animationGroup.duration = 1.0
//            animationGroup.autoreverses = false
//            animationGroup.repeatCount = 0
//            animationGroup.fillMode = kCAFillModeForwards
//            animationGroup.isRemovedOnCompletion = false
//            shapeLayer.add(animationGroup, forKey: nil)
            
            let shapeLayer1 = getCAShapeLayer(forPath: enlargedDiscPath().inner, fillColor: .white)

            addLayer(shapeLayer: shapeLayer)
            addLayer(shapeLayer: shapeLayer1)
            fromEnlargedState = true
        }
    }
    
    func getCAShapeLayer(forPath path: UIBezierPath, fillColor: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        return shapeLayer
    }
    
    func addLayer(shapeLayer: CAShapeLayer) {
        if let count = layer.sublayers?.count {
            print("Number of layers found: \(count)")
            if count > 2 {
                layer.sublayers = nil
            }
        }
        layer.addSublayer(shapeLayer)
    }
    
    
}
