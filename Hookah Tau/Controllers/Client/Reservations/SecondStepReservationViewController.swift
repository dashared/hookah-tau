//
//  SecondStepReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 21/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class SecondStepReservationViewController: BaseViewController {

    // MARK: - Properties
    
    weak var coordinator: SecondStepReservationCoordinator?
    
    @IBOutlet weak var childContentView: UIView!
    
    var secondStepView: SecondStepView?
    
    /// map view from the previous screen
    var mapView: MapImageScroll? 
    
    var model: SecondStepModel?
    
    /// booked periods for this table for this date
    var bookedPeriods: [ReservationPeriod] = [] {
        didSet {
            secondStepView?.setUpReservedIntervals(bookedPeriods)
        }
    }
    
    let confirmButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОДТВЕРДИТЬ")
        //button.addTarget(self, action: #selector(doneChanging), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupChildContainer()
        setupButtons()
    
    }
    
    // MARK: - Setup

    func setupChildContainer() {
        
        secondStepView = SecondStepView.loadFromNib()
        childContentView.addSubviewThatFills(secondStepView)
        guard let model = model else { return }
        secondStepView?.bind(model: model)
    }
    
    func setupMap() {
        view.addSubviewThatFills(mapView)
        
        mapView?.isUserInteractionEnabled = false
        mapView?.scrollToTable(table: model?.table ?? 0)
        
        guard let map = mapView else { return  }
        view.sendSubviewToBack(map)
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: cancelButton,
                                rightBtn: confirmButton,
                                constant: -childContentView.frame.height - 20)
        cancelButton.addTarget(self, action: #selector(cancelChange), for: .touchUpInside)
    }
    
    @objc func cancelChange() {
        coordinator?.cancel(mapView)
    }
}
