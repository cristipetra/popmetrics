//
//  PromoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController {

    @IBOutlet weak var termsAndConditionsText: UILabel!
    @IBOutlet weak var promoCodeText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.promoCodeText.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        setUpNavigationBar()
        changeTextColor()
    }
    
    @objc internal func dismissKeyboard() {
        
        promoCodeText.resignFirstResponder()
    }
    
    private func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Use Promo Code", style: .plain, target: self, action: #selector(handlerClickBack))
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func changeTextColor() {
        mutableString = NSMutableAttributedString(string: termsAndConditionsText.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 15.0)!])
        mutableString.addAttribute(.link, value: Config.termsAndConditions, range: NSRange(location: 0, length: (termsAndConditionsText.text?.characters.count)!))
        termsAndConditionsText.attributedText = mutableString
    }
    
    @objc func handlerClickBack() {
        self.close()
    }
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PromoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if UIScreen.main.bounds.size.height > 568 { return }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
        if UIScreen.main.bounds.size.height > 568 { return }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
