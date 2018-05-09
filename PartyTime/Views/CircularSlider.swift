//
//  CircularSlider.swift
//  CircularSliderExample
//
//  Created by Matteo Tagliafico on 02/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import Foundation
import UIKit


@objc public protocol CircularSliderDelegate: NSObjectProtocol {
    @objc optional func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float
}


@IBDesignable
open class CircularSlider: UIView {
    
    // MARK: - properties
    open weak var delegate: CircularSliderDelegate?
    
    fileprivate var backgroundCircleLayer = CAShapeLayer()
    var progressCircleLayer = CAShapeLayer()
    fileprivate var knobLayer = CAShapeLayer()
    fileprivate var backingValue: Float = 0
    fileprivate var backingKnobAngle: CGFloat = 0
    var rotationGesture: RotationGestureRecognizer?
    open var boundsToBeUsed: CGRect = CGRect.zero {
        didSet {
            configure()
        }
    }

    var startAngle: CGFloat = -CGFloat(Double.pi)//-CGFloat(Double.pi / 2)

    var endAngle: CGFloat = 0//-CGFloat(Double.pi / 20)
    
    fileprivate var angleRange: CGFloat {
        return endAngle - startAngle
    }
    
    fileprivate var valueRange: Float {
        return maximumValue - minimumValue
    }
    
    fileprivate var arcCenter: CGPoint {
        return CGPoint(x: bounds.minX, y: bounds.maxY)
    }
    
    var arcRadius: CGFloat {
        return min(frame.width,frame.height) / 2 - lineWidth / 2
    }
    
