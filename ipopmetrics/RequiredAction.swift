//
//  RequiredAction.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit
import SwiftRichString
import TwitterKit
import NotificationBannerSwift

class RequiredAction: UITableViewCell {
    
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var connectionLineView: UIView!
    
    
    var item: FeedItem?
    var actionHandler: CardActionHandler?
    var indexPath: IndexPath?
    var delegate: InfoButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTopView()
        setupCorners()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        self.item = item
        self.actionHandler = handler
        
        
    
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.titleLabel.text  = item.headerTitle
        messageLabel.text = item.message
        
        
        //Todo move from here addTarget
        if(item.actionLabel == "Notifications") {
            footerView.actionButton.imageButtonType = .allowNotification
            self.footerView.actionButton.addTarget(self, action:#selector(handleActionNotifications(_:)), for: .touchDown)
        } else {
            self.footerView.actionButton.addTarget(self, action:#selector(handleActionTwitter(_:)), for: .touchDown)
            self.footerView.informationBtn.addTarget(self, action: #selector(handleInfoButtonPressed), for: .touchDown)
        }
        
        
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: FontBook.alfaRegular, size: 20)
        
        titleLabel.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
    }
    
    func setMessage(message: String) {
        titleLabel.text = message
        titleLabel.font = UIFont(name: FontBook.semibold, size: 15)
        titleLabel.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        
    }
    
    func setUpTopView() {
        
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
        
        let headerTitle = "Heads Up:".set(style: headsUpStyle) + "Required Action".set(style: requiredAction)
        toolbarView.title.attributedText = headerTitle
    }
    
    func handleActionNotifications(_ sender: SimpleButton) {
        UIApplication.shared.open(URL(string: Config.howToTurnNotificationLink)!, options: [:], completionHandler: nil)
    }
    
    @objc func handleActionTwitter(_ sender: SimpleButton) {
        //self.actionButton.isLoading = true
        //actionHandler?.handleRequiredAction(sender, item: self.item!)
        connectTwitter(sender, item: self.item!)
    }
    
    func connectTwitter(_ sender: SimpleButton, item:FeedItem) {
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                FeedApi().connectTwitter(userId: (session?.userID)!, brandId:"58fe437ac7631a139803757e", token: (session?.authToken)!,
                                         tokenSecret: (session?.authTokenSecret)!) { responseDict, error in
                                            //sender.isLoading = false
                                            if error != nil {
                                                let nc = NotificationCenter.default
                                                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                                                        object: nil,
                                                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed.", "date":Date()])
                                                return
                                            } // error != nil
                                            else {
                                                sender.setTitle("Connected.", for: .normal)
                                                UsersStore.isTwitterConnected = true
                                                self.showBanner(bannerType: .success)
                                            }
                } // usersApi.logInWithGoogle()
                
            } else {
                //sender.isLoading = false
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                        object: nil,
                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed... \(error!.localizedDescription)", "date":Date()])
                
            }
        }
        
    }
    
    private func showBanner(bannerType: BannerType) {
        let banner: NotificationBanner!
        switch bannerType {
        case .success:
            let title = "Authentication Success!"
            let titleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 12),
                NSForegroundColorAttributeName: PopmetricsColor.darkGrey]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [String : Any]))
            let subtitle = "Twitter Connected"
            let subtitleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSForegroundColorAttributeName: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [String : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.greenMedium
            break
        case .failed:
            let title = "Authentication Failed"
            let titleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 12),
                NSForegroundColorAttributeName: PopmetricsColor.notificationBGColor]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [String : Any]))
            let subtitle = "Twitter failed to connect! Try again"
            let subtitleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSForegroundColorAttributeName: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [String : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.salmondColor
            break
        default:
            break
        }
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            banner.dismiss()
        }
    }
    
    
    @objc func handleInfoButtonPressed() {
        showBanner(bannerType: .failed)
    }
    
}

enum BannerType {
    case success
    case failed
}
