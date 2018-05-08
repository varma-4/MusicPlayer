//
//  ProgressIndiactorView.swift
//  PartyTime
//
//  Created by Manikanta Varma on 5/8/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class ProgressIndicatorView: IndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        startAngle = CGFloat(Double.pi / 20)
        endAngle = CGFloat(Double.pi / 2.2)
        centerOfArc = CGPoint(x: frame.width/2, y: 0)
        configureShapeLayers()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
