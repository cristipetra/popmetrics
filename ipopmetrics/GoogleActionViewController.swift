//
//  GoogleActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class GoogleActionViewController: UIViewController {
    
    let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height + 780))
    
    let scrollView: UIScrollView = UIScrollView()
    
    let googleCitationView: GoogleActivationView = GoogleActivationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        
        setUpNavigationBar()
        
        addScrollView()
        addContainerView()
        addContentView()
        
    }
    
    func addContentView() {
        self.containerView.addSubview(googleCitationView)
        googleCitationView.translatesAutoresizingMaskIntoConstraints = false
        googleCitationView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        googleCitationView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
        googleCitationView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
        googleCitationView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Social Post", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addScrollView() {
        self.view.addSubview(scrollView)
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
    }

    func addContainerView() {
        
        self.scrollView.addSubview(containerView)
        /*
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
         */
        scrollView.contentSize = containerView.bounds.size
    }
    
}
