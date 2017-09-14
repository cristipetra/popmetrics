//
//  StatusCardTypeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 08/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatusCardTypeView: UIView {
    
    enum TypeStatusView {
        case approved
        case denied
    }
    
    var typeStatusView: TypeStatusView = .approved {
        didSet {
            changeStatusTypeView()
        }
    }
    
    // View
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.darkGrey.withAlphaComponent(0.8)
        return view
    }()
    
    lazy var infoBtn: TwoImagesButton = {
        let button = TwoImagesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.backgroundColor = UIColor(red: 54/255, green: 172/255, blue: 130/255, alpha: 1)
        button.layer.borderWidth = 0
        return button
    }()
    // End Elements from view
    
    //When creating the view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //When creating the view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addContentView()
        addApprovedBtn()
        changeStatusTypeView()
    }
    
    //Add views
    private func addContentView() {
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        DispatchQueue.main.async {
            //self.contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10);
        }
        
    }
    
    private func addApprovedBtn() {
        self.contentView.addSubview(infoBtn)
        infoBtn.translatesAutoresizingMaskIntoConstraints = false
        infoBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        infoBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        infoBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        infoBtn.heightAnchor.constraint(equalToConstant: 39).isActive = true
        infoBtn.layer.cornerRadius = 6
        infoBtn.imageButtonType = .approved
    }
    
    internal func changeStatusTypeView() {
        typeStatusView == .approved ? displayApproved() : displayDenied()
    }
    
    internal func displayApproved() {
        infoBtn.imageButtonType = .approved
        infoBtn.backgroundColor = PopmetricsColor.greenBtn
    }
    
    internal func displayDenied() {
        infoBtn.imageButtonType = .denied
        infoBtn.backgroundColor = PopmetricsColor.salmondColor
    }
    
}
