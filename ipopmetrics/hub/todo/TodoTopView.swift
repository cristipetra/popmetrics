//
//  TodoTopView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class IndicatorTopView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "icon_todo_unapproved_unselected")!
        return imageview
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.text = "(0)"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.addSubview(imageView)
        self.addSubview(countLabel)
        
        addConstraints()
    }
    
    private var imageWidth: CGFloat = 30
    private var imageHeight: CGFloat = 30
    
    private func addConstraints() {
        self.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        countLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        countLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    internal func changeImage(_ imageName: String) {
        self.imageView.image = UIImage(named: imageName)
    }
    
    internal func changeValue(_ value: Int) {
        self.countLabel.text = "(\(value))"
    }
}

@IBDesignable
class TodoTopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView(view: .unapproved)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView(view: .unapproved)
    }

    lazy var viewDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView : UIStackView!
    
    internal var firstIndicatorTop: IndicatorTopView!
    internal var secondIndicator: IndicatorTopView!
    internal var thirdIndicator: IndicatorTopView!
    internal var fourthIndicator: IndicatorTopView!
    
    internal var views: [IndicatorTopView] = []
    
    
    
    let imagesSelected: [String] = ["icon_todo_unapproved_selected", "icon_todo_myactions_selected", "icon_todo_paidactions_selected", "icon_todo_more_selected"]
    let imagesUnselected: [String] = ["icon_todo_unapproved_unselected", "icon_todo_myactions_unselected", "icon_todo_paidactions_unselected", "icon_todo_more_unselected"]
    
    func setUpView(view: StatusArticle) {
        
        firstIndicatorTop = IndicatorTopView()
        
        secondIndicator = IndicatorTopView()
        secondIndicator.changeImage(imagesUnselected[1])
        
        thirdIndicator = IndicatorTopView()
        thirdIndicator.changeImage(imagesUnselected[2])
        
        fourthIndicator = IndicatorTopView()
        fourthIndicator.changeImage(imagesUnselected[3])
        
        views = [firstIndicatorTop, secondIndicator, thirdIndicator, fourthIndicator]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true   //
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        self.addSubview(viewDivider)
        viewDivider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        viewDivider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        viewDivider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        viewDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        viewDivider.backgroundColor = PopmetricsColor.dividerBorder

    }
    
    func changeValueSection(value: Int, section: Int) {
        if section > views.count { return }
        let indicatorTop = views[section]
        indicatorTop.changeValue(value)
    }
    
    func changeSection(section: Int) {
        if section > views.count { return }
        unselectAllImages()
        changeImageSelectedForSection(section: section)
    }
    
    private func changeImageSelectedForSection(section: Int) {
        let indicatorTopView = views[section]
        indicatorTopView.changeImage(imagesSelected[section])
    }
    
    func unselectAllImages() {
        for (index, value) in views.enumerated() {
            views[index].changeImage(imagesUnselected[index])
        }
    }
    
    func setActive(section: StatusArticle) {
        switch section {
        case .unapproved:

            return
        case .failed:
            return
        case .completed:

            return
        default:
            return
        }
    }
}
