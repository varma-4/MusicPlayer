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
        configureShapeLayers()
        configureGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

