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
        
        playerViewController.view.frame = self.containerPlayer.bounds
        
        setVideoInContainer();
        
        self.present(playerViewController, animated: true) { 
            self.playerViewController.player?.play()
        }
        self.view.addSubview(playerViewController.view)
        
        
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
    internal func setVideoInContainer() {
        var height = 180
        let heightDevice = UIScreen.main.bounds.size.height
        if heightDevice >= 568 && heightDevice < 667  {
            height = 220
        } else {
            height = 280
        }
        
        playerViewController.view.frame.origin.x = self.containerPlayer.frame.origin.x
        playerViewController.view.frame.origin.y = self.containerPlayer.frame.origin.y
        playerViewController.view.frame.size.width = UIScreen.main.bounds.size.width;
        playerViewController.view.frame.size.height = CGFloat(height)
        
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
