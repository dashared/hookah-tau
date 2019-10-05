//
//  Extension+UIVC.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 05/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit



class AuthorizationViewController: UIViewController {

    // MARK: - Views

    func constaintContentViewToSuperview(view: UIView, superview: UIView) {
        superview.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 374).isActive = true
        view.heightAnchor.constraint(equalToConstant: 219).isActive = true
    }

    func addOneButton(button: Button) {
        
    }

    func addStackViewWithButton(fst: Button, snd: Button) {

    }
}
