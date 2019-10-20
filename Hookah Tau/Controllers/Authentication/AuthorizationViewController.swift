//
//  Extension+UIVC.swift
//  Hookah Tau
//
//  Created by Daria Rednikina on 05/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit



class AuthorizationViewController: BaseViewController {
    
    // MARK: - Properties
    
    var titleTextView: TitleTextView?
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        constaintContentViewToSuperview(authView: contentView)
        
        setUpKeyboard()
        
        view.layoutIfNeeded()
    }

    // MARK: - Views

    private func constaintContentViewToSuperview(authView: UIView) {
        view.addSubview(authView)

        authView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            authView.widthAnchor.constraint(equalToConstant: 374),
            authView.heightAnchor.constraint(equalToConstant: 219)
        ])
    }
    
    func setUpContentView(withModel model: RegistationViewModel) {
        titleTextView = TitleTextView.loadFromNib()
        
        titleTextView?.bind(model: model)
        contentView.addSubviewThatFills(titleTextView)
    }
    
    
}
