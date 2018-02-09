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

    override func viewDidLoad() {
        super.viewDidLoad()
        if MPMediaLibrary.authorizationStatus() == .notDetermined {
            MPMediaLibrary.requestAuthorization({ (_) in
                print("HopeFully it is authorized")
            })
        } else {
            checkWhatAllAreAvailable()
        }
    }
    
    func checkWhatAllAreAvailable() {
        let myPlaylistQuery = MPMediaQuery.albums()
        let playlists = myPlaylistQuery.collections
        print(playlists![0].items)
        for playlist in playlists! {
            print(playlist.items.count)
            print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
            
            let songs = playlist.items
            for song in songs {
                let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
                print("\t\t", songTitle!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

