//
//  VolumeIndicatorView.swift
//  PartyTime
//
//  Created by Mani on 08/05/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class VolumeIndicatorView: IndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureShapeLayers()
        configureGesture()
        addVolumeIcons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var volumeDownView: UIImageView = {
        let imageFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let iv = UIImageView(frame: imageFrame)
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return UIImageView()
    }()
    
    var volumeUpView: UIImageView = {
        let imageFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let iv = UIImageView(frame: imageFrame)
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return UIImageView()
    }()
    
    func addVolumeIcons() {
        addSubview(volumeDownView)
        addSubview(volumeUpView)
        
        volumeDownView.image = #imageLiteral(resourceName: "volumeDown").withRenderingMode(.alwaysOriginal)
        volumeDownView.translatesAutoresizingMaskIntoConstraints = false
        volumeDownView.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 30).isActive = true
        volumeDownView.topAnchor.constraint(equalTo: self.topAnchor, constant: 42).isActive = true
        volumeDownView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        volumeDownView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        volumeUpView.image = #imageLiteral(resourceName: "volumeUp").withRenderingMode(.alwaysOriginal)
        volumeUpView.translatesAutoresizingMaskIntoConstraints = false
        volumeUpView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        volumeUpView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        volumeUpView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        volumeUpView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}

