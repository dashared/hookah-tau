//
//  ProfileChangeViewController.swift
//  Hookah Tau
//
//  Created by cstore on 16/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

struct ChangeModel {
    var userModel: User
    var editingOption: EditingOption
}

class ProfileChangeViewController: BaseViewController {

    // MARK: - Properties
    
    weak var coordinator: ProfileChangeCoordinator?
    
    var changeModel: ChangeModel?
    
    var changeView: ChangeView?
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ГОТОВО")
        button.addTarget(self, action: #selector(doneChanging), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ")
        button.addTarget(self, action: #selector(cancelChange), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        addStackViewWithButtons(leftBtn: cancelButton, rightBtn: doneButton)
        changeView = ChangeView.loadFromNib()
        
        setUpView()
        setUpKeyboard()
    }
    
    func setUpView() {
        self.view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubviewThatFills(changeView)
        
        guard let model = changeModel else { return }
        changeView?.bind(withModel: model)
    }
    
    
    @objc func cancelChange() {
        coordinator?.discardChange()
    }
    
    @objc func doneChanging() {
        guard let model = changeModel,
              let text = changeView?.textField?.text else { return }
        
        var userModel = model.userModel
        switch model.editingOption {
        case .invite:
            print("New person is added")
            return
        case .name:
            userModel.name = text
        case .phone:
            userModel.phoneNumber = text
        }
        
        coordinator?.update(withModel: userModel)
    }

}