    fileprivate var normalizedValue: Float {
        return (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    fileprivate var knobAngle: CGFloat {
        return CGFloat(normalizedValue) * angleRange + startAngle
    }
    
    fileprivate var knobMidAngle: CGFloat {
        return (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
    }
    
    fileprivate var knobRotationTransform: CATransform3D {
        return CATransform3DMakeRotation(knobAngle, 0.0, 0.0, 1)
    }

    @IBInspectable
    open var radiansOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var value: Float {
        get {
            return backingValue
        }
        set {
            backingValue = min(maximumValue, max(minimumValue, newValue))
        }
    }
    @IBInspectable
    open var minimumValue: Float = 0
    @IBInspectable
    open var maximumValue: Float = 100
    @IBInspectable
    open var lineWidth: CGFloat = 5 {
        didSet {
            appearanceBackgroundLayer()
            appearanceProgressLayer()
        }
    }
    @IBInspectable
    open var bgColor: UIColor = UIColor.lightGray {
        didSet {
            appearanceBackgroundLayer()
        }
    }
    @IBInspectable
    open var pgNormalColor: UIColor = UIColor.darkGray {
        didSet {
            appearanceProgressLayer()
        }
    }
    @IBInspectable
    open var pgHighlightedColor: UIColor = UIColor.green {
        didSet {
            appearanceProgressLayer()
        }
    }
    @IBInspectable
    open var knobRadius: CGFloat = 20 {
        didSet {
            appearanceKnobLayer()
        }
    }
    @IBInspectable
    open var highlighted: Bool = true {
        didSet {
            appearanceProgressLayer()
            appearanceKnobLayer()
        }
    }

    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("Height: \(self.frame.height)")
        print("Width: \(self.frame.width)")
        print("Minx : \(self.frame.minX) \t MaxX: \(self.frame.maxX)")
        print("MinY : \(self.frame.minY) \t MaxY: \(self.frame.maxY)")
        print("Minx : \(self.frame.origin.x) \t MaxX: \(self.frame.origin.y)")
//        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        configure()
    }

    // MARK: - drawing methods
    override open func draw(_ rect: CGRect) {
        backgroundCircleLayer.bounds = bounds
        progressCircleLayer.bounds = bounds
        knobLayer.bounds = bounds
        
        backgroundCircleLayer.position = arcCenter
        progressCircleLayer.position = arcCenter
        knobLayer.position = arcCenter
        
        rotationGesture?.arcRadius = arcRadius
        
        backgroundCircleLayer.path = getCirclePath()
        progressCircleLayer.path = getCirclePath()
        knobLayer.path = getKnobPath()
        
        setValue(value, animated: false)
    }
    
    
    fileprivate func getCirclePath() -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.frame.width, y: self.frame.height),
                            radius: arcRadius,
                            startAngle: -CGFloat(Double.pi/2),
                            endAngle: 0,
                            clockwise: true).cgPath
    }
    
    fileprivate func getKnobPath() -> CGPath {
        return UIBezierPath(roundedRect:
            CGRect(x: arcCenter.x + arcRadius - knobRadius / 2, y: arcCenter.y - knobRadius / 2, width: knobRadius, height: knobRadius),
                            cornerRadius: knobRadius / 2).cgPath
    }
    
    
    // MARK: - configure
    fileprivate func configure() {
        clipsToBounds = false
        configureBackgroundLayer()
        configureProgressLayer()
        configureKnobLayer()
        configureGesture()
    }
    
    fileprivate func configureBackgroundLayer() {
        backgroundCircleLayer.frame = bounds
        layer.addSublayer(backgroundCircleLayer)
        appearanceBackgroundLayer()
    }
    
    fileprivate func configureProgressLayer() {
        if boundsToBeUsed != CGRect.zero {
            progressCircleLayer.frame = boundsToBeUsed
        } else {
            progressCircleLayer.frame = bounds
        }
        progressCircleLayer.strokeEnd = 0
        layer.addSublayer(progressCircleLayer)
        appearanceProgressLayer()
    }
    
    fileprivate func configureKnobLayer() {
        knobLayer.frame = bounds
        knobLayer.position = arcCenter
        layer.addSublayer(knobLayer)
        appearanceKnobLayer()
    }
    
    fileprivate func configureGesture() {
        rotationGesture = RotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)), arcRadius: arcRadius, knobRadius:  knobRadius)
        addGestureRecognizer(rotationGesture!)
    }
    
    // MARK: - appearance
    
    fileprivate func appearanceBackgroundLayer() {
        backgroundCircleLayer.lineWidth = lineWidth
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = bgColor.cgColor
        backgroundCircleLayer.lineCap = kCALineCapRound
    }
    
    fileprivate func appearanceProgressLayer() {
        progressCircleLayer.lineWidth = lineWidth
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = highlighted ? pgHighlightedColor.cgColor : pgNormalColor.cgColor
        progressCircleLayer.lineCap = kCALineCapRound
    }
    
    fileprivate func appearanceKnobLayer() {
        knobLayer.lineWidth = 2
        knobLayer.fillColor = highlighted ? pgHighlightedColor.cgColor : pgNormalColor.cgColor
        knobLayer.strokeColor = UIColor.clear.cgColor
    }
    
    
    // MARK: - update
    open func setValue(_ value: Float, animated: Bool) {
        self.value = delegate?.circularSlider?(self, valueForValue: value) ?? value
        
        setStrokeEnd(animated: animated)
        setKnobRotation(animated: animated)
    }
    
    fileprivate func setStrokeEnd(animated: Bool) {
        
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
    
    fileprivate func setKnobRotation(animated: Bool) {
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

    // MARK: - gesture handler
    @objc func handleRotationGesture(_ sender: AnyObject) {
        guard let gesture = sender as? RotationGestureRecognizer else { return }
        
        if gesture.state == UIGestureRecognizerState.began {
            cancelAnimation()
        }
        
        var rotationAngle = gesture.rotation
        if rotationAngle > knobMidAngle {
            rotationAngle -= 2 * CGFloat(Double.pi)
        } else if rotationAngle < (knobMidAngle - 2 * CGFloat(Double.pi)) {
            rotationAngle += 2 * CGFloat(Double.pi)
        }
        rotationAngle = min(endAngle, max(startAngle, rotationAngle))
        
        guard abs(Double(rotationAngle - knobAngle)) < Double.pi / 2 else { return }
        
        let valueForAngle = Float(rotationAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        setValue(valueForAngle, animated: false)
    }
    
    func cancelAnimation() {
        progressCircleLayer.removeAllAnimations()
        knobLayer.removeAllAnimations()
    }
}
