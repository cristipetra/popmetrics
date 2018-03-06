//
//  PaymentTableViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 01/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Stripe

class PaymentTableViewController: UITableViewController {

    @IBOutlet weak var labelCard: UILabel!
    @IBOutlet weak var infoCardView: InfoCardView!
    @IBOutlet weak var textViewTerms: UITextView!
    @IBOutlet weak var lblTerms: UILabel!
    var muutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        changeTextColor()
    }
    
    func changeTextColor() {
        muutableString = NSMutableAttributedString(string: textViewTerms.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 15.0)!])
        muutableString.addAttribute(.link, value: "https://www.popmetrics.io", range: NSRange(location: 108, length: 20))
        muutableString.addAttribute(.link, value: "https://www.popmetrics.io", range: NSRange(location: 132, length: 16))
        textViewTerms.attributedText = muutableString
        
        
        infoCardView.changeTextColor()
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
        if indexPath.row == 3 {
            openAddCard()
        } else if indexPath.row == 4 {
            sendCard()
        }
        
    }
    
    func sendCard() {
        let cardParams = STPCardParams()
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2019
        cardParams.cvc = "123"
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            guard let token = token, error == nil else {
                print("error")
                return
            }
            print("submit token to backend")
            /*
            submitTokenToBackend(token, completion: { (error: Error?) in
                if let error = error {
                    // Present error to user...
                    print("eror to submit token")
                }
                else {
                    // Continue with payment...
                    print("success")
                }
            })
             */
        }
    }
    
    private func openAddCard() {
        let config = STPPaymentConfiguration.shared()
        let theme = STPTheme.default()
        let customerContext = MockCustomerContext()
        config.createCardSources = true
    
        let cardVC = STPPaymentMethodsViewController(configuration: config,
                                                             theme: theme,
                                                             customerContext: customerContext,
                                                             delegate: self)
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        self.navigationController?.pushViewController(cardVC, animated: true)
        //self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PaymentTableViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateSource source: STPSource, completion: @escaping STPErrorBlock) {
    }
    
    
}

extension PaymentTableViewController: STPPaymentMethodsViewControllerDelegate {
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        paymentMethodsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: STPShippingAddressViewControllerDelegate
    
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
