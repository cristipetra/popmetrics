//
//  TableFooterView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

protocol FooterButtonHandlerProtocol: class {
    func approvalButtonPressed()
    func closeButtonPressed()
    func informationButtonPressed()
    func loadMorePressed()
}

class TableFooterView: UITableViewHeaderFooterView {
    
    var loadMoreCount: Int = 0
    var approveCount: Int = 0
    
    var typeSection: TypeSection = .complete {
        didSet {
            changeTypeSection()
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
    
    lazy var loadMoreBtn : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var informationBtn : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
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
    
    lazy var xButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
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
        setUpDoubleButton()
        
        setUpHorizontalStackView()
        
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
        
        horizontalStackView = UIStackView(arrangedSubviews: [xButton,informationBtn,loadMoreStackView,approveStackView])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 16
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(horizontalStackView)
        
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        loadMoreStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    func setUpXButton() {
        
        xButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        xButton.layer.cornerRadius = 23//xButton.frame.size.width / 2
        xButton.clipsToBounds = true
    }
    
    func deleteHandler() {
        
        print("SSS X Button pressed")
        animateButtonBlink(button: xButton)
        
    }
    
    func setUpInformationBtn() {
        
        informationBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.addTarget(self, action: #selector(informationHandler), for: .touchUpInside)
        informationBtn.layer.cornerRadius = 23
    }
    
    func informationHandler() {
        print("SSS information button pressed")
        animateButtonBlink(button: informationBtn)
        
    }
    
    func setUpLoadMore() {
        
        loadMoreBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        loadMoreBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadMoreBtn.addTarget(self, action: #selector(loadMoreHandler), for: .touchUpInside)
        loadMoreBtn.layer.cornerRadius = 23
    }
    
    func loadMoreHandler() {
        print("SSS load more button pressed")
        animateButtonBlink(button: loadMoreBtn)
        buttonHandlerDelegate?.loadMorePressed()
    }
    
    func setUpDoubleButton() {
        
        actionButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        //doubleButton.centerYAnchor.constraint(equalTo: self.approveStackView.centerYAnchor, constant: 20).isActive = true
        //doubleButton.layer.cornerRadius = 22
        //doubleButton.layer.borderColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1).cgColor
        //doubleButton.layer.borderWidth = 1.5
        actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
    }
    
    func approveHandler() {
        animateButtonBlink(button: actionButton)
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
    
    func changeTypeSection() {
        switch typeSection {
        case .failed:
            actionButton.imageButtonType = .failed
        case .unapproved:
            actionButton.imageButtonType = .unapproved
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
