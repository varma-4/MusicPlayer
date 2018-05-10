//
//  ProgressIndiactorView.swift
//  PartyTime
//
//  Created by Manikanta Varma on 5/8/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit

class ProgressIndicatorView: IndicatorView {
    
    // MARK:- Intialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        startAngle = CGFloat(Double.pi / 20)
        endAngle = CGFloat(Double.pi / 2.2)
        centerOfArc = CGPoint(x: frame.width/2, y: 0)
        knobAngleAddition = CGFloat(2 * Double.pi)
        backingKnobAngle = CGFloat(Double.pi / 20)
        // TODO:- Add seconds 0 to endTime
        minimumValue = 0
        maximumValue = 60
        configureProgressShapeLayers()
        configureGesture()
        addProgressLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "1:02"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    func addProgressLabel() {
        addSubview(progressLabel)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        progressLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
