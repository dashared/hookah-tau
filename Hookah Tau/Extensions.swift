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
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor

        let smallLettersToSmallCapsAttribute: [UIFontDescriptor.FeatureKey: Int] = [
            .featureIdentifier: kLowerCaseType,
            .typeIdentifier: kLowerCaseSmallCapsSelector
        ]

        let capitalLettersToSmallCapsAttribute: [UIFontDescriptor.FeatureKey: Int] = [
            .featureIdentifier: kUpperCaseType,
            .typeIdentifier: kUpperCaseSmallCapsSelector
        ]

        let newDescriptor = descriptor.addingAttributes([
            .featureSettings: [
                smallLettersToSmallCapsAttribute,
                capitalLettersToSmallCapsAttribute
            ]
            ])

        return UIFont(descriptor: newDescriptor, size: size)
    }
}
