//
//  ViewController.swift
//  PartyTime
//
//  Created by Manikanta Varma on 2/8/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var barButtonRightAnchorConstraint: NSLayoutConstraint?
    
    var discView: DiscView = {
        // Setting Frame
        let width = UIScreen.main.bounds.width + 60
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let discView = DiscView(frame: frame)
        discView.clipsToBounds = false
        discView.translatesAutoresizingMaskIntoConstraints = false
        discView.backgroundColor = .clear
        discView.layer.cornerRadius = frame.width / 2
        discView.layer.masksToBounds = true
        return discView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let backImage = UIImage(named: "backIcon")
        button.setImage(backImage, for: UIControlState.normal)
        button.addTarget(self, action: #selector(compressDisc), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backButton)
        let guide = self.view.safeAreaLayoutGuide
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonRightAnchorConstraint = backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 50)
        barButtonRightAnchorConstraint?.isActive = true
        backButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -15).isActive = true
    }
    
    override func loadView() {
        super.loadView()
        createDiscView()
    }
    
    func createDiscView() {
        self.view.addSubview(discView)
        discView.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        discView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        discView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width + 60)).isActive = true
        discView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width + 60)).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enlargeDiscView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        discView.isUserInteractionEnabled = true
        discView.addGestureRecognizer(tapGesture)
    }
    
    @objc func enlargeDiscView() {

        if self.discView.smallDiscModeOn {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.discView.transform = CGAffineTransform(scaleX: 1.65, y: 1.65)
            }, completion: nil)
            
            self.discView.smallDiscModeOn = false
            addButtonToSuperView()
        }
        
    }
    
    @objc func compressDisc() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.discView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        self.discView.smallDiscModeOn = true
        removeButtonfromSuperView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addButtonToSuperView() {
        
        UIView.animate(withDuration:0.8, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.barButtonRightAnchorConstraint?.constant = -15
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        
    }
    
    func removeButtonfromSuperView() {
        barButtonRightAnchorConstraint?.constant = 50
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }


}
