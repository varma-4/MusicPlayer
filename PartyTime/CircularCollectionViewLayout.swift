//
//  CircularCollectionViewLayout.swift
//  PartyTime
//
//  Created by Mani on 23/02/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    // 1
    var anchorPoint = CGPoint(x: -0.5, y: 0.5)
    var angle: CGFloat = 0 {
        // 2
        didSet {
//            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    // 3
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    let itemSize = CGSize(width: 140, height: 50)
    // Width should be outer- inner radius
    
    var radius: CGFloat = 60 {
        didSet {
            invalidateLayout()
        }
    }
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
            -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.y / (collectionViewContentSize.height -
            collectionView!.bounds.height)
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.height / radius) - 0.32
    }

    var attributesList = [CircularCollectionViewLayoutAttributes]()

    override public class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        // (collectionView?.contentOffset.x)! +

        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
        let anchorPointY = ((itemSize.width / 2.0) + radius) / itemSize.width
        
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            // 1
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            // 2
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            
            // 3
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: -0.5, y: 0.5)
            return attributes
        }

    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: (collectionView?.bounds.width)!, height:   (CGFloat((collectionView?.numberOfItems(inSection: 0))!) * itemSize.height) * 3)
    }
    // Let's fix our content Size to frame of the Disc 

}
