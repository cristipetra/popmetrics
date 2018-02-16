//
//  LoadMoreView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class LoadMoreView: UIView {

    @IBOutlet weak var btnLoadMore: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet var contentView: LoadMoreView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        loadNib()
    }
    
    func loadNib() {

        Bundle.main.loadNibNamed("LoadMoreView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        DispatchQueue.main.async {
            self.innerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
        addShadowToView(innerView, radius: 3, opacity: 0.6)
    }

}
