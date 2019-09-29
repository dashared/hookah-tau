//
//  Extension.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 27/09/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

extension UIFont {
    class func smallCapsSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)

        let smallCapsDesc = systemFont.fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector
                ]
            ]
        ])

        let font = UIFont(descriptor: smallCapsDesc, size: systemFont.pointSize)

        return font
    }
}

extension NSMutableAttributedString {
    static func createStrokedText(withTitle title: String, font: UIFont) -> NSMutableAttributedString {
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -2.0,
            NSAttributedString.Key.font: font
            ] as [NSAttributedString.Key: Any]

        let customizedText = NSMutableAttributedString(string: title,
                                                       attributes: strokeTextAttributes)

        return customizedText
    }
}

extension UIView {
    func addSubviewThatFills(_ view: UIView?) {
        guard let view = view else {
            assert(false, "View mustn't be nil")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[v]-(0)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: ["v": view])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[v]-(0)-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["v": view])

        addConstraints(horizontal)
        addConstraints(vertical)

        setNeedsLayout()
        layoutIfNeeded()
    }

    static func loadFromNib() -> UIView? {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            assert(false, "Unable to create \(self)")
            return UIView()
        }

        let bundle = Bundle(for: self)

        return bundle.loadNibNamed(className, owner: nil)?.first as? UIView
    }
}
