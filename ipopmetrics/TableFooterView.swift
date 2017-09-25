//
//  TableFooterView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString

protocol FooterButtonHandlerProtocol: class {
    func approvalButtonPressed(section: Int)
    func closeButtonPressed()
    func informationButtonPressed()
    func loadMorePressed(section: Int)
}

protocol FooterActionHandlerProtocol: class {
    func handlerAction(section: Int)
}


class TableFooterView: UITableViewHeaderFooterView {
    
    let SPACE_ELEMENTS: CGFloat = 15
    
    var loadMoreCount: Int = 0
    var approveCount: Int = 0
    var emptyView: UIView!
    
    var section = 0
    
    var typeSection: StatusArticle = .completed {
        didSet {
            changeTypeSection(typeSection: typeSection)
        }
    }
    
    weak var buttonHandlerDelegate: FooterButtonHandlerProtocol?
    weak var buttonActionHandler: FooterActionHandlerProtocol?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.feedBackgroundColor()
        setUpFooter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // VIEW
    lazy var footerShadow : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loadMoreBtn : RoundButton = {
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var informationBtn : RoundButton = {
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var containerView : UIView = {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        return container
    }()
    
    lazy var actionButton : TwoImagesButton = {
        
        let button = TwoImagesButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    lazy var xButton: RoundButton = {
        
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loadMoreLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Load More"
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        return label
        
    }()
    
    lazy var approveLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.text = "Approve all (3)"
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        return label
        
    }()
    
    
    private var horizontalStackView: UIStackView!
    var loadMoreStackView: UIStackView!
    var approveStackView: UIStackView!
    
    // END VIEW
    
    func setUpFooter() {
        
        contentView.addSubview(containerView)
        setContainerView()
        
        setTopLineView()
        setUpLoadMoreStackView()
        setUpApproveStackView()
        
        setUpXButton()
        setUpInformationBtn()
        setUpLoadMore()
        setupActionButton()
        
        setUpHorizontalStackView()
        setupEmptyView()
        
    }
    
    func setContainerView() {
        containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        setupCorners()
    }
    
    func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
        }
    }
    
    func setTopLineView() {
        contentView.addSubview(topLineView)
        topLineView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
        topLineView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        topLineView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLineView.backgroundColor = PopmetricsColor.separatorColor
    }
    
    func setUpLoadMoreStackView() {
        
        loadMoreStackView = UIStackView(arrangedSubviews: [loadMoreBtn, loadMoreLbl])
        loadMoreStackView.axis = .vertical
        loadMoreStackView.distribution = .equalSpacing
        loadMoreStackView.alignment = .center
        loadMoreStackView.spacing = 2
        loadMoreStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpApproveStackView() {
        
        approveStackView = UIStackView(arrangedSubviews: [actionButton, approveLbl])
        approveStackView.axis = .vertical
        approveStackView.distribution = .equalSpacing
        approveStackView.alignment = .center
        approveStackView.spacing = 2
        approveStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpHorizontalStackView() {
        
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, informationBtn, loadMoreStackView])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = SPACE_ELEMENTS
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(horizontalStackView)
        
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        loadMoreStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(approveStackView)
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        approveStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
    }
    
