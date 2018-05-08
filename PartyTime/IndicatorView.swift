//
//  IndicatorView.swift
//  PartyTime
//
//  Created by Mani on 08/05/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class IndicatorView: UIView {
    
    var progressCircleLayer = CAShapeLayer()
    var backgroundCircleLayer = CAShapeLayer()
    // TODO:- Fix Knob layer rotation issue
    var knobLayer = CAShapeLayer()
    
    var rotationGesture: RotationGestureRecognizer?
    
    // MARK:- Constants
    open var minimumValue: Float = 0
    open var maximumValue: Float = 100
    
    var valueRange: Float {
        return maximumValue - minimumValue
    }
    
    var centerOfArc: CGPoint {
        get {
            return CGPoint(x: frame.width / 2, y: frame.height )
        }
    }
    
    var startAngle: CGFloat {
        return -CGFloat(Double.pi / 2)
    }
    
    var endAngle: CGFloat {
        return  0
    }
    
    var angleRange: CGFloat {
        return CGFloat(Double.pi/2)
    }
    
    var knobMidAngle: CGFloat {
        return (2 * CGFloat(Double.pi) + startAngle + endAngle) / 2 + endAngle
    }
    
    var arcRadius: CGFloat {
        get {
            return ((frame.width / 2))
        }
    }
    
    var knobRadius: CGFloat {
        get {
            return 15
        }
    }
    
    var backingKnobAngle: CGFloat = 0
    
    var knobAngle: CGFloat {
        return CGFloat(normalizedValue) * angleRange + startAngle
    }
    
    var knobRotationTransform: CATransform3D {
        return CATransform3DMakeRotation(knobAngle, 0.0, 0.0, 1)
    }
    
    var normalizedValue: Float {
        return (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    var backingValue: Float = 0
    
    open var value: Float {
        get {
            return backingValue
        }
        set {
            backingValue = min(maximumValue, max(minimumValue, newValue))
        }
    }
    
    override func draw(_ rect: CGRect) {
        rotationGesture?.arcRadius = arcRadius
        
        backgroundCircleLayer.path = getCirclePath()
        progressCircleLayer.path = getCirclePath()
        //        knobLayer.path = getKnobPath()
        
        //        setValue(value, animated: false)
    }
    
    // MARK:- Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Configure ShapeLayers
    func configureShapeLayers() {
        backgroundCircleLayer.frame = bounds
        backgroundCircleLayer.lineWidth = 5.0
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.darkGray.cgColor
        backgroundCircleLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(backgroundCircleLayer)
        
        progressCircleLayer.frame = bounds
        progressCircleLayer.lineWidth = 5.0
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = UIColor.white.cgColor
        progressCircleLayer.strokeEnd = 0
        progressCircleLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(progressCircleLayer)
        
        knobLayer.frame = bounds
        knobLayer.position = centerOfArc
        knobLayer.lineWidth = 2
        knobLayer.fillColor = UIColor.green.cgColor
        knobLayer.strokeColor = UIColor.clear.cgColor
    }
    
    func configureGesture() {
        rotationGesture = RotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)), arcRadius: arcRadius, knobRadius:  knobRadius)
        rotationGesture?.arcRadius = arcRadius
        addGestureRecognizer(rotationGesture!)
    }
    
    func getCirclePath() -> CGPath {
        return UIBezierPath(arcCenter: centerOfArc, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
    
    func getKnobPath() -> CGPath {
        return UIBezierPath(roundedRect: CGRect(x: centerOfArc.x - knobRadius / 2, y: centerOfArc.y - arcRadius - knobRadius / 2, width: knobRadius, height: knobRadius), cornerRadius: knobRadius / 2).cgPath
    }
    
    func cancelAnimation() {
        progressCircleLayer.removeAllAnimations()
        knobLayer.removeAllAnimations()
    }
    
    open func setValue(_ value: Float, animated: Bool) {
        //        self.value = delegate?.circularSlider?(self, valueForValue: value) ?? value
        self.value = value
        
        //        updateLabels()
        setStrokeEnd(animated: animated)
        //        setKnobRotation(animated: animated)
    }
    
    func setStrokeEnd(animated: Bool) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = animated ? 0.66 : 0
        strokeAnimation.repeatCount = 1
        strokeAnimation.fromValue = progressCircleLayer.strokeEnd
        strokeAnimation.toValue = CGFloat(normalizedValue)
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.fillMode = kCAFillModeRemoved
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleLayer.add(strokeAnimation, forKey: "strokeAnimation")
        progressCircleLayer.strokeEnd = CGFloat(normalizedValue)
        CATransaction.commit()
    }
    
    func setKnobRotation(animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = animated ? 0.66 : 0
        animation.values = [backingKnobAngle, knobAngle]
        knobLayer.add(animation, forKey: "knobRotationAnimation")
        knobLayer.transform = knobRotationTransform
        
        CATransaction.commit()
        
        backingKnobAngle = knobAngle
    }
    
    @objc func handleRotationGesture(_ sender: AnyObject) {
        guard let gesture = sender as? RotationGestureRecognizer else { return }
        if gesture.state == UIGestureRecognizerState.began {
            cancelAnimation()
        }
        
        var rotationAngle = gesture.rotation
        print("Gesture rotation is made by \(radiansToDegress(radians: gesture.rotation))")
        //        if rotationAngle < startAngle || rotationAngle > 0 { return }
        if rotationAngle > knobMidAngle {
            print("In here 1")
            rotationAngle -= CGFloat(2 * Double.pi)
        } else if rotationAngle < (knobMidAngle - CGFloat(2 * Double.pi)) {
            print("In here 2")
            rotationAngle += CGFloat(2 * Double.pi)
        }
        rotationAngle = min(endAngle, max(startAngle, rotationAngle))
        
        guard abs(Double(rotationAngle - knobAngle)) < Double.pi/2 else { return }
        
        let valueForAngle = Float(rotationAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        setValue(valueForAngle, animated: false)
    }
    
    // TODO:- Remove Later
    func radiansToDegress(radians: CGFloat) -> CGFloat {
        return radians * 180 / CGFloat(Double.pi)
    }
}


