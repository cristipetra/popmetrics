//
//  TrialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 02/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Upgrade!", style: .plain, target: self, action: #selector(handlerClickBack))
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconX"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = .black
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openPromo() {
        let promoVc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PromoViewController")
        
        self.navigationController?.pushViewController(promoVc, animated: true)
    }
    
    private func openPopup() {
        let alertCard = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentPopupViewController") as! PaymentPopupViewController
        
        alertCard.providesPresentationContextTransitionStyle = true
        alertCard.definesPresentationContext = true
        alertCard.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertCard.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alertCard.delegate = self
        self.present(alertCard, animated: true, completion: nil)
    }

    @IBAction func handlerBtnSubscription(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentTableViewController") as! PaymentTableViewController

        let brandId = UserStore.currentBrandId
        let planId = Config.sharedInstance.environment.stripeBasicPlanId
        let amount = Config.sharedInstance.environment.stripeBasicPlanAmount
        vc.configure(brandId:brandId, amount:amount, planId:planId)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension TrialViewController: PopupAlertViewDelegate {
    func goToHome() {
        
    }
}
