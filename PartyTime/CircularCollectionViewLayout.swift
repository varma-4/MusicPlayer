//
//  CircularCollectionViewLayout.swift
//  PartyTime
//
//  Created by Mani on 23/02/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    let itemSize = CGSize(width: 100, height: 50)
    
    var radius: CGFloat = 200 {
        didSet {
            invalidateLayout()
        }
    }

    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                      height: (collectionView?.bounds.height)!)
    }
    
}
