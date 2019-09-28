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
