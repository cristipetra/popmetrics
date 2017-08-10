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
    
    @IBOutlet weak var btnStarted: RoundButton!
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController = AVPlayerViewController();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = PopmetricsColor.yellowBGColor
        
        playLocalVideo()
        NotificationCenter.default.addObserver(self, selector: #selector(VideoScreenViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        playLocalVideo()
        
        btnStarted.addTarget(self, action: #selector(getStartedHandler), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        btnStarted.isUserInteractionEnabled = true
        btnStarted.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
        btnStarted.setTitleColor(UIColor.white, for: .normal)
    }
    
    func playLocalVideo() {
        
        let filePath = Bundle.main.path(forResource: "WelcomeVideo", ofType: ".mov")
        let videoURL = URL(fileURLWithPath: filePath!)
        player = AVPlayer(url: videoURL)
        
    
        playerViewController.player = player
        
        self.containerPlayer.addSubview(playerViewController.view)
        
        setVideoInContainer()
        
        self.present(playerViewController, animated: true) { 
            self.playerViewController.player?.play()
        }
        
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
    func rotated() {
        setVideoInContainer()
    }
    
    internal func setVideoInContainer() {
        playerViewController.view.frame.origin.x = 0
        playerViewController.view.frame.origin.y = 0
        playerViewController.view.frame.size.height = self.containerPlayer.bounds.height
        playerViewController.view.frame.size.width = self.containerPlayer.bounds.width
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "rate") {
            if player.rate == 0.0 {
                btnStarted.isUserInteractionEnabled = true
                btnStarted.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
                btnStarted.setTitleColor(UIColor.white, for: .normal)
            }
        }
        if (keyPath == "status") {
        }
    }
    
    func getStartedHandler() {
        let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        self.present(mainTabVC, animated: false, completion: nil)
    }
    
}
