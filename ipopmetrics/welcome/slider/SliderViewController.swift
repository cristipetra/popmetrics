//
//  SliderViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        let firstView: SlideSecondView = SlideSecondView(frame: CGRect(x: 0, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        var secondView: SlideSecondView = SlideSecondView(frame: CGRect(x: scrollView.size().width, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        
        let thirdView: SlideSecondView = SlideSecondView(frame: CGRect(x: scrollView.size().width * 2, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        let fourthView: SlideSecondView = SlideSecondView(frame: CGRect(x: scrollView.size().width * 3, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        let fifthView: SlideSecondView = SlideSecondView(frame: CGRect(x: scrollView.size().width * 4, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        scrollView.contentSize = CGSize(width: scrollView.size().width * 5, height: scrollView.size().height)
        
        scrollView.addSubview(firstView)
        scrollView.addSubview(secondView)
        scrollView.addSubview(thirdView)
        scrollView.addSubview(fourthView)
        scrollView.addSubview(fifthView)
        
        firstView.setImage(imageName: "swipe1")
        secondView.setImage(imageName: "swipe2")
        thirdView.setImage(imageName: "swipe3")
        fourthView.setImage(imageName: "swipe4")
        fifthView.setImage(imageName: "swipe5")
        
    }

}

extension SliderViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.currentPage)
    }
    
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}
