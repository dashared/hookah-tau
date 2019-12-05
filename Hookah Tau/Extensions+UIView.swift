//
//  Extensions+UIView.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 05/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

public protocol LoadableNib: UIView {}

private extension LoadableNib {
    static func fromNib() -> Self? {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            assert(false, "Unable to create \(self)")
            return UIView() as? Self
        }

        let bundle = Bundle(for: self)

        return bundle.loadNibNamed(className, owner: nil)?.first as? Self
    }
}

// MARK: - Load from nib ext

extension UIView: LoadableNib {
    public static func loadFromNib() -> Self? {
        return self.fromNib()
    }
}

// MARK: - Subview for view

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
    
    func centerSubview(_ view: UIView?) {
        guard let view = view else {
            assert(false, "View mustn't be nil")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        setNeedsLayout()
        layoutIfNeeded()
    }
}


