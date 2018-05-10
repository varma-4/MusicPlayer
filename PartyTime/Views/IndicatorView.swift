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
    var knobLayer = CAShapeLayer()
    
    var rotationGesture: RotationGestureRecognizer?
    
    // MARK:- Constants
    var minimumValue: Float = 0
    var maximumValue: Float = 200
    
    var valueRange: Float {
        return maximumValue - minimumValue
    }
    
    lazy var centerOfArc: CGPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height )
    
    var startAngle: CGFloat = -CGFloat(Double.pi / 2.2)//.2)//-CGFloat(Double.pi / 2)
    
    var endAngle: CGFloat = -CGFloat(Double.pi / 20)//0
    
    var angleRange: CGFloat {
        return endAngle - startAngle
    }
    
    var knobMidAngle: CGFloat {
        return (2 * CGFloat(Double.pi) + startAngle + endAngle) / 2 + endAngle
    }
    
    var arcRadius: CGFloat {
        get {
            return frame.width / 2
        }
    }
    
    var knobRadius: CGFloat {
        get {
            return 12
        }
    }
    
    var backingKnobAngle: CGFloat = -CGFloat(Double.pi / 2.2)
    var knobAngleAddition: CGFloat = CGFloat(Double.pi/2)
    
    var knobAngle: CGFloat {
        return CGFloat(normalizedValue) * angleRange + startAngle
    }
    
    var knobAngleRequired: CGFloat = 0
    
    var knobRotationTransform: CATransform3D {
        return CATransform3DMakeRotation(knobAngleRequired, 0.0, 0.0, 1)
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
    
    // MARK:- Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Configure ShapeLayers
    func configureVolumeShapeLayers() {
        knobLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        let xPosition = centerOfArc.x - knobRadius / 2
        let yPosition = centerOfArc.y - arcRadius - knobRadius / 2
        knobLayer.path = getKnobPath(for: xPosition, y: yPosition)
        configureShapeLayers()
    }
    
    func configureProgressShapeLayers() {
        knobLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
        let xPosition = centerOfArc.x + arcRadius - knobRadius / 2
        let yPosition = centerOfArc.y - knobRadius / 2
        knobLayer.path = getKnobPath(for: xPosition, y: yPosition)
        // TODO:- Remove the below value
        value = 50
        configureShapeLayers()
    }
    
    private func configureShapeLayers() {
        addShapeLayer(for: backgroundCircleLayer, frame: bounds, lineWidth: 5.0, fillWith: .clear, strokeWith: .white)
//        backgroundCircleLayer.frame = bounds
//        backgroundCircleLayer.lineWidth = 5.0
//        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
//        backgroundCircleLayer.strokeColor = UIColor.white.cgColor
//        backgroundCircleLayer.lineCap = kCALineCapRound
//        self.layer.addSublayer(backgroundCircleLayer)
        
        addShapeLayer(for: progressCircleLayer, frame: bounds, lineWidth: 5.0, fillWith: .clear, strokeWith: .green)
//        progressCircleLayer.frame = bounds
//        progressCircleLayer.lineWidth = 5.0
//        progressCircleLayer.fillColor = UIColor.clear.cgColor
//        progressCircleLayer.strokeColor = UIColor.green.cgColor
        progressCircleLayer.strokeEnd = 0
//        progressCircleLayer.lineCap = kCALineCapRound
//        self.layer.addSublayer(progressCircleLayer)
        
        addShapeLayer(for: knobLayer, frame: bounds, lineWidth: 1.5, fillWith: .green, strokeWith: .clear)
//        knobLayer.frame = bounds
//        knobLayer.lineWidth = 1.5
//        knobLayer.fillColor = UIColor.green.cgColor
//        knobLayer.strokeColor = UIColor.clear.cgColor
//        layer.addSublayer(knobLayer)
        
        backgroundCircleLayer.path = getCirclePath()
        progressCircleLayer.path = getCirclePath()
        
        knobLayer.position = centerOfArc
        
//        backgroundCircleLayer.bounds = bounds
//        progressCircleLayer.bounds = bounds
//        knobLayer.bounds = bounds
        
        setValue(value, animated: false)
    }
    
    func addShapeLayer(for layer: CAShapeLayer,  frame: CGRect, lineWidth: CGFloat, fillWith: UIColor, strokeWith: UIColor) {
        layer.frame = frame
        // TODO:- Remove and try layer.bounds
        layer.bounds = frame
        layer.lineWidth = lineWidth
        layer.fillColor = fillWith.cgColor
        layer.strokeColor = strokeWith.cgColor
        layer.lineCap = kCALineCapRound
        self.layer.addSublayer(layer)
    }
    
    func configureGesture() {
        rotationGesture = RotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)), arcRadius: arcRadius, knobRadius:  knobRadius)
        rotationGesture?.arcRadius = arcRadius
        rotationGesture?.centerOfArc = centerOfArc
        addGestureRecognizer(rotationGesture!)
    }
    
    func getCirclePath() -> CGPath {
        return UIBezierPath(arcCenter: centerOfArc, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
    
    func getKnobPath(for x: CGFloat, y: CGFloat) -> CGPath {
        return UIBezierPath(roundedRect: CGRect(x: x, y: y, width: knobRadius, height: knobRadius), cornerRadius: knobRadius / 2).cgPath
    }
    
//    func getVolumeKnobPath() -> CGPath {
//        return UIBezierPath(roundedRect: CGRect(x: (centerOfArc.x - knobRadius / 2), y: (centerOfArc.y - arcRadius - knobRadius / 2), width: knobRadius, height: knobRadius), cornerRadius: knobRadius / 2).cgPath
//    }
//
//    func getProgressKnobPath() -> CGPath {
//        return UIBezierPath(roundedRect: CGRect(x: (centerOfArc.x + arcRadius - knobRadius / 2), y: (centerOfArc.y - knobRadius / 2), width: knobRadius, height: knobRadius), cornerRadius: knobRadius / 2).cgPath
//    }
    
    @objc func handleRotationGesture(_ sender: AnyObject) {
        guard let gesture = sender as? RotationGestureRecognizer else { return }
        if gesture.state == UIGestureRecognizerState.began {
            cancelAnimation()
        }
        
        var rotationAngle = gesture.rotation
        
        if rotationAngle > knobMidAngle {
            rotationAngle -= CGFloat(2 * Double.pi)
        } else if rotationAngle < (knobMidAngle - CGFloat(2 * Double.pi)) {
            rotationAngle += CGFloat(2 * Double.pi)
        }
        rotationAngle = min(endAngle, max(startAngle, rotationAngle))
        
        guard abs(Double(rotationAngle - knobAngle)) < Double.pi/2 else { return }
        
        let valueForAngle = Float(rotationAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        setValue(valueForAngle, animated: false)
    }
}

// MARK:- GestureBased Actions
extension IndicatorView {
    
    func cancelAnimation() {
        progressCircleLayer.removeAllAnimations()
        knobLayer.removeAllAnimations()
    }
    
    open func setValue(_ value: Float, animated: Bool) {
        //        self.value = delegate?.circularSlider?(self, valueForValue: value) ?? value
        self.value = value
        self.setStrokeEnd(animated: animated)
        self.setKnobRotation(animated: animated)
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
        knobAngleRequired = knobAngle + knobAngleAddition
        animation.values = [backingKnobAngle, knobAngleRequired]
        knobLayer.add(animation, forKey: "knobRotationAnimation")
        knobLayer.transform = knobRotationTransform
        
        CATransaction.commit()
        
        backingKnobAngle = knobAngleRequired
    }
    
}


