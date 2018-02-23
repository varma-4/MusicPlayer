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
    
    var discView: DiscView = {
        // Setting Frame
        let width = UIScreen.main.bounds.width + 60
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let discView = DiscView(frame: frame)
        discView.clipsToBounds = false
        discView.translatesAutoresizingMaskIntoConstraints = false
        discView.backgroundColor = .lightGray
        discView.layer.cornerRadius = frame.width / 2
        discView.layer.masksToBounds = true
        return discView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        discView.isUserInteractionEnabled = true
        discView.addGestureRecognizer(tapGesture)
    }
    
    @objc func enlargeDiscView() {

        if self.discView.smallDiscModeOn {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.discView.transform = CGAffineTransform(scaleX: 1.65, y: 1.65)
            }, completion: nil)
            
            self.discView.smallDiscModeOn = false
        } else {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.discView.transform = CGAffineTransform.identity
            }, completion: nil)
            
            self.discView.smallDiscModeOn = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
