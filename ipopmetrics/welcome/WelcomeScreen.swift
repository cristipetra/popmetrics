//
//  WelcomeScreen.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel
import SafariServices
import Hero
import Reachability

class WelcomeScreen: BaseViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!

    var splashView: LDSplashView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImageView.isHidden = true
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.SignIn, object:nil, queue:nil, using:catchNotificationSignIn)
 
        addShadowToView(blueButton)

        self.logoSplash()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.welcomeViewController = self
        
        backButton.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setScrollView()
    }
    
    func setScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        
        var width = UIScreen.main.bounds.width
        var height = scrollView.size().height
        
        let firstView: SlideFirstView = SlideFirstView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        var secondView: SlideSecondView = SlideSecondView(frame: CGRect(x: width, y: 0, width: width, height: height))
        let thirdView: SlideSecondView = SlideSecondView(frame: CGRect(x: width * 2, y: 0, width: width, height: height))
        let fourthView: SlideSecondView = SlideSecondView(frame: CGRect(x: width * 3, y: 0, width: width, height: height))
        let fifthView: SlideSecondView = SlideSecondView(frame: CGRect(x: width * 4, y: 0, width: width, height: height))
        
        
        scrollView.contentSize = CGSize(width: width * 5, height: 0)
        
        scrollView.addSubview(firstView)
        scrollView.addSubview(secondView)
        scrollView.addSubview(thirdView)
        scrollView.addSubview(fourthView)
        scrollView.addSubview(fifthView)
        
        firstView.setImage(imageName: "swipe1")
        firstView.setTitle("Performance. Enhanced.")
        firstView.setSubtitle("Popmetrics is your automated marketing assistant working for you 24/7. The simplest way to manage and improve your business's presence online.")
        
        secondView.setImage(imageName: "swipe2")
        secondView.setTitle("Intelligent Advice")
        secondView.setSubtitle("Learn how to grow your business with personalized recommendations and step-by-step marketing guides.")
        
        thirdView.setImage(imageName: "swipe3")
        thirdView.setTitle("Brand Expansion")
        thirdView.setSubtitle("Grow your audience by automating your social media channels. Drive more traffic to your website by expanding where you're found online.")

        fourthView.setImage(imageName: "swipe4")
        fourthView.setTitle("Supercharged Performance")
        fourthView.setSubtitle("Track your marketing tasks and measure your progress. Follow the stats that are important to your business.")
        
        fifthView.setImage(imageName: "swipe5")
        fifthView.setTitle("")
        fifthView.setSubtitle("")
    }

    @IBAction func handlerSpoken(_ sender: UIButton) {
        
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        
        self.performSegue(withIdentifier: "signInSegue", sender: self)
    }
    
    @IBAction func handlerDidPressNewButton(_ sender: UIButton) {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        
        self.performSegue(withIdentifier: "signUpSegue", sender: self)

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.openURLInside(self, url: Config.appWebAimeeLink)
    }


    @IBAction func handleBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TEST CODE
        // UserStore.getInstance().phoneNumber = "+40745028869"
        
        if segue.destination is LoginViewController {
            let vc = segue.destination as? LoginViewController
            vc?.isSignupFlow = false
            if UserStore.getInstance().phoneNumber != "" {
                vc?.phoneNumber = UserStore.getInstance().phoneNumber
            }
        }
    }
    
    func catchNotificationSignIn(notification:Notification) -> Void {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        self.performSegue(withIdentifier: "signInSegue", sender: self)
    }
    
}

// MARK : splash logo animation
extension WelcomeScreen {
    func logoSplash() {
        let logoSplashIcon = LDSplashIcon(initWithImage: UIImage(named: "logo")!, animationType: .bounce)
        let iconColor = UIColor.white
        self.splashView = LDSplashView(initWithSplashIcon: logoSplashIcon!, backgroundColor: iconColor, animationType: .none)
        splashView!.delegate = self
        splashView!.animationDuration = 3
        self.view.addSubview(splashView!)
        self.view.bringSubview(toFront: splashView!)
        splashView!.startAnimation()
    }
}

extension WelcomeScreen: BannerProtocol {
    
}

extension WelcomeScreen: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage - 1
    }
    
}

//MARK : - Delegate Methods, implement if you need to know when the animations have started and ended
extension WelcomeScreen: LDSplashDelegate {
    func didBeginAnimatingWithDuration(_ duration: CGFloat) {
        indicatorView?.startAnimating()
    }
    
    func splashViewDidEndAnimating(_ splashView: LDSplashView) {
        indicatorView?.stopAnimating()
        indicatorView?.removeFromSuperview()
    }
}

extension WelcomeScreen {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}


extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}
