//
//  OneOffPaymentViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 02/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Stripe
import EZAlertController
import EZLoadingActivity

class OneOffPaymentViewController: UITableViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var labelCard: UILabel!
    @IBOutlet weak var infoCardView: InfoCardView!
    @IBOutlet weak var textViewTerms: UITextView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var confirmPurchaseButton: UIButton!
    @IBOutlet weak var amountLabel: UITextField!
    var muutableString = NSMutableAttributedString()
    
    var brandId: String?
    var amount: Int?
    var currency: String?
    var paymentContext: STPPaymentContext?
    var planId: String?
    var numberFormatter: NumberFormatter?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    EZLoadingActivity.showLoadingSpinner(disableUI: true)
                    self.confirmPurchaseButton.isEnabled = false
                }
                else {
                    EZLoadingActivity.hide()
                    self.confirmPurchaseButton.isEnabled = true
                }
            }, completion: nil)
        }
    }
    
    func configure(brandId:String, amount: Int, planId: String, currency: String = "usd") {
        self.brandId = brandId
        self.planId = planId
        self.amount = amount
        self.currency = currency
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let brandId = self.brandId,
            let planId = self.planId,
            let amount = self.amount,
            let currency = self.currency else{
                self.navigationController?.popViewController(animated:true)
                return
        }
        
        
        tableView.tableFooterView = UIView()
        emailText.text = UserStore().getLocalUserAccount().email ?? ""
        setUpNavigationBar()
        changeTextColor()
        
        setupPayments(amount: amount, currency:currency)
        
        self.amountLabel.text = self.numberFormatter?.string(from: NSNumber(value: Float((self.paymentContext?.paymentAmount)!)/100))!
        
    }
    
    func setupPayments(amount: Int, currency: String = "usd"){
        let paymentConfig = STPPaymentConfiguration.shared()
        let theme = STPTheme.default()
        let customerContext = STPCustomerContext(keyProvider: self)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: paymentConfig,
                                               theme: theme)
        
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = amount
        paymentContext.paymentCurrency = currency
        
        self.paymentContext = paymentContext
        
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: currency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter
        
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        
    }
    
    func changeTextColor() {
        muutableString = NSMutableAttributedString(string: textViewTerms.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 15.0)!])
        muutableString.addAttribute(.link, value: Config.termsAndConditions, range: NSRange(location: 108, length: 20))
        muutableString.addAttribute(.link, value: Config.privacyPolicy, range: NSRange(location: 132, length: 16))
        textViewTerms.attributedText = muutableString
        
        infoCardView?.resetLabel(label: "Select Payment Method")
    }
    
    private func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Payment Confirmation", style: .plain, target: self, action: #selector(handlerClickBack))
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            openEmail()
        } else if indexPath.row == 3 {
            self.paymentContext?.pushPaymentMethodsViewController()
        }
        
    }
    
    private func openEmail() {
        let emailVC = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        emailVC.emailDelegate = self
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    @objc func handlerClickBack() {
        self.close()
    }
    
    @IBAction func handlerConfirmPurchase(_ sender: UIButton) {
        self.paymentContext?.requestPayment()
    }
    
}

extension OneOffPaymentViewController: EmailProtocol {
    func didSetEmail(_ email: String) {
        emailText.text = email
    }
}

extension OneOffPaymentViewController: STPPaymentContextDelegate{
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        let source = paymentResult.source.stripeID
        guard
            let brandId = self.brandId,
            let planId = self.planId else{
                return
        }
        
        guard let email = self.emailText.text, !email.isEmpty else {
            let alertController = UIAlertController(title: "Email required", message: "Please enter an email address", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        self.paymentInProgress = true
        PaymentApi().subscribe(brandId: brandId, planId: planId, source: source, email: email){(title: String, message: String, success:Bool, done:Bool) in
            self.paymentInProgress = false
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            var action = UIAlertAction(title: "OK", style: .default, handler: {action in
                if success {
                    SyncService.getInstance().syncAll(silent: false)
                    
                }
                if done {
                    self.close()
                }
                
            })
            
            alertController.addAction(action)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.paymentInProgress = paymentContext.loading
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            self.infoCardView.changeLabel(label: paymentMethod.label)
        }
        else {
            self.infoCardView.resetLabel(label: "Select Payment Method")
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        EZLoadingActivity.hide()
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.close()
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OneOffPaymentViewController: STPEphemeralKeyProvider{
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        if let brandId = self.brandId {
            PaymentApi().ephemeralKeys(brandId, apiVersion: apiVersion, completion: completion)
            
        }
    }
}


