//
//  BlackButton.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class BlackButtonStyle: NSObject {
    let cornerRadius = CGFloat(5.0)
    let font = UIFont.smallCapsSystemFont(ofSize: 16)
    let backgroundColor = UIColor.black
    let fontColor = UIColor.white

    private func craeteReplicatorLayer() -> CAReplicatorLayer {
        let replicatorLayer = CAReplicatorLayer()

        let stripe = CALayer()

        let animation =  CABasicAnimation.init(keyPath: "position.x")
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

extension BlackButtonStyle: ButtonStyle {

    func apply(to button: Button) {
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        button.titleLabel?.textColor = fontColor
        button.layer.cornerRadius = cornerRadius

        let replicationLayer = craeteReplicatorLayer()
        replicationLayer.frame = button.bounds
        replicationLayer.frame.origin.x = -100

        button.layer.masksToBounds = true
        button.layer.addSublayer(replicationLayer)
    }
}

