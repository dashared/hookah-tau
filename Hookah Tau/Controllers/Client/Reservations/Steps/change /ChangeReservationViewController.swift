//
//  ChangeReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 02/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ChangeReservationViewController: BaseViewController {
    
    // MARK: - IBAOutlets
    
    @IBOutlet weak var childContentView: UIView!
    
    // MARK: - Peoperties
    
    var reservation: Reservation?
    
    var secondStepView: SecondStepView?
    
    var reservationService: ReservationsService?
    
    weak var coordinator: ChangeReservationCoordinator?
    
    // MARK: - Buttons
    
    var confirmButton: Button = {
        var button = Button()
        var style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОДТВЕРДИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationService = ReservationsService(apiClient: APIClient.shared)
        setupButtons()
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setup
    
    func setupButtons() {
       addStackViewWithButtons( rightBtn: confirmButton,
                                constant: -childContentView.frame.height - 20)
        
        confirmButton.addTarget(self, action: #selector(changeReservation), for: .touchUpInside)
    }
    
    // MARK: - Handlers
    
    @objc func changeReservation() {
        guard let r = reservation else { return }
        confirmButton.loading = true
        
        reservationService?.updateReservation(startTime: r.startTime,
                                              numberOfGuests: r.numberOfGuests,
                                              endTime: r.endTime,
                                              uuid: r.uuid,
                                              completion: { [weak self] (res) in
                                                if res {
                                                    self?.coordinator?.finish(r)
                                                } else {
                                                    self?.displayAlert(with: "Что-то пошло не так! Попробуешь еще раз?")
                                                }
                                                
                                                self?.confirmButton.loading = false
        })
    }

}
