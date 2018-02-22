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
    
    lazy var centerOfDisc: CGPoint = {
        let center = CGPoint(x: 0, y: bounds.height / 2)
        return center
    }()

    var enlargedDiscFrame: CGRect = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height)
        return frame
    }()
    
    // MARK: - View Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        if smallDiscModeOn {
            
            // Small Disc Outer semicircle
            let smallDiscOuterShapeLayer = getCAShapeLayer(forPath: smallDiscPath().outer.path, fillColor: UIColor.partyTimeBlue())
            // Small Disc Inner Semicircle
            let smallDiscInnerShapeLayer = getCAShapeLayer(forPath: smallDiscPath().inner.path, fillColor: .white)
            
            if fromEnlargedState {
                
                let outerRangeCount = Int(enlargedDiscPath().outer.radius - smallDiscPath().outer.radius)
                let innerRangeCount = Int(enlargedDiscPath().inner.radius - smallDiscPath().inner.radius + 20)
                print(innerRangeCount)
                // Get AnimationsGroup for enlargedDisc outer SemiCircle
                let outerAnimsGroup = makeAnimationsGroupForEnlargedToSmall(withRange: outerRangeCount, intialRadius: enlargedDiscPath().outer.radius)
    
                // Get path for smallDisc Outer path
                let animShapeLayer = getCAShapeLayer(forPath: smallDiscPath().outer.path, fillColor: UIColor.partyTimeBlue())
                // Animate Enlarged to Small Disc
                let animationGroupEnlargeToSmall = getAnimationGroup(withLowerLimit: 0, upperLimit: 0, animsGroup: outerAnimsGroup)
                
                // Add animationGroup to Outer Semicircle
                animShapeLayer.add(animationGroupEnlargeToSmall, forKey: nil)
                
                // Get AnimationsGroup for enlargedDisc inner semicircle
                let innerAnimsGroup = makeAnimationsGroupForEnlargedToSmall(withRange: innerRangeCount, intialRadius: enlargedDiscPath().inner.radius + 20)
                
                // Get path for smallDisc Inner path
                let innerAnimShapeLayer = getCAShapeLayer(forPath: smallDiscPath().inner.path, fillColor: UIColor.white)
                // Animate Enlarged to Small Disc Inner
                let animationGroupEnlargeToSmallInner = getAnimationGroup(withLowerLimit: 0, upperLimit: 0, animsGroup: innerAnimsGroup)
                
                // Add animationGroup to Inner Semicircle
                innerAnimShapeLayer.add(animationGroupEnlargeToSmallInner, forKey: nil)
                
                // Paint all the shapeLayers
                addLayer(shapeLayer: smallDiscOuterShapeLayer)
                addLayer(shapeLayer: animShapeLayer)
                addLayer(shapeLayer: innerAnimShapeLayer)
                
                fromEnlargedState = false
            } else {
                // Animate Outer Semicircle
                let smallDiscAnimGroup = getAnimationGroup(withLowerLimit: 0, upperLimit: Int(smallDiscPath().outer.radius))

                // Add animationGroup to Outer semicircle Layer
                smallDiscOuterShapeLayer.add(smallDiscAnimGroup, forKey: nil)

                // First paint the Outer semicircle, followed by inner semicircle
                addLayer(shapeLayer: smallDiscOuterShapeLayer)
                addLayer(shapeLayer: smallDiscInnerShapeLayer)
            }
        } else {
            layer.sublayers = nil
            
            // Outer Semicirle
            let enlargedDiscOuterShapeLayer = getCAShapeLayer(forPath: enlargedDiscPath().outer.path, fillColor: UIColor.partyTimeBlue())
            
            // Animate Outer Semicircle
            let enlargedOuterAnimationGroup = getAnimationGroup(withLowerLimit: 0, upperLimit: Int(enlargedDiscPath().outer.radius))
            // Add Animation Object to Outer Semicircle
            enlargedDiscOuterShapeLayer.add(enlargedOuterAnimationGroup, forKey: nil)
            
            // Inner SemiCircle
            let enlargedDiscInnerShapeLayer = getCAShapeLayer(forPath: enlargedDiscPath().inner.path, fillColor: .white)
            // Animate Inner Semicircle
            let enlargedInnerAnimationsGroup = getAnimationGroup(withLowerLimit: 0, upperLimit: Int(enlargedDiscPath().inner.radius))
            // Add Animation Group to shapeLayer
            enlargedDiscInnerShapeLayer.add(enlargedInnerAnimationsGroup, forKey: nil)
            
            // First paint the Outer semicircle, followed by inner semicircle
            addLayer(shapeLayer: enlargedDiscOuterShapeLayer)
            addLayer(shapeLayer: enlargedDiscInnerShapeLayer)
            fromEnlargedState = true
        }
    }
    
    func smallDiscPath() -> (inner: (path: UIBezierPath, radius: CGFloat), outer: (path: UIBezierPath, radius: CGFloat)) {
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 100)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: 100)
        return (innerPath, outerPath)
    }
    
    func enlargedDiscPath() -> (inner: (path: UIBezierPath, radius: CGFloat), outer: (path: UIBezierPath, radius: CGFloat)) {
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 200)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: 200)
        return (innerPath, outerPath)
    }
    
    func getInnerSemiCircleBeizerpath(withRadius radius: CGFloat) -> (path: UIBezierPath, radius: CGFloat) {
        let center = CGPoint(x: 0, y: bounds.height / 2)
        let radiusFinal = radius/2 + 10

        // Generating Beizerpath for Inner Semi circle
        let innerSemiCirclePath = UIBezierPath(arcCenter: center,
                                               radius: radiusFinal,
                                               startAngle: 0,
                                               endAngle: 180,
                                               clockwise: true)
        // Fill color is always White
        UIColor.white.setFill()
        return (innerSemiCirclePath, radiusFinal)
    }
    
    func getOuterSemiCircleBeizerPath(withRadius radius: CGFloat) -> (path: UIBezierPath, radius: CGFloat) {
        // Drawing Semicircle on the left corner
        let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
        
        let center = CGPoint(x: 0, y: bounds.height / 2)
        
        // Drawing outer circle
        var radiusFinal = radius * 2
        if radius == 200 {
            radiusFinal = min(UIScreen.main.bounds.width - 10, UIScreen.main.bounds.height/2 - 20)
            print("Radius Final: \(radiusFinal)")
        }
        let outerSemiCirclePath = UIBezierPath(arcCenter: center,
                                               radius: radiusFinal,
                                               startAngle: 0,
                                               endAngle: 180,
                                               clockwise: true)
        color.setFill()
        return (outerSemiCirclePath, radiusFinal)
    }
    
    func paintDisc() {
        if smallDiscModeOn {
            smallDiscModeOn = false
            self.frame = enlargedDiscFrame
            draw(self.bounds)
        } else {
            smallDiscModeOn = true
            self.frame = smallDiscFrame
            self.draw(self.bounds)
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
    
    func getAnimationGroup(withLowerLimit lowerLimit: Int, upperLimit: Int, animsGroup: [CABasicAnimation]? = nil, fillMode: String = kCAFillModeForwards) -> CAAnimationGroup {
        var animationsGroup = [CABasicAnimation]()
        let animationGroup = CAAnimationGroup()
        let animationDuration = 2.0
        
        if let animsGroup = animsGroup {
            animationGroup.animations = animsGroup
        } else {

            for i in lowerLimit...upperLimit {
                let path = UIBezierPath(arcCenter: centerOfDisc,
                                        radius: CGFloat(i),
                                        startAngle: 0,
                                        endAngle: 180,
                                        clockwise: true)
                
                let pathAnim = CABasicAnimation(keyPath: "path")
                pathAnim.toValue = path.cgPath
                animationsGroup.append(pathAnim)
            }
            animationGroup.animations = animationsGroup
        }
        
        animationGroup.duration = animationDuration
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationGroup.autoreverses = false
        animationGroup.repeatCount = 0
        animationGroup.fillMode = fillMode
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }
    
    func makeAnimationsGroupForEnlargedToSmall(withRange range: Int, intialRadius: CGFloat) -> [CABasicAnimation] {
        var animationsGroup = [CABasicAnimation]()
        var rangeCount = range
        var radius = intialRadius

        while rangeCount > 0 {
            let semPath = UIBezierPath(arcCenter: centerOfDisc,
                                       radius: radius,
                                       startAngle: 0,
                                       endAngle: 180,
                                       clockwise: true)
            let pathAnim = CABasicAnimation(keyPath: "path")
            pathAnim.toValue = semPath.cgPath
            animationsGroup.append(pathAnim)
            rangeCount = rangeCount - 1
            radius = radius - 1.0
        }

        return animationsGroup
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

extension UIColor {
    
    class func partyTimeBlue() -> UIColor {
        let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
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
