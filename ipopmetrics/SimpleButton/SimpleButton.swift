//
//  SimpleButton.swift
//  Example
//
//  Created by Andreas Tinoco Lobo on 25.03.15.
//  Copyright (c) 2015 Andreas Tinoco Lobo. All rights reserved.
//

import UIKit


open class SimpleButton: UIButton {
    
    typealias ControlState = UInt
    
    /// Loading view. UIActivityIndicatorView as default
    open var loadingView: UIView?
    
    /// Default duration of animated state change.
    open var defaultAnimationDuration: TimeInterval = 0.1
    
    /// Represents current button state.
    open override var state: UIControlState {
        // injects custom button state if necessary
        if isLoading {
            var options = SimpleButtonControlState.loading
            options.insert(super.state)
            return options
        }
        return super.state
    }
    
    /// used to lock any animated state transition for initial setup
    fileprivate var lockAnimatedUpdate: Bool = true
    
    /// used to determine the `from` value of any animation
    fileprivate var sourceLayer: CALayer {
        return (layer.presentation() ?? layer) 
    }
    
    
    // MARK: Overrides
    
    override open var isEnabled: Bool {
        didSet {
            // manually enables / disables user interaction to restore correct state if loading or enabled state are switched separate or together
            if !isEnabled {
                self.isUserInteractionEnabled = false
            }
            else if !state.contains(SimpleButtonControlState.loading) && isEnabled {
                self.isUserInteractionEnabled = true
            }
            update()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            update()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            update()
        }
    }
    
    // MARK: Custom states
    
    /// A Boolean value that determines the SimpleButton´s loading state.
    /// Specify `true` to switch to the loading state.
    /// If set to `true`, SimpleButton shows `loadingView` and hides the default `titleLabel` and `imageView`
    open var isLoading: Bool = false {
        didSet {
            if isLoading {
                self.isUserInteractionEnabled = false
                if loadingView == nil {
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityIndicator.startAnimating()
                    activityIndicator.hidesWhenStopped = false
                    loadingView = activityIndicator
                    addSubview(loadingView!)
                }
                loadingView?.isHidden = false
                titleLabel?.layer.opacity = 0
                imageView?.isHidden = true
            }
            else {
                if !self.state.contains(.disabled) {
                    isUserInteractionEnabled = true
                }
                loadingView?.isHidden = true
                titleLabel?.layer.opacity = 1
                imageView?.isHidden = false
            }
            update()
        }
    }

    
    // MARK: Initializer
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        lockAnimatedUpdate = true
        configureButtonStyles()
        update()
        lockAnimatedUpdate = false
    }
    
    // MARK: Configuration
    
    /**
    To define various styles for specific button states, override this function and set attributes for specific states (e.g. setBackgroundColor(UIColor.blueColor(), for: .Highlighted, animated: true))
    */
    open func configureButtonStyles() {
    }
    
    
    
    
    /**
    Sets the spacing between `titleLabel` and `imageView`
    
    - parameter spacing: spacing between `titleLabel` and `imageView`
    */
    open func setTitleImageSpacing(_ spacing: CGFloat) {
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing / 2);
        titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, 0);
    }
    
    // MARK: Attribute update helper
    
    /**
    Updates all attributes if necessary. Each update function determines by itself if an update of any attribute is necessary. It also determines if that update should animate.
    
    - parameter lockAnimatedUpdate: set this to true to update without animation, even it´s defined in `SimpleButtonStateChange`. Used to set initial button attributes
    */
    fileprivate func update() {
    }
    
    

    
    // MARK: Animation helper
    fileprivate func animate(layer: CALayer, from: AnyObject?, to: AnyObject, forKey key: String, duration: TimeInterval) {
        let animation = CABasicAnimation()
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        layer.add(animation, forKey: key)
    }
    
    // MARK: Layout
    override open func layoutSubviews() {
        super.layoutSubviews()
        loadingView?.center = CGPoint(x: bounds.size.width  / 2,
            y: bounds.size.height / 2)
    }
}
