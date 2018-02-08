//
//  NameViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 06/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var constraintCenterYcontainer: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    internal var registerBrand: RegisterBrand = RegisterBrand()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismissKeyboard)
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        btnSubmit.isEnabled = false
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nameTextField.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let logoImageView = UIImageView(image: UIImage(named: "logoPop"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = logoImageView
        
        self.navigationItem.titleView = logoImageView
        let backButton = UIBarButtonItem(image: UIImage(named: "login_back"), style: .plain, target: self, action: #selector(dismissView))
        backButton.tintColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        backButton.setTitlePositionAdjustment(UIOffset.init(horizontal: -55, vertical: 0), for: .default)
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 15
        
        self.navigationItem.leftBarButtonItems = [leftSpace, backButton]
        
    }
    
    private func openNextScreen(_ name: String) {
        let websiteVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "WebsiteViewController") as! WebsiteViewController
        registerBrand.name = name
        websiteVC.registerBrand = registerBrand
        self.navigationController?.pushViewController(websiteVC, animated: true)
    }
    
    // MARK: handlers
    @objc internal func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    @objc internal func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlerSubmit(_ sender: UIButton) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            btnSubmit.isEnabled = false
            return
        }
        
        openNextScreen(name)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            btnSubmit.isEnabled = false
            return
        }
        btnSubmit.isEnabled = true

    }
    
}

// MARK: UITextFieldDelegate
extension NameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintCenterYcontainer.constant = -80
            self.view.layoutIfNeeded()
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {
            self.constraintCenterYcontainer.constant = 0
            self.view.layoutIfNeeded()
        })
    }

}
