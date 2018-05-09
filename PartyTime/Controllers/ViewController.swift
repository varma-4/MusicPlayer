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
    
    let width = UIScreen.main.bounds.width
    
    lazy var discView: DiscView = {
        // Setting Frame
        let frame = CGRect(x: 0, y: 0, width: self.width, height: self.width)
        let discView = DiscView(frame: frame)
        discView.clipsToBounds = false
        discView.translatesAutoresizingMaskIntoConstraints = false
        discView.backgroundColor = .clear
//        print("FrameWidth/2 is \(frame.width / 2)")
//        discView.layer.cornerRadius = frame.width / 2
//        discView.clipsToBounds = true
        return discView
    }()
    
    var volumeIndicatorView: VolumeIndicatorView?
    var progressIndicatorView: ProgressIndicatorView?
    
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
        addIndicatorViews()
    }
    
    fileprivate func addIndicatorViews() {
        volumeIndicatorView = VolumeIndicatorView(frame: CGRect(x: 0, y: 0, width: 500
            , height: 300))
        guard let volumeIndicatorView = volumeIndicatorView else { return }
        volumeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(volumeIndicatorView, belowSubview: discView)
        volumeIndicatorView.centerXAnchor.constraint(equalTo: self.discView.centerXAnchor).isActive = true
        volumeIndicatorView.bottomAnchor.constraint(equalTo: self.discView.centerYAnchor).isActive = true
        volumeIndicatorView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        volumeIndicatorView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        progressIndicatorView = ProgressIndicatorView(frame: CGRect(x: 0, y: 0, width: 500
            , height: 300))
        guard let progressIndicatorView = progressIndicatorView else { return }
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(progressIndicatorView, belowSubview: discView)
        progressIndicatorView.centerXAnchor.constraint(equalTo: self.discView.centerXAnchor).isActive = true
        progressIndicatorView.topAnchor.constraint(equalTo: self.discView.centerYAnchor).isActive = true
        progressIndicatorView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        progressIndicatorView.widthAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    func createDiscView() {
        self.view.addSubview(discView)
        self.discView.delegate = self
        discView.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        discView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        discView.heightAnchor.constraint(equalToConstant: width).isActive = true
        discView.widthAnchor.constraint(equalToConstant: width).isActive = true

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
        self.discView.highlightedShapeLayer?.removeFromSuperlayer()
        self.discView.alreadyHiglighted = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addButtonToSuperView() {
        progressIndicatorView?.isHidden = true
        volumeIndicatorView?.isHidden = true
        
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
        self.progressIndicatorView?.isHidden = false
        self.volumeIndicatorView?.isHidden = false
    }


}
