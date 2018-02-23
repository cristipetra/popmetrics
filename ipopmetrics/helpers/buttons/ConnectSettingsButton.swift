//
//  ConnectSettingsButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 21/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class ConnectSettingsButton: UIButton {
    
    var titleConnect: String = "Connect Social Account" {
        didSet {
            updateView()
        }
    }
    
    var titleDisconnect: String = "Disconnect Social Account" {
        didSet {
            updateView()
        }
    }
    
    public enum TypeButtonSettings {
        case connect
        case disconnect
    }
    
    var typeButton: TypeButtonSettings = .connect {
        didSet {
            updateView()
        }
    }
    
    internal func updateView() {
        switch typeButton {
        case .connect:
            displayConnectView()
            break
        case .disconnect:
            displayDisconnectView()
            break
        }
    }
    
    private func displayConnectView() {
        self.setTitleColor(PopmetricsColor.blueURLColor, for: .normal)
        self.titleLabel?.font = UIFont(name: FontBook.semibold, size: 17)
        self.setTitle(titleConnect, for: .normal)
    }
    
    private func displayDisconnectView() {
        self.setTitleColor(PopmetricsColor.salmondColor, for: .normal)
        self.titleLabel?.font = UIFont(name: FontBook.regular, size: 17)
        self.setTitle(titleDisconnect, for: .normal)
    }
}
