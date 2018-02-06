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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismissKeyboard)
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        btnSubmit.isEnabled = false
        
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnSubmit.isEnabled = false
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
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func openNextScreen() {
        let websiteVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "WebsiteViewController") as! WebsiteViewController
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
        // TODO: Add api
        
        openNextScreen()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.contains(" "))! {
            btnSubmit.isEnabled = true
        } else {
            btnSubmit.isEnabled = false
        }
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
