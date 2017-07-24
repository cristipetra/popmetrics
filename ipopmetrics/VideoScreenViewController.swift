//
//  VideoScreenViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoScreenViewController: UIViewController {
    
    @IBOutlet weak var containerPlayer: UIView!
    var player: AVPlayer?
    var playerController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        
        setupVideoPlayer()
        
    }
    
    internal func setupVideoPlayer() {
        self.playerController.contentOverlayView?.backgroundColor = UIColor.red
        
        let videoString: String? = Bundle.main.path(forResource: "WelcomeVideo", ofType: ".mov")
        
        if let url = videoString {
            let videoUrl = URL(fileURLWithPath: url)
            self.player = AVPlayer(url: videoUrl)
            self.playerController.player = self.player
        }
        
        self.playerController.view.frame = self.containerPlayer.bounds
        self.playerController.view.frame.origin.x = self.containerPlayer.frame.origin.x
        self.playerController.view.frame.origin.y = self.containerPlayer.frame.origin.y
        
        playerController.showsPlaybackControls = true
        
        self.view.addSubview(playerController.view)
        self.showDetailViewController(self.playerController, sender: self)
        
        player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "rate") {
            self.playerController.view.frame = self.view.bounds
        }
        if (keyPath == "status") {
        }
    }
    
}