    func setupEmptyView() {
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 46))
        emptyView.widthAnchor.constraint(equalToConstant: 90)
        emptyView.backgroundColor = UIColor.blue
        emptyView.isHidden = true
    }
    
    func setUpXButton() {
        
        xButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        xButton.layer.cornerRadius = 23//xButton.frame.size.width / 2
        
        xButton.setImage(UIImage(named: "iconCtaClose"), for: .normal)
    }
    
    func deleteHandler() {
        animateButtonBlink(button: xButton)
    }
    
    func setUpInformationBtn() {
        
        informationBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.addTarget(self, action: #selector(informationHandler), for: .touchUpInside)
        
        //informationBtn.setImage(UIImage(named: "iconInfoPage")?.withRenderingMode(.alwaysOriginal), for: .normal
        
        let attrTitle = Style.default {
            
            $0.font = FontAttribute(FontBook.regular, size: 30)
            $0.color = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        }
        informationBtn.setAttributedTitle("i".set(style: attrTitle), for: .normal)
        
        informationBtn.layer.cornerRadius = 23
    }
    
    func informationHandler() {
        animateButtonBlink(button: informationBtn)
    }
    
    func setUpLoadMore() {
        loadMoreBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        loadMoreBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadMoreBtn.addTarget(self, action: #selector(loadMoreHandler), for: .touchUpInside)
        loadMoreBtn.setImage(UIImage(named: "iconLoadMore"), for: .normal)
        loadMoreBtn.layer.cornerRadius = 23
        
    }
    
    func loadMoreHandler() {
        animateButtonBlink(button: loadMoreBtn)
        buttonHandlerDelegate?.loadMorePressed(section: section)
        buttonActionHandler?.handlerAction(section: section)
    }
    
    func setupActionButton() {
        
        actionButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        actionButton.tintColor = PopmetricsColor.darkGrey
        actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
    }
    
    func approveHandler() {
        animateButtonBlink(button: actionButton)
        buttonHandlerDelegate?.approvalButtonPressed(section: self.section)
    }
    
    func animateButtonBlink(button: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            button.alpha = 0.0
        }) { (completion) in
            button.alpha = 1.0
        }
    }
    
    func hideLoadMoreButton() {
        loadMoreStackView.isHidden = true
        //horizontalStackView.insertArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46)), at: 3)
    }
    
    func hideInformationButton() {
        informationBtn.isHidden = true
        //horizontalStackView.insertArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46)), at: 2)
    }
    
    func changeTypeSection(typeSection: StatusArticle) {
        print("--type:")
        print(typeSection)
        switch typeSection {
        case .failed:
            actionButton.imageButtonType = .failed
            approveLbl.text = "Reschedule All (1)"
            
        case .unapproved:
            actionButton.imageButtonType = .unapproved
            approveLbl.text = "Schedule All (3)"
        default:
            break
        }
    }
    
    func changeFeedType(feedType: FeedType) {
        switch feedType {
        case .calendar:
            DispatchQueue.main.async {
                self.approveStackView.alpha = 0.0
            }
        default:
            break
            
        }
    }
    
    func setUpDisabledLabels() {
        approveLbl.layer.opacity = 0.3
        approveLbl.text = (section == 0)  ? "Approve (0)" : "Reschedule All (0)"
        
        loadMoreLbl.layer.opacity = 0.3
        loadMoreLbl.text = "Load More (0)"
    }
    
    func setUpLoadMoreDisabled() {
        loadMoreBtn.imageView?.layer.opacity = 0.3
        loadMoreLbl.layer.opacity = 0.3
        loadMoreBtn.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        loadMoreBtn.isEnabled = false
    }
    
    func setUpFooterShadowView() {
        contentView.insertSubview(footerShadow, belowSubview: containerView)
        footerShadow.backgroundColor = containerView.backgroundColor
        footerShadow.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        footerShadow.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        footerShadow.topAnchor.constraint(equalTo:  containerView.topAnchor).isActive = true
        footerShadow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        footerShadow.layer.masksToBounds = false
        addShadowToView(footerShadow, radius: 2, opacity: 0.5)
        footerShadow.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        footerShadow.layer.cornerRadius = 12
    }
    
    func setLabelText(section: Int, value: Int) {
        switch section {
        case 0:
            approveLbl.text = "Approve all (\(value))"
            break
        case 1:
            approveLbl.text = "Reschedule all (\(value))"
            break
        default:
            break
        }
    }
}


enum TypeSection {
    case failed
    case unapproved
    case complete
}

enum FeedType {
    case home
    case todo
    case calendar
    case statistics
}
