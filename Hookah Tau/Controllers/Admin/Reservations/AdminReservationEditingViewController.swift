//
//  AdminReservationEditingViewController.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationEditingViewController: BaseViewController {
    
    // MARK:- IBAOutlets
    
    @IBOutlet weak var tableContentView: UIView!
    
    @IBOutlet weak var mainContentView: UIView!
    
    // MARK:- Properties
    
    var mapView: MapImageScroll?
    
    var reservationView: AdminReservationView?
    
    var reservationData: ReservationWithUser?
    
    weak var coordinator: AdminReservationEditingCoordinator?
    
    var reservationService: ReservationsService?
    
    var reservedPeriods: [ReservationPeriod] = [] {
        didSet {
            setupReservationViewWithIntervals()
        }
    }
    
    var saveButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "СОХРАНИТЬ")
        return button
    }()

    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentViews()
        
        reservationService = ReservationsService(apiClient: APIClient.shared)
        
        loadReservedPeriods()
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup
    
    func setupButtons() {
        addStackViewWithButtons(rightBtn: saveButton,
                                constant: -mainContentView.frame.height - 10)
        
        saveButton.addTarget(self, action: #selector(saveReservation), for: .touchUpInside)
        reservationView?.cancelButton?.addTarget(self, action: #selector(cancelReservation), for: .touchUpInside)
    }

    func setupContentViews() {
        guard
            let model = reservationData
            else { return }
        
        if model.establishment == 1 {
            mapView = MapView1.loadFromNib()
        } else {
            mapView = MapView2.loadFromNib()
        }
        
        navigationItem.title = TotalStorage.standard.getEstablishment(model.establishment)?.address
    
        mapView?.isUserInteractionEnabled = false
        
        tableContentView.addSubviewThatFills(mapView)
        mapView?.scrollToTable(table: model.reservedTable)
        
        reservationView = AdminReservationView.loadFromNib()
        reservationView?.bind(withModel: model)
        
        mainContentView.addSubviewThatFills(reservationView)
    }
    
    func setupReservationViewWithIntervals() {
        reservationView?.bind(withIntervals: reservedPeriods)
    }
    
    func loadReservedPeriods() {
        guard let model = reservationData else { return }
        
        reservationService?.getReservationsAround(uuid: model.uuid, completion: { [weak self] (res) in
            switch res {
            case .failure(let err):
                self?.displayAlert(forError: err)
                return
            case .success(let reserv):
                self?.reservedPeriods = reserv
                return
            }
        })
    }
    
    // MARK:- Handlers
    
    @objc func saveReservation() {
        guard
            let r = reservationView?.data,
            let uuid = reservationData?.uuid
            else { return }
        
        saveButton.loading = true
        
        reservationService?.updateReservation(startTime: r.startTime,
                                              numberOfGuests: r.numberOfGuests,
                                              endTime: r.endTime,
                                              uuid: uuid,
                                              isAdmin: true,
                                              completion: { [weak self] (res) in
                                                if res {
                                                    self?.coordinator?.didEndFlow?()
                                                } else {
                                                    self?.displayAlert(with: "Что-то пошло не так! Попробуешь еще раз?")
                                                }
                                                
                                                self?.saveButton.loading = false
        })
    }
    
    @objc func cancelReservation() {
        guard
        let uuid = reservationData?.uuid
        else { return }
        
        reservationService?.deleteReservation(isAdmin: true, uuid: uuid, completion: { [weak self] (res) in
            if res {
                self?.coordinator?.didEndFlow?()
            } else {
                self?.displayAlert(with: "Что-то пошло не так!\nПопробуешь еще раз?")
            }
        })
    }
}
