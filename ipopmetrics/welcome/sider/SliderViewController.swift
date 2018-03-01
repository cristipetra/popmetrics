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
        
        var firstView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        firstView.backgroundColor = .red
        
        var secondView: UIView = UIView(frame: CGRect(x: scrollView.size().width, y: 0, width: UIScreen.main.bounds.width, height: scrollView.size().height))
        secondView.backgroundColor = .green
        
        let thirdView: SlideSecondView = SlideSecondView(frame: CGRect(x: scrollView.size().width * 2, y: 0, width: scrollView.size().width, height: scrollView.size().height))
        
        scrollView.contentSize = CGSize(width: scrollView.size().width * 3, height: scrollView.size().height)
        
        scrollView.addSubview(firstView)
        scrollView.addSubview(secondView)
        scrollView.addSubview(thirdView)
    }

}

extension SliderViewController: UIScrollViewDelegate {
    
}
