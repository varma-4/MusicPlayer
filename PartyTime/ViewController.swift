//
//  ViewController.swift
//  PartyTime
//
//  Created by Manikanta Varma on 2/8/18.
//  Copyright © 2018 Manikanta Varma. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIGestureRecognizerDelegate, changeImageViewProtocol {
    
    @IBOutlet weak var albumImageView: UIImageView!
    var barButtonRightAnchorConstraint: NSLayoutConstraint?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func changeImageTo(album: MPMediaItem) {
        let artwork = album.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        let image = artwork?.image(at: CGSize(width: (artwork?.bounds.width)!, height: (artwork?.bounds.height)!))
        albumImageView.image = image
    }
    
    var discView: DiscView = {
        // Setting Frame
        let width = UIScreen.main.bounds.width + 60
        print(width)
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let discView = DiscView(frame: frame)
        discView.clipsToBounds = false
        discView.translatesAutoresizingMaskIntoConstraints = false
        discView.backgroundColor = .clear
        print("FrameWidth/2 is \(frame.width / 2)")
        discView.layer.cornerRadius = frame.width / 2
        discView.clipsToBounds = true
        return discView
    }()
    
    
    let width = UIScreen.main.bounds.width + 120
    
    lazy var volumeView: CircularSlider = {
        let frame = CGRect(x: 0, y: 0, width: self.width/2, height: self.width/2)
        let volumeView = CircularSlider(frame: frame)
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.backgroundColor = .orange
        volumeView.isUserInteractionEnabled = true
        volumeView.startAngle = -CGFloat(Double.pi / 2)
        volumeView.endAngle = CGFloat(Double.pi / 20)
        return volumeView
    }()
    
    lazy var songProgressView: CircularSlider = {
        let frame = CGRect(x: 0, y: 0, width: self.width, height: self.width)
        let songProgressView = CircularSlider(frame: frame)
        songProgressView.translatesAutoresizingMaskIntoConstraints = false
        songProgressView.backgroundColor = .clear
        songProgressView.isUserInteractionEnabled = true
        songProgressView.startAngle = CGFloat(Double.pi / 20)
        songProgressView.endAngle = CGFloat(Double.pi / 2)
        return songProgressView
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
        self.discView.delegate = self
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
//        view.addSubview(songProgressView)
        view.addSubview(volumeView)
        self.view.addSubview(discView)
        self.discView.delegate = self
        self.discView.volumeViewShapeLayer = volumeView.progressCircleLayer
        self.discView.volumeView = volumeView
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
        
        volumeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        volumeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        volumeView.heightAnchor.constraint(equalToConstant: width/2).isActive = true
        volumeView.widthAnchor.constraint(equalToConstant: width/2).isActive = true
        volumeView.boundsToBeUsed = discView.bounds
        
//        songProgressView.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
//        songProgressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
//        songProgressView.heightAnchor.constraint(equalToConstant: width + 20).isActive = true
//        songProgressView.widthAnchor.constraint(equalToConstant: width - 20).isActive = true
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
        self.discView.highlightedShapeLayer?.removeFromSuperlayer()
        self.discView.alreadyHiglighted = false
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
