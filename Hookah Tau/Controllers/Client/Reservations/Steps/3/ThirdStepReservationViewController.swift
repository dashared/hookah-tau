//
//  ThirdStepReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 23/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ThirdStepReservationViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    
    weak var coordinator: ThirdStepReservationCoordinator?
    
    var thirdStepView: ThirdStepView?
    
    @IBOutlet weak var contentForMap: UIView!
    
    var mapView: MapImageScroll?
    
    var reservation: Reservation?
    
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ БРОНЬ")
        //button.addTarget(self, action: #selector(doneChanging), for: .touchUpInside)
        return button
    }()
    
    let changeButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ИЗМЕНИТЬ")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        setupContainer()
        setupButtons()
        setupMap()
    }
    
    func setupMap() {
        contentForMap.addSubviewThatFills(mapView)
    }
    
    func setupContainer() {
        thirdStepView = ThirdStepView.loadFromNib()
        containerView.addSubviewThatFills(thirdStepView)
//        guard let model = model else { return }
//        thirdStepView?.bind(withModel: model)
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: cancelButton,
                                rightBtn: changeButton,
                                constant: -containerView.frame.height - 20)
        
        changeButton.addTarget(self, action: #selector(change), for: .touchUpInside)
    }
    
    
    // MARK: - handlers for buttons
    
    @objc func change() {
        guard let res = reservation else { return }
        coordinator?.change(res)
    }
    
    @objc func cancel() {
        
    }
}
