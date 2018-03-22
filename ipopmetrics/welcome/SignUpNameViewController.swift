//
//  NameViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 06/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SignUpNameViewController: BaseViewController {

    @IBOutlet weak var constraintCenterYcontainer: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var btnSubmitName: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.autocapitalizationType = .words
        
        hero.isEnabled = false
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        btnSubmitName.isEnabled = false
        setNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    // MARK: handlers
    @objc internal func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    @objc internal func dismissView() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            btnSubmitName.isEnabled = false
            return
        }
        btnSubmitName.isEnabled = true
    
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            return false
        }
        
        (self.navigationController as! BoardingNavigationController).registerBrand.name = name
        
        return true
    }
    
    
}

// MARK: UITextFieldDelegate
extension SignUpNameViewController: UITextFieldDelegate {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
