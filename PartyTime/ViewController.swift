//
//  ViewController.swift
//  PartyTime
//
//  Created by Manikanta Varma on 2/8/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    var discView: DiscView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2 + 20, height: UIScreen.main.bounds.height - 10)
        let discView = DiscView(frame: frame)
        discView.clipsToBounds = true
        discView.translatesAutoresizingMaskIntoConstraints = false
        discView.backgroundColor = .white
       return discView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createDiscView()
    }
    
    func createDiscView() {
        self.view.addSubview(discView)
        discView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        discView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        discView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
//        discView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        discView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 20).isActive = true
        discView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 + 20).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enlargeDiscView))
        tapGesture.numberOfTapsRequired = 1
        discView.isUserInteractionEnabled = true
        discView.addGestureRecognizer(tapGesture)
    }
    
    @objc func enlargeDiscView() {
        print("Tapped on View")
        self.discView.paintDisc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

