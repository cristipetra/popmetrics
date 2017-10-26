//
//  TodoPostDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TodoPostDetailsViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var messageLabel: UITextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont(name: FontBook.regular, size: 15)
        textView.textAlignment = .left
        textView.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        return textView
    }()
    
    lazy var buttonContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var separatorView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        return view
    }()
    
    lazy var denyPostBtn: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(PopmetricsColor.salmondColor, for: .normal)
        button.setTitle("Deny Post", for: .normal)
        return button
    }()
    
    lazy var approvePostBtn: TwoColorButton = {
        
        let button = TwoColorButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let postDetailsView = TodoPostDetailsView()
    
    weak var socialDelegate: ActionSocialPostProtocoll?
    var indexPath: IndexPath!
    
    private var toDoPost: TodoSocialPost! {
        didSet {
            postDetailsView.configureView(socialPost: toDoPost)
            messageLabel.text = toDoPost.articleText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPostDetails()
        addBottomButtons()
        addTextView()
        
        addStyleToButtons()
        setUpNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure(todoItem: TodoSocialPost,indexPath: IndexPath) {
        self.toDoPost = todoItem
        self.indexPath = indexPath
    }
    
    func addPostDetails() {
        
        containerView.addSubview(postDetailsView)
        postDetailsView.translatesAutoresizingMaskIntoConstraints = false
        postDetailsView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        postDetailsView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        postDetailsView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        postDetailsView.heightAnchor.constraint(equalToConstant: 550).isActive = true
        
    }
    
    func addBottomButtons() {
        
        containerView.addSubview(buttonContainerView)
        
        buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        buttonContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        buttonContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        buttonContainerView.addSubview(denyPostBtn)
        buttonContainerView.addSubview(approvePostBtn)
        buttonContainerView.addSubview(separatorView)
        
        denyPostBtn.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 30).isActive = true
        denyPostBtn.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 18).isActive = true
        denyPostBtn.widthAnchor.constraint(equalToConstant: 79).isActive = true
        denyPostBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        approvePostBtn.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor, constant: -24).isActive = true
        approvePostBtn.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 12).isActive = true
        approvePostBtn.widthAnchor.constraint(equalToConstant: 161).isActive = true
        approvePostBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0).isActive = true
        separatorView.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        denyPostBtn.addTarget(self, action: #selector(denyPost(sender:)), for: .touchUpInside)
        approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
        
        
    }
    
    func denyPost(sender: UIButton) {
        socialDelegate?.denyPostFromSocial(post: self.toDoPost, indexPath: self.indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    func approvePost(sender: TwoColorButton) {
        socialDelegate?.approvePostFromSocial(post: self.toDoPost, indexPath: self.indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Social Post", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
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
    
    
    func addTextView() {
        
        containerView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: postDetailsView.bottomAnchor, constant: 0).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 25).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor,constant: 0).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
    }
    
    private func addStyleToButtons() {
        
        denyPostBtn.titleLabel?.font = UIFont(name: FontBook.bold, size: 15)
        approvePostBtn.setTitleColor(PopmetricsColor.todoBrown, for: .normal)
        
        let topColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        let bottomColor = UIColor(red: 251/255, green: 192/255, blue: 46/255, alpha: 1)
        let colors: [UIColor] = [topColor , bottomColor]
        
        approvePostBtn.layer.masksToBounds = true
        approvePostBtn.layer.cornerRadius = 18
        setupTwoColorView(button: approvePostBtn, colors: colors)
        approvePostBtn.labelText = "Approve Post"
        approvePostBtn.image = UIImage(named: "iconRightYellow")
        
    }
    
    private func setupTwoColorView(button: UIButton, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 161, height: 35)
        
        var colorsArray: [CGColor] = []
        var locationsArray: [NSNumber] = []
        for (index, color) in colors.enumerated() {
            // append same color twice
            colorsArray.append(color.cgColor)
            colorsArray.append(color.cgColor)
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index)))
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index + 1)))
        }
        
        gradientLayer.colors = colorsArray
        gradientLayer.locations = locationsArray
        
        button.layer.addSublayer(gradientLayer)
        
    }
}

protocol ActionSocialPostProtocoll: class {
    func denyPostFromSocial(post: TodoSocialPost,indexPath: IndexPath)
    
    func approvePostFromSocial(post: TodoSocialPost,indexPath: IndexPath)
    
}
