//
//  GradientButton.swift
//  CoreAnimationTutorial
//
//  Created by Christian Vershkov on 4/15/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

@IBDesignable class GradientButton: UIButton {
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var isCapsule: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var animationDuration: Double = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let gradient = CAGradientLayer()
    
    private struct Animation {
        static let keyPath = "locations"
        static let key = "LocationsChange"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGradient()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    override open var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += titleEdgeInsets.right + titleEdgeInsets.left
        return intrinsicContentSize
    }
    
    func stopAnimation() {
        gradient.removeAllAnimations()
    }
    
    func startAnimation() {
        gradient.removeAllAnimations()
        updateGradient()
        animateGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        createGradient()
        updateGradient()
    }
}

private extension GradientButton {
    
    func updateGradient() {
        if isCapsule {
            layer.cornerRadius = bounds.height / 2
        } else {
            layer.cornerRadius = cornerRadius
        }
        
        gradient.colors = [startColor.cgColor, endColor.cgColor, startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = [0, 0.20, 0.35, 0.70]
    }
    
    func createGradient() {
        clipsToBounds = true
        gradient.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func animateGradient(toInitialPosition flag: Bool = false) {
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.fromValue = gradient.locations
        animation.toValue = [0.35, 0.7, 1.0, 1.0]
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.delegate = self
        
        gradient.add(animation, forKey: Animation.key)
    }
}

extension GradientButton: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else {
            return
        }
        animateGradient()
    }
}