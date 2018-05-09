//
//  CircularColectionViewCell.swift
//  PartyTime
//
//  Created by Mani on 09/05/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

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
