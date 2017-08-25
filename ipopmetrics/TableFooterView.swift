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
    func loadMorePressed()
}


class TableFooterView: UITableViewHeaderFooterView {
    
    let SPACE_ELEMENTS: CGFloat = 15
    
    var loadMoreCount: Int = 0
    var approveCount: Int = 0
    var emptyView: UIView!
    
    var section = 0
    
    var typeSection: StatusArticle = .complete {
        didSet {
            changeTypeSection(typeSection: typeSection)
        }
    }
    
    weak var buttonHandlerDelegate: FooterButtonHandlerProtocol?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.feedBackgroundColor()
        setUpFooter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // VIEW
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
        
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, informationBtn, loadMoreStackView, approveStackView])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = SPACE_ELEMENTS
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(horizontalStackView)
        
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        loadMoreStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
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
        buttonHandlerDelegate?.loadMorePressed()
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
        case .unapproved:
            actionButton.imageButtonType = .unapproved
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
        approveLbl.text = "Approve (0)"
        
        loadMoreLbl.layer.opacity = 0.3
        loadMoreLbl.text = "Load More (0)"
    }
    
    func setUpLoadMoreDisabled() {
        loadMoreBtn.isEnabled = false
        loadMoreBtn.imageView?.layer.opacity = 0.3
        loadMoreBtn.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        
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
}
