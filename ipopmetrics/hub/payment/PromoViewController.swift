//
//  PromoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController {
    
    let promoCodeMask = "###-##"
    lazy fileprivate var editableCodeMask = promoCodeMask

    @IBOutlet weak var termsAndConditionsText: UILabel!
    @IBOutlet weak var promoCodeText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnApplyCode: UIButton!
    var mutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.promoCodeText.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        setUpNavigationBar()
        changeTextColor()
        
        self.termsAndConditionsText.isHidden = true
        
        btnApplyCode.setTitleColor(PopmetricsColor.weekDaysGrey, for: .disabled)
        btnApplyCode.isEnabled = false
        
        promoCodeText.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        updateDigitFieldNumber(textField: promoCodeText, mask: promoCodeMask)
        
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
    
    @IBAction func handlerApplyCode(_ sender: UIButton) {
        close()
    }
    
    private func close() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PromoViewController: UITextFieldDelegate {
    
    func updateDigitFieldNumber(textField: UITextField, mask: String) {
        let threshold = mask.range(for: "#")?.lowerBound ?? mask.range!.upperBound
        let boldRange = Range(uncheckedBounds: (lower: mask.range!.lowerBound, upper: threshold))
        textField.attributedText = mask.replacingOccurrences(of: "#", with: "0").attributed
            .font(UIFont(name: FontBook.regular, size: 24)!)
            .color(.lightGray)
            .font(UIFont(name: FontBook.bold, size: 24)!, range: boldRange)
            .color(PopmetricsColor.buttonTitle, range: boldRange)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            guard let lastDigitRange = editableCodeMask.findMatches(for: "[0-9]").last?.range else { return false }
            editableCodeMask = editableCodeMask
                .replacingCharacters(in: Range(lastDigitRange, in: editableCodeMask)!, with: "#")
        } else {
            guard let slot = editableCodeMask.range(for: "#") else { return false }
            editableCodeMask = editableCodeMask.replacingCharacters(in: slot, with: string)
        }
        updateDigitFieldNumber(textField: textField, mask: editableCodeMask)
        updateCursorPosition(textField: textField)
        btnApplyCode.isEnabled = extractCode(text: editableCodeMask).count >= 5
        return false
    }
    
    func extractCode(text: String) -> String {
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    private func updateCursorPosition(textField: UITextField) {
        guard let lastDigitRange = editableCodeMask.findMatches(for: "[+0-9]").last?.range else { return }
        let slotPosition = Range(lastDigitRange, in: phoneNumberMask)!.upperBound.encodedOffset
        let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: slotPosition)!
        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
    }
   
    @objc func textFieldDidChanged(_ textField: UITextField) {
        btnApplyCode.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIScreen.main.bounds.size.height > 568 { return }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if UIScreen.main.bounds.size.height > 568 { return }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
