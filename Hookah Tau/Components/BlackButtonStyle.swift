//
//  BlackButton.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class BlackButtonStyle: NSObject {
    let cornerRadius = CGFloat(20.0)
    let font = UIFont.smallCapsSystemFont(ofSize: 17, weight: .bold)
    let backgroundColor = UIColor.black
    let fontColor = UIColor.white
    let borderWidth = CGFloat(5.0)
    var subviewLayer: UIView?

    func changeToLoadingStyle(button: Button) {
        let view = UIView(frame: button.frame)
        subviewLayer = view
        
        view.layer.frame = button.frame
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = backgroundColor.cgColor

        let replicationLayer = createReplicatorLayer()
        replicationLayer.frame = button.bounds
        replicationLayer.frame.origin.x = -100

        view.layer.masksToBounds = true
        view.layer.addSublayer(replicationLayer)

        view.backgroundColor = .clear
        view.layer.addSublayer(replicationLayer)
        view.isUserInteractionEnabled = false
        
        button.addSubviewThatFills(view)
    }
    
    func backToNormalStyle(button: Button) {
        subviewLayer?.removeFromSuperview()
    }
}

extension BlackButtonStyle: ButtonStyle {

    /// Basic style for button: color, corner radius, title
    func apply(to button: Button?, withTitle title: String? = nil) {
        guard let button = button else { return }
        button.style = self
        
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .black
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 0, height: 4)

        guard let title = title else { return }

        let customizedText = NSMutableAttributedString.createStrokedText(withTitle: title, font: font)
        button.setAttributedTitle(customizedText, for: .normal)
    }
}

// MARK: - Private

extension BlackButtonStyle {
    private func createReplicatorLayer() -> CAReplicatorLayer {
        let replicatorLayer = CAReplicatorLayer()

        let stripe = CALayer()

        let animation = CABasicAnimation.init(keyPath: "position.x")
        animation.fromValue = stripe.position.x
        animation.toValue = stripe.position.x + 100
        animation.duration = 2
        animation.repeatCount = .infinity
        stripe.add(animation, forKey: "position.x")

        stripe.frame = CGRect(x: 0, y: -10, width: 5, height: 100)
        stripe.backgroundColor = UIColor.white.cgColor
        stripe.transform = CATransform3DMakeRotation(0.52, 0, 0, 1.0)

        replicatorLayer.instanceCount = 60
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        replicatorLayer.addSublayer(stripe)

        return replicatorLayer
    }
}

