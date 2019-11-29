//
//  MapButtonStyle.swift
//  Hookah Tau
//
//  Created by cstore on 18/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class TableStyle {
    
    static func setStripes(for view: UIView) {
        let replicationLayer = createReplicatorLayer()
        replicationLayer.frame = view.bounds
        replicationLayer.frame.origin.x = -100

        view.layer.masksToBounds = true
        view.layer.addSublayer(replicationLayer)
    }
    
    private static func createReplicatorLayer() -> CAReplicatorLayer {
        let replicatorLayer = CAReplicatorLayer()

        let stripe = CALayer()

        stripe.frame = CGRect(x: 0, y: -10, width: 2, height: 500)
        stripe.backgroundColor = UIColor.black.cgColor
        stripe.transform = CATransform3DMakeRotation(0.52, 0, 0, 1.0)

        replicatorLayer.instanceCount = 60
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        replicatorLayer.addSublayer(stripe)

        return replicatorLayer
    }
    
}


class TableButtonStyle {
    enum Constants {
        static let cornerRadius: CGFloat = 8
        static let clearColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    enum Selection {
        static let borderColor: CGColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        static let borderWidth: CGFloat = 3
        static let fillColor = #colorLiteral(red: 0.2078431373, green: 0.5215686275, blue: 0.8862745098, alpha: 0.5)
    }
    
    enum Booked {
        static let fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
    }
    
    func setSelected(button: TableButton) {
        button.layer.borderWidth = Selection.borderWidth
        button.layer.borderColor = Selection.borderColor
        button.backgroundColor = Selection.fillColor
    }
    
    func setBooked(button: TableButton) {
        button.backgroundColor = Booked.fillColor
    }
    
    func setAvaliable(button: TableButton) {
        button.layer.sublayers?.removeAll()
        button.backgroundColor = button.isChosen ? Selection.fillColor : Constants.clearColor
    }
    
    func setUnselected(button: TableButton) {
        button.layer.borderWidth = 0
        button.backgroundColor = button.isBooked ? Booked.fillColor : Constants.clearColor
    }
}

// MARK: - ButtonStyle

extension TableButtonStyle {
    
    func apply(to button: TableButton?) {
        button?.layer.cornerRadius = Constants.cornerRadius
        button?.style = self
    }
    
}
