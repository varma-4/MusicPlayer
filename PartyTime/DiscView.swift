//
//  DiscView.swift
//  PartyTime
//
//  Created by Mani on 21/02/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit
import MediaPlayer

protocol changeImageViewProtocol {
    func changeImageTo(album: MPMediaItem)
}

class DiscView: UIView, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let width = UIScreen.main.bounds.width + 120
    
    var volumeViewShapeLayer: CAShapeLayer?
    var volumeView: CircularSlider?
    
    var delegate: changeImageViewProtocol? {
        didSet {
            if delegate != nil && musicAlbum.count > 0 {
              delegate?.changeImageTo(album: musicAlbum.first!)
            }
        }
    }
    
    var musicAlbum = [MPMediaItem]()
    var highlightedShapeLayer: CAShapeLayer?
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "artWork.jpg")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var songsCollectionView: UICollectionView?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicAlbum.count
    }
    
    let colors = [UIColor.red, UIColor.lightGray, UIColor.orange, UIColor.darkGray, UIColor.orange, UIColor.brown]
    
    var scrollAlreadyDone = false
    var alreadyHiglighted = false
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked item at IndexPath: \(indexPath.row)")
        
        let cell = (collectionView.cellForItem(at: indexPath) as? CircularColectionViewCell)
        let layoutAttributes = cell?.cellLayoutAttributes as? CircularCollectionViewLayoutAttributes

        let angle = layoutAttributes?.angle.radiansToDegrees
        
        print(angle!)
        let yShift = getYShiftContentoffset(for: indexPath)
        collectionView.setContentOffset(CGPoint(x: (cell?.bounds.minX)!, y: (cell?.bounds.minY)! + yShift), animated: true)
        
        if !alreadyHiglighted {
            highlightItem(cell: cell!)
            alreadyHiglighted = true
        }
        
    }
    
    func getYShiftContentoffset(for indepath: IndexPath) -> CGFloat {
        var contentHeight = 718
        if musicAlbum.count <= 5 {
            contentHeight = 1100
            let cellShiftHeight = CGFloat( contentHeight / musicAlbum.count)
            var cellYShiftContentHeight = (cellShiftHeight / 2)
            if musicAlbum.count >= 2 && indepath.row >= 1 {
                cellYShiftContentHeight -= 40.0
            }
            return cellYShiftContentHeight * CGFloat(indepath.row)
        } else {
            let cellShiftHeight = CGFloat( contentHeight / musicAlbum.count)
            var cellYShiftContentHeight = (cellShiftHeight / 2)
            if indepath.row > 1 {
                cellYShiftContentHeight -= 4.0
            }
            return cellYShiftContentHeight * CGFloat(indepath.row)
        }
    }
    
    func getAlbums() {
        let albumQuery = MPMediaQuery.albums()
        guard let albums = albumQuery.collections else {
            print("No albums avalibale")
            return
        }
        print("Albums Count: \(albums.count)\n\n\n")
        
        for eachAlbum in albums {
            if eachAlbum.items.count != 10 {
                continue
            }
            for eachSong in eachAlbum.items {
                musicAlbum.append(eachSong)
            }
            
            print("Album fetched")
            break
        }
        
    }
    
    func highlightItem(cell: UICollectionViewCell) {
        self.drawPie(center: centerOfDisc, radius: 152.5, startAngle: CGFloat(.pi * 0.06), endAngle: CGFloat(.pi * -0.06), color: UIColor.hightLightColor(), cell: cell)
    }
    
    func drawPie(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle:CGFloat, color: UIColor, cell: UICollectionViewCell) {
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: false)
        
        highlightedShapeLayer = CAShapeLayer()
        guard let highlightedShapeLayer = highlightedShapeLayer else {
            return
        }
        
        highlightedShapeLayer.path = circlePath.cgPath
        //change the fill color
        highlightedShapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        highlightedShapeLayer.strokeColor = color.cgColor
        //you can change the line width
        highlightedShapeLayer.lineWidth = 200
        highlightedShapeLayer.opacity = 0.3
        layer.addSublayer(highlightedShapeLayer)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CircularColectionViewCell
        collectionViewCell.backgroundColor = .clear
        collectionViewCell.label.text = musicAlbum[indexPath.row].title
        collectionViewCell.subTitleLabel.text = musicAlbum[indexPath.row].artist

        return collectionViewCell
    }
    

    var smallDiscModeOn = true {
        didSet {
            if !smallDiscModeOn {
                initialiseCollectionView()
            } else {
                removeCollectionViewFromSuperView()
            }
        }
    }
    
    
    var fromEnlargedState = false
    
    var smallDiscFrame: CGRect = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2 + 20, height: UIScreen.main.bounds.height)
        return frame
    }()
    
    func removeCollectionViewFromSuperView() {
        if songsCollectionView != nil {
            UIView.animate(withDuration: 2.0, animations: {
                self.songsCollectionView?.removeFromSuperview()
            })
        }
    }
    
    func initialiseCollectionView() {
        let layout = CircularCollectionViewLayout()
        let myCollectionView = ItemsCollectionView(frame: bounds, collectionViewLayout: layout)
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = .clear
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.scrollIndicatorInsets = myCollectionView.contentInset
        myCollectionView.isUserInteractionEnabled = true
        myCollectionView.allowsSelection = true
        
        myCollectionView.register(CircularColectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        myCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        songsCollectionView = myCollectionView
        
//        myCollectionView.backgroundColor = .lightGray
    }
    
    lazy var centerOfDisc: CGPoint = {
        let center = CGPoint(x: bounds.width/2, y: bounds.height / 2)
        return center
    }()

    var enlargedDiscFrame: CGRect = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height - 10, height: UIScreen.main.bounds.height - 10)
        return frame
    }()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print(touch)
        return true
    }
    
    // MARK: - View Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        if MPMediaLibrary.authorizationStatus() == .notDetermined {
            MPMediaLibrary.requestAuthorization({ (_) in
                self.getAlbums()
            })
        } else {
            getAlbums()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var shapeLayerCircle: CAShapeLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        let radi = CGFloat(135)
        let circlePath = UIBezierPath(arcCenter: centerOfDisc, radius: radi, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi / 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayerCircle = shapeLayer
        
        shapeLayer.path = circlePath.cgPath
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.partyTimeBlue().cgColor
        //you can change the line width
        print(smallDiscPath().outer.radius - radi)
        print(frame.height)
        shapeLayer.lineWidth = 165
        shapeLayer.opacity = 0.8
        layer.addSublayer(shapeLayer)
    }
    
    func smallDiscPath() -> (inner: (path: UIBezierPath, radius: CGFloat), outer: (path: UIBezierPath, radius: CGFloat)) {
        let width = UIScreen.main.bounds.width + 60
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 120)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: width/2)
        return (innerPath, outerPath)
    }
    
    func enlargedDiscPath() -> (inner: (path: UIBezierPath, radius: CGFloat), outer: (path: UIBezierPath, radius: CGFloat)) {
        let innerPath = getInnerSemiCircleBeizerpath(withRadius: 200)
        let outerPath = getOuterSemiCircleBeizerPath(withRadius: 200)
        return (innerPath, outerPath)
    }
    
    func getInnerSemiCircleBeizerpath(withRadius radius: CGFloat) -> (path: UIBezierPath, radius: CGFloat) {
        let center = CGPoint(x: bounds.width/2, y: bounds.height / 2)
        let radiusFinal = radius/2 + 10

        // Generating Beizerpath for Inner Semi circle
        let innerSemiCirclePath = UIBezierPath(arcCenter: center,
                                               radius: radiusFinal,
                                               startAngle: 0,
                                               endAngle: 180,
                                               clockwise: true)
 
        return (innerSemiCirclePath, radiusFinal)
    }
    
    func getOuterSemiCircleBeizerPath(withRadius radius: CGFloat) -> (path: UIBezierPath, radius: CGFloat) {
        // Drawing Semicircle on the left corner
        let center = CGPoint(x: bounds.width/2, y: bounds.height / 2)
        
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
//        let color = UIColor.init(red: 51/255, green: 138/255, blue: 248/255, alpha: 1)
        let color = UIColor.init(red: 0/255, green: 145/255, blue: 147/255, alpha: 1)
        return color
    }
    
    class func hightLightColor() -> UIColor {
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


class ItemsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CircularColectionViewCell: UICollectionViewCell {
    
    var cellLayoutAttributes: UICollectionViewLayoutAttributes?
    
    var label: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subTitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabels()
    }
    
    func addLabels() {
        addSubview(label)
        addSubview(subTitleLabel)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: self.subTitleLabel.topAnchor, constant: 3).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        
        subTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 9)
        subTitleLabel.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        cellLayoutAttributes = layoutAttributes
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
}

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

extension CGPath {
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        print(MemoryLayout.size(ofValue: body))
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }
    
    func getPathElementsPointsAndTypes() -> ([CGPoint],[CGPathElementType]) {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        var arrayTypes : [CGPathElementType]! = [CGPathElementType]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            default: break
            }
        }
        return (arrayPoints,arrayTypes)
    }
}
