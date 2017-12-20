//
//  AnimationsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Lottie

class AnimationsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let animationView = LOTAnimationView(name: AnimationInfo.getAnimationName())
    var numberOfTabs = 11 as CGFloat
    
    let welcomeVC = WelcomeScreen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopAnimation = true
        
        self.view.insertSubview(animationView, belowSubview: scrollView)
        
        setupScrollView()
    }

    func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let progress = translation.x / self.view.bounds.size.width
        
        animationView.animationProgress = progress
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * numberOfTabs, height: UIScreen.main.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            let progress = numberOfTabs * (scrollView.contentOffset.x / scrollView.contentSize.width) / (numberOfTabs - 1)
            print(progress)
            animationView.animationProgress = progress
            if progress == 1 {
                //self.presentFromDirection(viewController: welcomeVC, direction: .right)
                self.present(welcomeVC, animated: true, completion: {
                    self.resetAnimation()
                })
            }
        }
    }
    
    internal func resetAnimation() {
        animationView.animationProgress = 0
        scrollView.contentOffset.x = 0
    }
    
    @IBAction func skipAnimation(_ sender: UIButton) {
        self.presentFromDirection(viewController: welcomeVC, direction: .right)
        resetAnimation()
    }
    
    @IBAction func handlerCloseButton(_ sender: UIButton) {
        self.dismissToDirection(direction: .left)
    }
    
}

class AnimationInfo {
    static func getAnimationName() -> String {
        var isIphoneX = false
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                isIphoneX = true
            }
        }
        if isIphoneX {
            return "animation_X"
        } else if UIScreen.main.bounds.height <= 480 {
            return "animation_iphone4"
        } else {
            return "animation_nonX"
        }
    }
    
}
