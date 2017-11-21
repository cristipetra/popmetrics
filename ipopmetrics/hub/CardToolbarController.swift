//
//  CardToolbarController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString

class CardToolbarController: NSObject {
    
    var toolbarView: ToolbarViewCell!
    
    func setUpTopView(toolbarView: ToolbarViewCell) {
        self.toolbarView = toolbarView
        
        displayViewWithCircle()
    }
    
    func displayViewWithText() {
        toolbarView.isLeftImageHidden = false
        toolbarView.leftImage.image = UIImage(named: "iconAlertMessage")
        toolbarView.leftImage.contentMode = .scaleAspectFit
        toolbarView.backgroundColor = UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1)
        
        let headsUpStyle = Style.default { (style) -> (Void) in
            
            style.font = FontAttribute(FontBook.bold, size: 15)
            style.color = UIColor.white
        }
        
        let requiredAction = Style.default {
            
            $0.font = FontAttribute(FontBook.regular, size: 15)
            $0.color = UIColor.white
        }
        
        let headerTitle = "Heads Up: ".set(style: headsUpStyle) + "Required Action".set(style: requiredAction)
        toolbarView.title.attributedText = headerTitle
    }
    
    func displayViewWithCircle() {
        toolbarView.backgroundColor = PopmetricsColor.salmondColor
        toolbarView.isLeftImageHidden = true
        toolbarView.title.isHidden = true
        toolbarView.setUpCircleBackground(topColor: UIColor(red: 255/255, green: 194/255, blue: 188/255, alpha: 1), bottomColor: UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1))
        
    }
}
