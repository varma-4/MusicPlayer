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
    
    // Circular CollectionView Object
    var songsCollectionView: UICollectionView?
    let width = UIScreen.main.bounds.width + 120
    var alreadyHiglighted = false

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
    
    func getAlbums() {
        let albumQuery = MPMediaQuery.albums()
        guard let albums = albumQuery.collections else {
            return
        }
        
        for eachAlbum in albums {
            if eachAlbum.items.count != 10 {
                continue
            }
            for eachSong in eachAlbum.items {
                musicAlbum.append(eachSong)
            }
            
            break
        }
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
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
    
    func initialiseCollectionView() {
        let layout = CircularCollectionViewLayout()
        let width = UIScreen.main.bounds.width + 60
        let frameBounds = CGRect(x: 0, y: 0, width: width, height: width)
        
        let myCollectionView = ItemsCollectionView(frame: frameBounds, collectionViewLayout: layout)
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
        
        myCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        myCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        myCollectionView.heightAnchor.constraint(equalToConstant: width).isActive = true
        myCollectionView.widthAnchor.constraint(equalToConstant: width).isActive = true
        songsCollectionView = myCollectionView
    }
    
    lazy var centerOfDisc: CGPoint = {
        let center = CGPoint(x: bounds.width/2, y: bounds.height / 2)
        return center
    }()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
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
        let circlePath = UIBezierPath(arcCenter: centerOfDisc, radius: radi, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayerCircle = shapeLayer
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.partyTimeBlue().cgColor
        shapeLayer.lineWidth = 165
        shapeLayer.opacity = 0.8
        
        layer.addSublayer(shapeLayer)
    }

}

// MARK:- CollectionView Delegate & DataSource Methods
extension DiscView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CircularColectionViewCell
        collectionViewCell.backgroundColor = .clear
        collectionViewCell.label.text = musicAlbum[indexPath.row].title
        collectionViewCell.subTitleLabel.text = musicAlbum[indexPath.row].artist
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as? CircularColectionViewCell)
        
        let yShift = getYShiftContentoffset(for: indexPath)
        collectionView.setContentOffset(CGPoint(x: (cell?.bounds.minX)!, y: (cell?.bounds.minY)! + yShift), animated: true)
        
        if !alreadyHiglighted {
            highlightItem(cell: cell!)
            alreadyHiglighted = true
        }
    }
    
}

// MARK:- Circular Disc Highlight Functionalities
extension DiscView {
    
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
        highlightedShapeLayer.fillColor = UIColor.clear.cgColor
        highlightedShapeLayer.strokeColor = color.cgColor
        highlightedShapeLayer.lineWidth = 200
        highlightedShapeLayer.opacity = 0.3
        layer.addSublayer(highlightedShapeLayer)
    }
    
    func removeCollectionViewFromSuperView() {
        if songsCollectionView != nil {
            UIView.animate(withDuration: 2.0, animations: {
                self.songsCollectionView?.removeFromSuperview()
            })
        }
    }
    
}
